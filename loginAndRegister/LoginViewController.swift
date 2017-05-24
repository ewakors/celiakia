//
//  ViewController.swift
//  loginAndRegister
//
//  Created by Ewa Korszaczuk on 18.04.2017.
//  Copyright © 2017 Ewa Korszaczuk. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import IQKeyboardManager

class LoginViewController: UIViewController {

    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var usernameTxt: UITextField!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        
//        if Router.token != "" {
//            print("token \(Router.token)")
//            self.performSegue(withIdentifier: "showApp", sender: nil)
//        }
//        else {
//            print("you must login")
//        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func loginButton(_ sender: Any) {
        
        let request = Router.loginUser(username: "admin", password: "adminadmin1")
        
        API.sharedInstance.sendRequest(request: request) { (json, error) in
           // let error1: Warning = Warning(json: json!)
            if error == false {
                if let json = json {
                    
                    let token = json["key"].stringValue
                    
                    print("-----")
                    print(token)
                    print("-----")
                    
                    UserDefaults.standard.set(token, forKey: AppDelegate.udTokenKey)
                    Router.token = token
                    self.performSegue(withIdentifier: "showApp", sender: nil)
                }
                
            } else {
                /*var temp1 : String! // This is not optional.
                temp1 = error1.getError()
                print(temp1)
                */    
                API.Warning(delegate: self, message: "\(json?["non_field_errors"]))")
                print("login error \(json?["non_field_errors"])")
            }
        }
    }
}

