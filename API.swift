//
//  API.swift
//  loginAndRegister
//
//  Created by Ewa Korszaczuk on 19.04.2017.
//  Copyright © 2017 Ewa Korszaczuk. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class API: NSObject {
    
    private override init() {
        super.init()
    }
    
    static let sharedInstance: API = API()
    
    func sendRequest(request: URLRequestConvertible, completion: @escaping (_ json: JSON?, _ error: Bool) -> Void) {
        
        Alamofire.request(request).debugLog().responseJSON { (result) in
            if result.result.isSuccess {
                
                if let response = result.response {
                    
                    let code = response.statusCode
                    
                    if code >= 200 && code < 400 {
                        if let value = result.result.value {
                            let json = JSON(value)
                            completion(json, false)
                        } else {
                            completion(nil, true)
                        }
                    } else {
                        completion(nil, true)
                    }
                }
            }
        }
    }
}
extension Request {
    public func debugLog() -> Self {
        print(self)
        return self
    }
}
