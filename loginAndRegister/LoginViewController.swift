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
    
    @IBOutlet weak var registerBtn: UIButton!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var usernameTxt: UITextField!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordTxt.isSecureTextEntry = true
        registerBtn.layer.cornerRadius = 10
        loginBtn.layer.cornerRadius = 10
    }
    
    @IBAction func loginButton(_ sender: Any) {
        
        let request = Router.loginUser(username: "admin", password: "adminadmin1")
        
        API.sharedInstance.sendRequest(request: request) { (json, error) in
            if let json = json {
                if error == false {
                    
                    let token = json["key"].stringValue
                    
                    print("-----")
                    print(token)
                    print("-----")
                    
                    UserDefaults.standard.set(token, forKey: AppDelegate.udTokenKey)
                    Router.token = token
                    
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    appDelegate.window = UIWindow(frame: UIScreen.main.bounds)
                    let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let yourVC = mainStoryboard.instantiateViewController(withIdentifier: "TabBarViewController") as! TabBarViewController
                    appDelegate.window?.rootViewController = yourVC
                    appDelegate.window?.makeKeyAndVisible()
                    
                } else {                    
                    let warning = Warning(json: json).getError()
                    API.Warning(delegate: self, message: warning)
                }
            }
        }
    }
}

