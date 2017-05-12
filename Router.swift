//
//  Router.swift
//  loginAndRegister
//
//  Created by Ewa Korszaczuk on 18.04.2017.
//  Copyright © 2017 Ewa Korszaczuk. All rights reserved.
//

import UIKit
import Foundation
import Alamofire
import SwiftyJSON

enum Router: URLRequestConvertible {
    
    static var token = ""
    
    static var addToken = true
    
    case loginUser(username: String, password: String)
    case logout()
    case registerUser(username: String, email: String, password1: String, password2: String)
    case userDetails()
    case passwordReset(email: String)
    case passwordChange(old_password: String, new_password1: String, new_password2: String)
    case findProduct(key: String)
    case getCategory ()
    case addNewProduct(name: String, barcode: String, gluten: Bool, category: Int)
    
    static let baseURLString = "http://127.0.0.1:8000/api/"
    
    var method: HTTPMethod {
        switch self {
        case .loginUser:
            return .post
        case .logout:
            return .post
        case .registerUser:
            return .post
        case .userDetails:
            return .get
        case .passwordReset:
            return .post
        case .passwordChange:
            return .post
        case .findProduct:
            return .get
        case .getCategory:
            return .get
        case .addNewProduct:
            return .post
            
        }
    }
    
    var path: String {
        
        Router.addToken = true
        switch self {
        case .loginUser:
            Router.addToken = false
            return "auth/login/"
        case .logout:
            return "auth/logout/"
        case .registerUser:
            return "registration/"
        case .userDetails:
            return "auth/user/"
        case .passwordReset:
            return "auth/password/reset/"
        case .passwordChange:
            return "auth/password/change/"
        case .findProduct:
            return "products/"
        case .getCategory():
            return "categories/"
        case .addNewProduct:
            return "products/add/"
        }
    }
    
    // MARK: URLRequestConvertible
    
    func asURLRequest() throws -> URLRequest {
     
        let url = try Router.baseURLString.asURL()
        
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        
        urlRequest.httpMethod = method.rawValue
        
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        
        if Router.addToken == true {
            print(Router.token)
            urlRequest.setValue("token \(Router.token)", forHTTPHeaderField: "Authorization")
        }
        
        switch self {
        case .loginUser(let parameters):
            urlRequest = try URLEncoding.default.encode(urlRequest, with: ["username":parameters.username, "password":(parameters.password)])
            
        case .logout():
            urlRequest = try URLEncoding.default.encode(urlRequest, with: nil)
            
        case .registerUser(let parameters):
            urlRequest = try URLEncoding.default.encode(urlRequest, with: ["username":parameters.username,"email":parameters.email, "password1":(parameters.password1), "password2":parameters.password2])
         
        case .userDetails():
            urlRequest = try URLEncoding.default.encode(urlRequest, with: nil)
            
        case .passwordReset(let email):
            urlRequest = try URLEncoding.default.encode(urlRequest, with: ["email":email])
            
        case .passwordChange(let parameters):
            urlRequest = try URLEncoding.default.encode(urlRequest, with: ["ols_password":parameters.old_password, "new_password1":(parameters.new_password1), "new_password2":parameters.new_password2])
            
        case .findProduct(let key):
            urlRequest = try URLEncoding.default.encode(urlRequest, with: ["key":key])
            
        case .getCategory():
            urlRequest = try URLEncoding.default.encode(urlRequest, with: nil)
            
        case .addNewProduct(let parameters):
            print(parameters)
            urlRequest = try URLEncoding.default.encode(urlRequest, with: ["name":parameters.name, "bar_code":(parameters.barcode), "gluten_free":parameters.gluten, "category":parameters.category])
        }
        
        return urlRequest
    }
}

