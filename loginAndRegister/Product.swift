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
    private var gluten: String
    private var category: String
    
    
    init(json: JSON) {
        name = ""
        barcode = ""
        gluten = ""
        category = ""
        fromJSON(json: json)
    }
    
    func getName() -> String {
        return name
    }
    
    func getBarcode () -> String {
        return barcode
    }
    
    func getGluten() -> String {
        return gluten
    }
    
    func getCategory() -> String {
        return category
    }
    
    func fromJSON(json: JSON) {
        name = json["name"].stringValue
        barcode = json["bar_code"].stringValue
        gluten = json["gluten_free"].stringValue
        category = json["category"].stringValue
    }
    
    static func arrayFromJSON(json: JSON) -> [Product] {
        var result = [Product]()
        
        for c in json {
            result.append(Product(json: c.1))
        }
        
        return result
    }
}



