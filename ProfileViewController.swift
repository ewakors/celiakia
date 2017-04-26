//
//  ProfileViewController.swift
//  loginAndRegister
//
//  Created by Ewa Korszaczuk on 24.04.2017.
//  Copyright © 2017 Ewa Korszaczuk. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameLabel.text = ""
        emailLabel.text = ""
        userDetails()
    }
    
    func userDetails()
    {
        let request = Router.userDetails()
        
        API.sharedInstance.sendRequest(request: request) { (json, error) in
            
            if error == false {
                print(json)
                
                self.usernameLabel.text = (json!["username"].stringValue)
                self.emailLabel.text = json?["email"].stringValue
                print(self.usernameLabel.text)
            } else {
                print("error user details")
 
            }
        }
    }
    @IBAction func logoutButton(_ sender: Any) {
        let alertController = UIAlertController(title: "Do you want logout?", message: nil, preferredStyle: .alert)
        
        let yesAction = UIAlertAction(title: "YES", style: UIAlertActionStyle.default, handler: {(alert :UIAlertAction!) in

            let request = Router.logout()
            
            API.sharedInstance.sendRequest(request: request) { (json, error) in
                
                if error == false {
                    print("logout toke: \(Router.token)")
                    print(json?["detail"].stringValue)

                    let alertController = UIAlertController(title: "Success", message: "Logout success", preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: {(alert :UIAlertAction!) in
                     self.performSegue(withIdentifier: "logoutSegue", sender: nil)
                    })
                    alertController.addAction(defaultAction)
                    self.present(alertController, animated: true, completion: nil)
                   
                } else {
                    print("error")
                    print("logout toke: \(Router.token)")
                    print(json?["detail"].stringValue)
                    let alertController = UIAlertController(title: "Error", message: "error", preferredStyle: .alert)
                    
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                }
            }
            print("yes button tapped")
        })
        alertController.addAction(yesAction)
        
        let cancleAction = UIAlertAction(title: "Cancle", style: UIAlertActionStyle.destructive, handler: {(alert :UIAlertAction!) in
            print("cancle button tapped")
        })
        alertController.addAction(cancleAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
}
