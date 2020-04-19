//
//  LoginResponse.swift
//  OnTheMap
//
//  Created by Santhana Ravi on 13/4/20.
//  Copyright © 2020 org.udacity. All rights reserved.
//

import Foundation

struct LoginResponse: Codable {
    
    let account: Account
    let session: Session
}
