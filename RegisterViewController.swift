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
    
    @IBOutlet weak var password2Txt: UITextField!
    @IBOutlet weak var password1Txt: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var usernameTxt: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        password1Txt.isSecureTextEntry = true
        password2Txt.isSecureTextEntry = true
    }
    
    @IBAction func saveButton(_ sender: Any) {
        let request = Router.registerUser(username: "user2", email: "", password1: "useruser2",password2: "useruser2")
        
        API.sharedInstance.sendRequest(request: request) { (json, error) in
            
            if let json = json {
                if error == false {
                    let alertController = UIAlertController(title: "Success", message: "Register success", preferredStyle: .alert)

                    
                    let defaultAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {(alert :UIAlertAction!) in
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
                        
                    })
                    alertController.addAction(defaultAction)
                    self.present(alertController, animated: true, completion: nil)
                }
                else {
                    
                    let warning = Warning(json: json).getError()
                    API.Warning(delegate: self, message: warning)
                    
                }
            }
        }
    }
}




