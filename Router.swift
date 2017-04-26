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
    case registerUser(username: String, password1: String, password2: String)
    case userDetails()
    case findProduct(key: String)
    case addNewProduct(name: String, barcode: String, gluten: Bool, category: String)
    
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
        case .findProduct:
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
        case .findProduct(let key):
            return "products/"
        case .addNewProduct(let name, let barcode, let gluten, let category):
            return "products/"
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
            urlRequest = try URLEncoding.default.encode(urlRequest, with: ["username":parameters.username, "password1":(parameters.password1), "password2":parameters.password2])
         
        case .userDetails():
            urlRequest = try URLEncoding.default.encode(urlRequest, with: nil)
        case .findProduct(let key):
            urlRequest = try URLEncoding.default.encode(urlRequest, with: ["key":key])

        case .addNewProduct(let parameters):
            urlRequest = try URLEncoding.default.encode(urlRequest, with: ["name":parameters.name, "bar_code":(parameters.barcode), "gluten_free":parameters.gluten, "category":parameters.category])
        }
        
        return urlRequest
    }
}

