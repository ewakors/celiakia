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
    @IBOutlet weak var passwordTxt: PasswordTextField!
    
    var showPassword: Bool!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        passwordTxt.isSecureTextEntry = true
        showPassword = false
        
        registerBtn.layer.cornerRadius = CGFloat(ButtonStyleClass.buttonCornerRadius)
        registerBtn.backgroundColor = ButtonStyleClass.buttonBackgroundColor
        registerBtn.layer.borderColor = ButtonStyleClass.buttonBorderColor
        registerBtn.layer.borderWidth = CGFloat(ButtonStyleClass.buttonBorderWidth)
        
        loginBtn.layer.cornerRadius = CGFloat(ButtonStyleClass.buttonCornerRadius)
        loginBtn.backgroundColor = ButtonStyleClass.buttonBackgroundColor
        loginBtn.layer.borderColor = ButtonStyleClass.buttonBorderColor
        loginBtn.layer.borderWidth = CGFloat(ButtonStyleClass.buttonBorderWidth)
        
        let url = NSURL(string: "https://celiakia.zer0def.me/static/images/logo.png")

        logoImageView.hnk_setImageFromURL(url! as URL)

    }
    
    @IBAction func loginButton(_ sender: Any) {
        
        let request = Router.loginUser(username: usernameTxt.text!, password: passwordTxt.text!)
        
        API.sharedInstance.sendRequest(request: request) { (json, error) in
            if let json = json {
                if error == false {
                    
                    let token = json[Router.keyField].stringValue
                    
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
