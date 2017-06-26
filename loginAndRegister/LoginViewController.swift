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
    //@IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var usernameTxt: UITextField!
    @IBOutlet weak var logoImageView: UIImageView!
    var showPassword: Bool!
    @IBOutlet weak var passwordTxt: PasswordTextField!
    
    var showPasswordImage = UIImage(named: "eye.png") as UIImage?
    var hidePasswordImage = UIImage(named: "check") as UIImage?
    
    var detailsButton = UIButton(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
    
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
        
        let url = NSURL(string: "http://127.0.0.1:8000/static/images/logo.png")
        logoImageView.hnk_setImageFromURL(url! as URL)
        
        //detailsButton.setImage(showPasswordImage, for: .normal)
       // detailsButton.setTitleColor(UIColor.red, for: .normal)
        //passwordTxt.rightViewMode = UITextFieldViewMode.always
       // passwordTxt.rightView = detailsButton
        //detailsButton.addTarget(self, action: Selector(("loginButton")), for:.touchDown)

    }
    
    
   /* func hideShowPasswordButton() {
        
        var hideShowSize: CGSize = "12345".size(attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: 14.0)])
        var hideShow: UIButton = UIButton(type: UIButtonType.system)
        hideShow.frame = CGRect(x: 0, y: 0, width: hideShowSize.width, height: passwordTxt.frame.size.height)
        hideShow.setImage(showPasswordImage, for: .normal)
        passwordTxt.rightView = hideShow
        passwordTxt.rightViewMode = UITextFieldViewMode.always
        
        hideShow.addTarget(self, action: Selector("btnConnectTouched:"), for:.touchDown)
        hideShow.addSubview(hideShow)
       // hideShow.addTarget(self, action: hideShowPasswordTextField(_:), forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    func hideShowPasswordTextField(sender: AnyObject) {
        
        var hideShow: UIButton = (passwordTxt.rightView as? UIButton)!
        if !passwordTxt.isSecureTextEntry  {
            passwordTxt.isSecureTextEntry  = true
            
            hideShow.setImage(hidePasswordImage, for: UIControlState.normal)
        } else {
            passwordTxt.isSecureTextEntry  = false
            hideShow.setImage(showPasswordImage, for: UIControlState.normal)
        }
        passwordTxt.becomeFirstResponder()
    }*/
    
   /* func btnConnectTouched(sender:UIButton!)
    {
        print("button connect touched")
    }*/
    
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
