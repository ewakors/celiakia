//
//  Base.swift
//  loginAndRegister
//
//  Created by Ewa Korszaczuk on 28.04.2017.
//  Copyright © 2017 Ewa Korszaczuk. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON


class Product: MyJSONProtocol {
    typealias T = Product

    private var name: String
    private var barcode: String

    
    init(json: JSON) {
        name = ""
        barcode = ""
        fromJSON(json: json)
    }

    func getName() {
        return name
    }

    func getBarcode () {
        return barcode
    }
    
    func fromJSON(json: JSON) {
        name = json["name"]
    }
}

//var p: Product = Product()
//var p = Product()
