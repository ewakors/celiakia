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
    static var keyField = "key"
    
    case loginUser(username: String, password: String)
    case logout()
    case registerUser(username: String, email: String, password1: String, password2: String)
    case userDetails()
    case passwordReset(email: String)
    case passwordChange(old_password: String, new_password1: String, new_password2: String)
    case findProduct(key: String)
    case findProductInCategory(key: String, category: Int)
    case categoryProducts(category: Int)
    case getCategory()
    case addNewProduct(name: String, barcode: String, gluten: Bool, category: Int)
    
    static let baseURLString = "https://celiakia.zer0def.me/api/"
//    static let baseURLString = "http://127.0.0.1:8000/api/"
    static let logoImageURL = "https://celiakia.zer0def.me/static/images/logo.png"
    //login supahusah
    //password e91oltvXRieMj9QTdxaF
    
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
        case .findProductInCategory:
            return .get
        case .categoryProducts:
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
            Router.addToken = false
            return "registration/"
        case .userDetails:
            return "auth/user/"
        case .passwordReset:
            return "auth/password/reset/"
        case .passwordChange:
            return "auth/password/change/"
        case .findProduct:
            return "products/"
        case .findProductInCategory:
            return "products/"
        case .categoryProducts:
            return "products/"
        case .getCategory():
            return "categories/"
        case .addNewProduct:
            return "products/new/"
        }
    }
    
    func asURLRequest() throws -> URLRequest {
     
        let url = try Router.baseURLString.asURL()
        
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        
        urlRequest.httpMethod = method.rawValue
        
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        
        if Router.addToken == true {
            urlRequest.setValue("token \(Router.token)", forHTTPHeaderField: "Authorization")
        }
        
        switch self {
        case .loginUser(let parameters):
            urlRequest = try URLEncoding.default.encode(urlRequest, with: [User.userNameField:parameters.username, User.userPasswordField:(parameters.password)])
            
        case .logout():
            urlRequest = try URLEncoding.default.encode(urlRequest, with: nil)
            
        case .registerUser(let parameters):
            urlRequest = try URLEncoding.default.encode(urlRequest, with: [User.userNameField:parameters.username,User.userEmailField:parameters.email, User.userPassword1Field:(parameters.password1), User.userPassword2Field:parameters.password2])
         
        case .userDetails():
            urlRequest = try URLEncoding.default.encode(urlRequest, with: nil)
            
        case .passwordReset(let email):
            urlRequest = try URLEncoding.default.encode(urlRequest, with: [User.userEmailField:email])
            
        case .passwordChange(let parameters):
            urlRequest = try URLEncoding.default.encode(urlRequest, with: [User.userOldPasswordField:parameters.old_password, User.userNewPassword1Field:(parameters.new_password1), User.userNewPassword2Field:parameters.new_password2])
            
        case .findProduct(let key):
            urlRequest = try URLEncoding.default.encode(urlRequest, with: [Router.keyField:key])
            
        case .findProductInCategory(let key, let category):
            urlRequest = try URLEncoding.default.encode(urlRequest, with: [Router.keyField:key, Product.productCategoryField: category])
            
        case .categoryProducts(let category):
            urlRequest = try URLEncoding.default.encode(urlRequest, with: [Product.productCategoryField:category])
            
        case .getCategory():
            urlRequest = try URLEncoding.default.encode(urlRequest, with: nil)
            
        case .addNewProduct(let parameters):
            urlRequest = try URLEncoding.default.encode(urlRequest, with: [Product.productNameField:parameters.name, Product.productBarcodeField:(parameters.barcode), Product.productGlutenField:parameters.gluten, Product.productCategoryField:parameters.category])
        }
        
        return urlRequest
    }
}

