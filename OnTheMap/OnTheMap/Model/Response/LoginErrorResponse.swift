//
//  LoginErrorResponse.swift
//  OnTheMap
//
//  Created by Santhana Ravi on 13/4/20.
//  Copyright © 2020 org.udacity. All rights reserved.
//

import Foundation

struct LoginErrorResponse: Codable {
    let status: Int
    let error: String

}

extension LoginErrorResponse:  LocalizedError {
    var errorDescription: String? {
        return error
    }
    
}
