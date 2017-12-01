//
//  ChangePasswordViewController.swift
//  loginAndRegister
//
//  Created by Ewa Korszaczuk on 26.04.2017.
//  Copyright © 2017 Ewa Korszaczuk. All rights reserved.
//

import UIKit

class ChangePasswordViewController: UIViewController {
    
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var confirmPasswordTXT: UITextField!
    @IBOutlet weak var newPasswordTXT: UITextField!
    @IBOutlet weak var oldPasswordTXT: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        saveBtn.layer.cornerRadius = CGFloat(ButtonStyleClass.buttonCornerRadius)
        saveBtn.backgroundColor = ButtonStyleClass.buttonBackgroundColor
        saveBtn.layer.borderColor = ButtonStyleClass.buttonBorderColor
        saveBtn.layer.borderWidth = CGFloat(ButtonStyleClass.buttonBorderWidth)
    }
    
    @IBAction func saveButton(_ sender: Any) {
        let request = Router.passwordChange(old_password: oldPasswordTXT.text!, new_password1: newPasswordTXT.text!, new_password2: confirmPasswordTXT.text!)
        
        API.sharedInstance.sendRequest(request: request) { (json, error) in
            if let json = json {
                if error == false {
                    let alertController = UIAlertController(title: "Sukces", message: "Hasło zostało zmienione", preferredStyle: .alert)
                    
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                    
                } else {
                    let warning = Warning(json: json).getError()
                    API.Warning(viewController: self, message: warning)
                }
            }
        }
    }
}
