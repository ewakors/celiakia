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
    
    static let userNameField = "username"
    static let userEmailField = "email"
    static let userPasswordField = "password"
    static let userPassword1Field = "password1"
    static let userPassword2Field = "password2"
    static let userNewPassword1Field = "new_password1"
    static let userNewPassword2Field = "new_password2"
    static let userOldPasswordField = "old_password"
    static let userImageURL = "https://celiakia.zer0def.me/static/images/user.png"
    
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
        self.name = json[User.userNameField].stringValue
        self.email = json[User.userEmailField].stringValue
    }
}

