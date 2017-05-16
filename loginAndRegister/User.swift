//
//  File.swift
//  loginAndRegister
//
//  Created by Ewa Korszaczuk on 05.05.2017.
//  Copyright © 2017 Ewa Korszaczuk. All rights reserved.
//


import UIKit
import Alamofire
import SwiftyJSON

class User: MyJSONProtocol {
    typealias T = User
    
    private var name: String
    private var email: String
    
    init(json: JSON) {
        name = ""
        email = ""
        fromJSON(json: json)
    }
    
    func getName() -> String {
        return name
    }
    
    func getEmail() -> String {
        return email
    }
    
    func fromJSON(json: JSON)  {
        self.name = json["username"].stringValue
        self.email = json["email"].stringValue
    }
}

