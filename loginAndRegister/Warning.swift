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
        let name = json["name"]
        let category = json["category"]
        let barcode = json["bar_code"]
        let new_password1 = json["new_password1"]
        let new_password2 = json["new_password2"]
        let password2 = json["password2"]
        let password1 = json["password1"]
        
        var result = "\n"
        
        for e in warning {
            result += "Login or password failed. \(e.1.stringValue)"
        }
        
        for e in password {
            result += "Login or password failed. \(e.1.stringValue)"
        }
        
        for e in username {
            result += "Username failed. \(e.1.stringValue)\n"
        }
        
        for e in email {
            result += "\(e.1.stringValue)\n"
        }
        
        for e in detail {
            result += "details \(e.1.stringValue)\n"
        }
        
        for e in name {
            result += "Product name failed. \(e.1.stringValue)"
        }
        
        for e in category {
            result += "Product category failed. \(e.1.stringValue)"
        }
        
        for e in barcode {
            result += "Product barcode failed. \(e.1.stringValue)\n"
        }
        
        for e in new_password1 {
            result += "New password error. \(e.1.stringValue)\n"
        }
        
        for e in new_password2 {
            result += "Confirm password error. \(e.1.stringValue)\n"
        }
        
        for e in password1 {
            result += "Password field. \(e.1.stringValue)\n"
        }
        
        for e in password2 {
            result += "Confirm password field. \(e.1.stringValue)\n"
        }
        
        self.error = result
    }
}

