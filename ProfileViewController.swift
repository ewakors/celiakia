//
//  ProfileViewController.swift
//  loginAndRegister
//
//  Created by Ewa Korszaczuk on 24.04.2017.
//  Copyright © 2017 Ewa Korszaczuk. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var logoutBtn: UIButton!
    @IBOutlet weak var changePasswordBtn: UIButton!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        usernameLabel.text = ""
        emailLabel.text = ""
        
        logoutBtn.layer.cornerRadius = 5
        logoutBtn.backgroundColor = UIColor.clear
        logoutBtn.layer.borderColor = UIColor(red: 108/255.0, green: 176/255.0, blue: 22/255.0, alpha: 1.0).cgColor
        logoutBtn.layer.borderWidth = 1.5
        
        changePasswordBtn.layer.cornerRadius = 5
        changePasswordBtn.backgroundColor = UIColor.clear
        changePasswordBtn.layer.borderColor = UIColor(red: 108/255.0, green: 176/255.0, blue: 22/255.0, alpha: 1.0).cgColor
        changePasswordBtn.layer.borderWidth = 1.5
        
        userDetails()
    }
    
    func userDetails()
    {
        let request = Router.userDetails()
        
        API.sharedInstance.sendRequest(request: request) { (json, error) in
            if let json = json {
                let user: User = User(json: json)
               
                    self.usernameLabel.text = user.getName()
                    self.emailLabel.text = user.getEmail()
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
                    
                    UserDefaults.standard.removeObject(forKey: AppDelegate.udTokenKey)                    
                    UserDefaults.standard.synchronize()
                    
                    Router.token = ""

                    let alertController = UIAlertController(title: "Success", message: "Logout success", preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: {(alert :UIAlertAction!) in
                        
                        let appDelegate = UIApplication.shared.delegate as! AppDelegate
                        appDelegate.window = UIWindow(frame: UIScreen.main.bounds)
                        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                        let yourVC = mainStoryboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                        appDelegate.window?.rootViewController = yourVC
                        appDelegate.window?.makeKeyAndVisible()
                        
                    })
                    
                    alertController.addAction(defaultAction)
                    self.present(alertController, animated: true, completion: nil)
                   
                } else {
                    print("error")
//                    print(json?["detail"].stringValue)
                    let alertController = UIAlertController(title: "Error", message: "error", preferredStyle: .alert)
                    
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        })
        
        alertController.addAction(yesAction)
        
        let cancleAction = UIAlertAction(title: "Cancle", style: UIAlertActionStyle.destructive, handler: {(alert :UIAlertAction!) in })
        alertController.addAction(cancleAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
}
