//
//  StudentLocationsResponse.swift
//  OnTheMap
//
//  Created by Santhana Ravi on 19/4/20.
//  Copyright © 2020 org.udacity. All rights reserved.
//

import Foundation

struct StudentLocation: Codable {
    let createdAt: Date
    let firstName: String
    let lastName: String
    let latitude: Double
    let longitude: Double
    let mapString: String
    let mediaURL: String
    let objectId: String
    let uniqueKey: String
    let updatedAt: Date
    
    var dictionary: [String: Any] {
        return [
        "createdAt": createdAt,
        "firstName": firstName,
        "lastName": lastName,
        "latitude": latitude,
        "longitude": longitude,
        "mapString": mapString,
        "mediaURL": mediaURL,
        "objectId": objectId,
        "uniqueKey": uniqueKey,
        "updatedAt": updatedAt
        ]
    }
    
    var nsDictionary: NSDictionary {
        return dictionary as NSDictionary
    }
    

}
