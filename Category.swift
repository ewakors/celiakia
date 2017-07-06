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

class Category: MyJSONProtocol {
    typealias T = Category
    
    static let categoryIdField = "id"
    static let categoryNameField = "name"
    static let categoryImageField = "image"
    private var id: Int
    private var name: String
    private var image: String
    
    init(json: JSON) {
        id = 0
        name = ""
        image = ""
        fromJSON(json: json)
    }

    func getId() -> Int {
        return id
    }
    
    func getName() -> String {
        return name
    }
    
    func getImage() -> String {
        return image
    }
    
    func fromJSON(json: JSON) {
        self.id = json[Category.categoryIdField].intValue
        self.name = json[Category.categoryNameField].stringValue
        self.image = json[Category.categoryImageField].stringValue
    }
    
    static func arrayFromJSON(json: JSON) -> [Category] {
        var result = [Category]()
        
        for c in json {
            result.append(Category(json: c.1))
        }
        
        return result
    }
}
