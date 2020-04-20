//
//  UdacityClient.swift
//  OnTheMap
//
//  Created by Santhana Ravi on 12/4/20.
//  Copyright © 2020 org.udacity. All rights reserved.
//

import Foundation

class UdacityClient {
    enum Endpoints {
        static let base = "https://onthemap-api.udacity.com/v1"
        
        case session
        case studentLocation
        
        var stringValue: String {
            switch self {
            case .session:
                return Endpoints.base + "/session"
            case .studentLocation:
                return Endpoints.base + "/StudentLocation?order=-updatedAt"
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
    }

    enum DateError: String, Error {
        case invalidDate
    }
    
    class func taskForGETRequest<ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, completion: @escaping (ResponseType?, Error?) -> Void) -> URLSessionDataTask {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            let decoder = JSONDecoder()

            do {
                try setDateDecodingStrategy(decoder)
//                print(String(data: data, encoding: String.Encoding.utf8))
//                print(String(data: data.suffix(from: 5), encoding: String.Encoding.utf8))
                let responseObject = try decoder.decode(ResponseType.self, from: data)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                print("1 error: \(error)")
                do {
                    let errorResponse = try decoder.decode(LoginErrorResponse.self, from: data) as Error
                    DispatchQueue.main.async {
                        completion(nil, errorResponse)
                    }
                } catch {
                    print("2 error: \(error)")
                    DispatchQueue.main.async {
                        completion(nil, error)
                    }
                }
            }
        }
        task.resume()
        
        return task
    }

    
    class func setDateDecodingStrategy(_ decoder: JSONDecoder) throws {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        
        decoder.dateDecodingStrategy = .custom({ (decoder) -> Date in
            let container = try decoder.singleValueContainer()
            let dateStr = try container.decode(String.self)
            
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
            if let date = formatter.date(from: dateStr) {
                return date
            }
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssXXXXX"
            if let date = formatter.date(from: dateStr) {
                return date
            }
            throw DateError.invalidDate
            
        })
    }
    
    class func taskForPOSTRequest<RequestType: Encodable, ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, body: RequestType, completion: @escaping (ResponseType?, Error?) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        do {
            let httpBody =  try JSONEncoder().encode(body)
            let jsonString = String(data: httpBody, encoding: String.Encoding.utf8)
//            print("try! JSONEncoder().encode(body): \(jsonString ?? "")")
            
            request.httpBody = httpBody
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data else {
                    DispatchQueue.main.async {
                        completion(nil, error)
                    }
                    return
                }
                
                let decoder = JSONDecoder()
                do {
//                    print("response: \(String(data: data.suffix(from: 5), encoding: String.Encoding.utf8) ?? "")")
                    
                    try setDateDecodingStrategy(decoder)
                    let responseObject = try decoder.decode(ResponseType.self, from: data.suffix(from: 5))
                    print(responseObject)
                    DispatchQueue.main.async {
                        completion(responseObject, nil)
                    }
                } catch {
                    
                    do {
                        print(error)
//                        print("response: \(String(data: data.suffix(from: 5), encoding: String.Encoding.utf8) ?? "")")

                        let responseObject = try decoder.decode(LoginErrorResponse.self, from: data.suffix(from: 5))
                        DispatchQueue.main.async {
                            print("sending response errro")
                            completion(nil, responseObject)
                        }
                    } catch {
//                        print("error!!!")
//
//                        print(error)
                        DispatchQueue.main.async {
                            completion(nil, error)
                        }
                        
                    }
                }
                //                print("return data: \(String(data: data, encoding: String.Encoding.utf8))")
                
            }
            task.resume()
            
        } catch {
            print("unable to encode http body")
        }
        
    }
    
    class func login(username: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
        let body = UdacityLoginRequest(udacity: LoginRequest(username: username, password: password))
        taskForPOSTRequest(url: Endpoints.session.url, responseType: LoginResponse.self, body: body) { response, error in
            if let response = response {
                completion(true, nil)
            } else {
                completion(false, error)
            }
        }
    }
    
    class func getStudentLocations(completion: @escaping (StudentLocationResults?, Error?) -> Void) -> Void {
        taskForGETRequest(url: Endpoints.studentLocation.url, responseType: StudentLocationResults.self) { (response, error) in
            if let response = response {
//                print(response)
                completion(response, nil)
            } else {
//                print("error: \(error)")
                completion(nil, error)
            }
        }
    }

}
