//
//  Error.swift
//  loginAndRegister
//
//  Created by Ewa Korszaczuk on 22.05.2017.
//  Copyright © 2017 Ewa Korszaczuk. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class Warning: MyJSONProtocol {
    typealias T = Warning

    private var error: String
    
    init(json: JSON) {
        error = ""
        fromJSON(json: json)
    }
    
    func getError() -> String {
        return error
    }
    
    func fromJSON(json: JSON)  {
        self.error = json["non_field_errors"].stringValue
        print(json["non_field_errors"])
    }
}
