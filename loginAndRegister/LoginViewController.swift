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
import PasswordTextField

class LoginViewController: UIViewController {
    
    @IBOutlet weak var registerBtn: UIButton!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var usernameTxt: UITextField!
    @IBOutlet weak var logoImageView: UIImageView!
    var showPassword: Bool!
    @IBOutlet weak var passwordTxt: PasswordTextField!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        passwordTxt.isSecureTextEntry = true
        showPassword = false
        
        registerBtn.layer.cornerRadius = 5
        registerBtn.backgroundColor = UIColor.clear
        registerBtn.layer.borderColor = UIColor(red: 108/255.0, green: 176/255.0, blue: 22/255.0, alpha: 1.0).cgColor
        registerBtn.layer.borderWidth = 1.5
        
        loginBtn.layer.cornerRadius = 5
        loginBtn.backgroundColor = UIColor.clear
        loginBtn.layer.borderColor = UIColor(red: 108/255.0, green: 176/255.0, blue: 22/255.0, alpha: 1.0).cgColor
        loginBtn.layer.borderWidth = 1.5        
        
        let url = NSURL(string: "https://celiakia.zer0def.me/static/images/logo.png")

        logoImageView.hnk_setImageFromURL(url! as URL)

    }
    
    @IBAction func loginButton(_ sender: Any) {
        
        let request = Router.loginUser(username: usernameTxt.text!, password: passwordTxt.text!)
        
        API.sharedInstance.sendRequest(request: request) { (json, error) in
            if let json = json {
                if error == false {
                    
                    let token = json["key"].stringValue
                    
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
                    API.Warning(viewController: self, message: warning)
                }
            }
        }
    }
}
