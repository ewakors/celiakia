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
    
    static let errorWarningField = "non_field_errors"
    static let errorPasswordField = "password"
    static let errorPassword1Field = "password1"
    static let errorPassword2Field = "password2"
    static let errorDetailField = "detail"
    static let errorNewPassword1Field = "new_password1"
    static let errorNewPassword2Field = "new_password2"
    
    private var error: String
    
    init(json: JSON) {
        error = ""
        fromJSON(json: json)
    }
    
    func getError() -> String {
        return error
    }
    
    func fromJSON(json: JSON)  {
        
        print(json)
        
        let warning = json[Warning.errorWarningField]
        let password = json[Warning.errorPasswordField]
        let username = json[User.userNameField]
        let email = json[User.userEmailField]
        let detail = json[Warning.errorDetailField]
        let name = json[Product.productNameField]
        let category = json[Product.productCategoryField]
        let barcode = json[Product.productBarcodeField]
        let new_password1 = json[Warning.errorNewPassword1Field]
        let new_password2 = json[Warning.errorNewPassword2Field]
        let password2 = json[Warning.errorPassword2Field]
        let password1 = json[Warning.errorPassword1Field]
        
        var result = "\n"
        
        for e in warning {
            result += "Login lub hasło nieprawidłowe."
        }
        
        for e in password {
            result += "Hasła nie są zgodne"
        }
        
        for e in username {
            result += "Użytkownik o takiej nazwie już istnieje."
//            result += "Nazwa użytkownika nieprawidłowa. \(e.1.stringValue)\n"
        }
        
        for e in email {
            result += "\(e.1.stringValue)\n"
        }
        
        for e in detail {
            result += "Szczegóły \(e.1.stringValue)\n"
        }
        
        for e in name {
            result += "Nieprawidłowa nazwa produktu. \(e.1.stringValue)"
        }
        
        for e in category {
            result += "Nieprawidłowa kategoria produktu . \(e.1.stringValue)"
        }
        
        for e in barcode {
            result += "Produkt o podanym kodzie kreskowym już istnieje."
            //result += "Nieprawidłowy kod kreskowy. \(e.1.stringValue)\n"
        }
        
        for e in new_password1 {
            result += "Błędne nowe hasło. \(e.1.stringValue)\n"
        }
        
        for e in new_password2 {
            result += "Niezgodne hasła. " //\(e.1.stringValue)\n
        }
        
        for e in password1 {
            result += "Nieprawidłowe hasło. Hasło musi składać się z co najmniej 8 znaków."
        }
        
        for e in password2 {
            result += "Niezgodne hasła. "//\(e.1.stringValue)\n
        }
        
        self.error = result
    }
}

