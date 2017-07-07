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
    
    static let productNameField = "name"
    static let productBarcodeField = "bar_code"
    static let productGlutenField = "gluten_free"
    static let productCategoryField = "category"
    static let productImageField = "image"
    static let productGlutenImageField = "gluten_free_image"
    static let showProductDetails2Segue = "showProductDetails2Segue"
    static let addProductSegue = "addProductSegue"
    static let glutenFreeTextField = "Gluten FREE"
    static let glutenTextField = "Gluten"
    
    private var name: String
    private var barcode: String
    private var gluten: Bool
    private var category: String
    private var image: String
    private var glutenImage: String
    
    
    init(json: JSON) {
        name = ""
        barcode = ""
        gluten = true
        category = ""
        image = ""
        glutenImage = ""
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
    
    func getGlutenImage() -> String {
        return glutenImage
    }
    
    func fromJSON(json: JSON) {
        name = json[Product.productNameField].stringValue
        barcode = json[Product.productBarcodeField].stringValue
        gluten = json[Product.productGlutenField].boolValue
        category = json[Product.productCategoryField].stringValue
        image = json[Product.productImageField].stringValue
        glutenImage = json[Product.productGlutenImageField].stringValue
    }
    
    static func arrayFromJSON(json: JSON) -> [Product] {
        var result = [Product]()
        
        for c in json {
            result.append(Product(json: c.1))
        }
        
        return result
    }
}



