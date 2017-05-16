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
        
        let request = Router.loginUser(username: "root", password: "rootroot")
        
        API.sharedInstance.sendRequest(request: request) { (json, error) in
            
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
//                print(json?["msg"].stringValue)
//                let alertController = UIAlertController(title: "Error", message: "Login or password failed", preferredStyle: .alert)
//                
//                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
//                alertController.addAction(defaultAction)
//                
//                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
}

