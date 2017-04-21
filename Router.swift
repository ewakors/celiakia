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
    case registerUser(username: String, password1: String, password2: String)
    case findProductByBarcode(barcode: String)
    case findProductByName(name: String)
    case findProductByBarcodeAndName(barcode: String, name: String)
    case addNewProduct(name: String, barcode: String, gluten: Bool, category: String)

    
    static let baseURLString = "http://127.0.0.1:8000/api/"
    
    var method: HTTPMethod {
        switch self {
        case .loginUser:
            return .post
        case .registerUser:
            return .post
        case .findProductByBarcode:
            return .get
        case .findProductByName:
            return .get
        case .findProductByBarcodeAndName:
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
        case .registerUser:
            Router.addToken = false
            return "registration/"
        case .findProductByBarcode(let barcode):
            Router.addToken = false
            return "products/"
        case .findProductByName(let name):
            Router.addToken = false
            return "products/"
        case .findProductByBarcodeAndName(let barcode, let name):
            Router.addToken = false
            return "products/"
        case .addNewProduct(let name, let barcode, let gluten, let category):
            Router.addToken = false
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
            urlRequest.setValue("token \(Router.token)", forHTTPHeaderField: "Authorization")
        }
        
        switch self {
        case .loginUser(let parameters):
            urlRequest = try URLEncoding.default.encode(urlRequest, with: ["username":parameters.username, "password":(parameters.password)])

        case .registerUser(let parameters):
            urlRequest = try URLEncoding.default.encode(urlRequest, with: ["username":parameters.username, "password1":(parameters.password1), "password2":parameters.password2])
            
        case .findProductByBarcode(let barcode):
            urlRequest = try URLEncoding.default.encode(urlRequest, with: ["barcode":barcode])
            
        case .findProductByName(let name):
            urlRequest = try URLEncoding.default.encode(urlRequest, with: ["name":name])
            
        case .findProductByBarcodeAndName(let parameters):
            urlRequest = try URLEncoding.default.encode(urlRequest, with: ["barcode": parameters.barcode, "name": parameters.name])

        case .addNewProduct(let parameters):
            urlRequest = try URLEncoding.default.encode(urlRequest, with: ["name":parameters.name, "bar_code":(parameters.barcode), "gluten_free":parameters.gluten, "category":parameters.category])
        }
        
        return urlRequest
    }
}

