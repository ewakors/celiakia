//
//  RegisterViewController.swift
//  loginAndRegister
//
//  Created by Ewa Korszaczuk on 18.04.2017.
//  Copyright © 2017 Ewa Korszaczuk. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import IQKeyboardManager

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var password2Txt: UITextField!
    @IBOutlet weak var password1Txt: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet var usernameTxt: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        password1Txt.isSecureTextEntry = true
        password2Txt.isSecureTextEntry = true
        
        registerButton.layer.cornerRadius = CGFloat(ButtonStyleClass.buttonCornerRadius)
        registerButton.backgroundColor = ButtonStyleClass.buttonBackgroundColor
        registerButton.layer.borderColor = ButtonStyleClass.buttonBorderColor
        registerButton.layer.borderWidth = CGFloat(ButtonStyleClass.buttonBorderWidth)
    }
    
    @IBAction func registerButton(_ sender: Any) {
        let request = Router.registerUser(username: usernameTxt.text!, email: emailTxt.text!, password1: password1Txt.text! ,password2: password2Txt.text!)
        
        API.sharedInstance.sendRequest(request: request) { (json, error) in
            
            if let json = json {
                if error == false {
                    let alertController = UIAlertController(title: "Success", message: "Register success", preferredStyle: .alert)
                    
                    let defaultAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {(alert :UIAlertAction!) in
                        let token = json[Router.keyField].stringValue
                        
                        UserDefaults.standard.set(token, forKey: AppDelegate.udTokenKey)
                        Router.token = token
                        
                        let appDelegate = UIApplication.shared.delegate as! AppDelegate
                        appDelegate.window = UIWindow(frame: UIScreen.main.bounds)
                        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                        let yourVC = mainStoryboard.instantiateViewController(withIdentifier: "TabBarViewController") as! TabBarViewController
                        appDelegate.window?.rootViewController = yourVC
                        appDelegate.window?.makeKeyAndVisible()
                        
                    })
                    alertController.addAction(defaultAction)
                    self.present(alertController, animated: true, completion: nil)
                }
                else {                    
                    let warning = Warning(json: json).getError()
                    API.Warning(viewController: self, message: warning)
                }
            }
        }

    }
}




