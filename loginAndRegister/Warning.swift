//
//  Error.swift
//  loginAndRegister
//
//  Created by Ewa Korszaczuk on 22.05.2017.
//  Copyright © 2017 Ewa Korszaczuk. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class Warning: MyJSONProtocol {
    typealias T = Warning
    
    private var error: String
    
    init(json: JSON) {
        error = ""
        fromJSON(json: json)
    }
    
    func getError() -> String {
        return error
    }
    
    func fromJSON(json: JSON)  {
        
        print(json)
        
        let warning = json["non_field_errors"]
        let password = json["password"]
        let username = json["username"]
        let email = json["email"]
        let detail = json["detail"]
        
        var result = "\n"
        
        for e in warning {
            result += "Login or password failed. \(e.1.stringValue)"
        }
        
        for e in password {
            result += "Login or password failed. \(e.1.stringValue)"
        }
        
        for e in username {
            result += "\(e.1.stringValue)\n"
        }
        
        for e in email {
            result += "\(e.1.stringValue)\n"
        }
        
        for e in detail {
            result += "\(e.1.stringValue)\n"
        }
        self.error = result
    }
}

