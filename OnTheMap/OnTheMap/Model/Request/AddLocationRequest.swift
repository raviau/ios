//
//  AddLocationRequest.swift
//  OnTheMap
//
//  Created by Santhana Ravi on 21/4/20.
//  Copyright © 2020 org.udacity. All rights reserved.
//

import Foundation

struct AddLocationRequest: Codable {
    let uniqueKey: String
    let firstName: String
    let lastName: String
    let mapString: String
    let mediaURL: String
    let latitude: Double
    let longitude: Double
}
