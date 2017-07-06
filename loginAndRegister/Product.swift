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


class Product: MyJSONProtocol {
    typealias T = Product
    
    private var name: String
    private var barcode: String
    private var gluten: Bool
    private var category: String
    private var image: String
    
    
    init(json: JSON) {
        name = ""
        barcode = ""
        gluten = true
        category = ""
        image = ""
        fromJSON(json: json)
    }
    
    func getName() -> String {
        return name
    }
    
    func getBarcode () -> String {
        return barcode
    }
    
    func getGluten() -> Bool {
        return gluten
    }
    
    func getCategory() -> String {
        return category
    }
    
    func getImage() -> String {
        return image
    }
    
    func fromJSON(json: JSON) {
        name = json["name"].stringValue
        barcode = json["bar_code"].stringValue
        gluten = json["gluten_free"].boolValue
        category = json["category"].stringValue
        image = json["image"].stringValue
    }
    
    static func arrayFromJSON(json: JSON) -> [Product] {
        var result = [Product]()
        
        for c in json {
            result.append(Product(json: c.1))
        }
        
        return result
    }
}



