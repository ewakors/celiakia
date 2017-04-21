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

class RegisterViewController: UIViewController {

    @IBOutlet weak var password2Txt: UITextField!
    @IBOutlet weak var password1Txt: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var usernameTxt: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func registerButton(_ sender: Any) {
        registerUser(username: "newUser", password1: "newuser123", password2: "naweuser123")
        
    }

    
    func registerUser(username: String, password1: String, password2: String) {
        
        Alamofire.request(Router.registerUser(username: "newUser", password1: "newuser123", password2: "newuser123")
            
            ).responseJSON { (result) in
                //                print(result.request)  // original URL request
                //                print(result.response) // URL response
                //                print(result.data)     // server data
                //                print(result.result)
                if result.result.isSuccess {
                    if let value = result.result.value {
                        let json = JSON(value)
                        
                        
                        let failure = { (error: Error) in print(error) }
                        print(json)
                        
                    }
                }
        }
    }

    
}
