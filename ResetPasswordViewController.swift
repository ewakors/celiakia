//
//  ResetPasswordViewController.swift
//  loginAndRegister
//
//  Created by Ewa Korszaczuk on 26.04.2017.
//  Copyright © 2017 Ewa Korszaczuk. All rights reserved.
//

import UIKit

class ResetPasswordViewController: UIViewController {

    @IBOutlet weak var emailTxt: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func sendButton(_ sender: Any) {
        let request = Router.passwordReset(email: "ewakorszaczuk@vp.pl")
        
        API.sharedInstance.sendRequest(request: request) { (json, error) in
            
            if error == false {
                print(json)
                

            } else {
                print("error reset password")
                
            }
        }
    }


}
