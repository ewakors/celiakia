//
//  RegisterViewController.swift
//  loginAndRegister
//
//  Created by Ewa Korszaczuk on 18.04.2017.
//  Copyright © 2017 Ewa Korszaczuk. All rights reserved.
//

import UIKit
import UIKit
import Alamofire
import SwiftyJSON
import IQKeyboardManager

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var password2Txt: UITextField!
    @IBOutlet weak var password1Txt: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var usernameTxt: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    class func getResult(result: String) -> String {
        return result
    }
    
    @IBAction func saveButton(_ sender: Any) {
        let request = Router.registerUser(username: "user", email: "user@wp.pl", password1: "useruser1",password2: "useruser1")
        
        API.sharedInstance.sendRequest(request: request) { (json, error) in
            
            if error == false {
                //                print(json)
                let alertController = UIAlertController(title: "Success", message: "Register success", preferredStyle: .alert)
                
                // let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                //alertController.addAction(defaultAction)
                
                let defaultAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {(alert :UIAlertAction!) in
                    self.performSegue(withIdentifier: "registerSuccessSegue", sender: nil)
                })
                alertController.addAction(defaultAction)
                self.present(alertController, animated: true, completion: nil)
                
            } else {                
                //API.Warning(delegate: self, message: warning.getError())
            }
        }
    }
}



