//
//  ChangePasswordViewController.swift
//  loginAndRegister
//
//  Created by Ewa Korszaczuk on 26.04.2017.
//  Copyright © 2017 Ewa Korszaczuk. All rights reserved.
//

import UIKit

class ChangePasswordViewController: UIViewController {

    @IBOutlet weak var confirmPasswordTXT: UITextField!
    @IBOutlet weak var newPasswordTXT: UITextField!
    @IBOutlet weak var oldPasswordTXT: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func saveButton(_ sender: Any) {
        let request = Router.passwordChange(old_password: "ewaewa123", new_password1: "ewaewa1234", new_password2: "ewaewa1234")
        
        API.sharedInstance.sendRequest(request: request) { (json, error) in
            
            if error == false {
                print(json)
                let alertController = UIAlertController(title: "Success", message: "Password changed", preferredStyle: .alert)
                
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                
                self.present(alertController, animated: true, completion: nil)
                
            } else {
                print("error change password \(json?["email"].stringValue)")
                let alertController = UIAlertController(title: "Error", message: "error", preferredStyle: .alert)
                
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                
                self.present(alertController, animated: true, completion: nil)
            }
        }

    }
    
}
