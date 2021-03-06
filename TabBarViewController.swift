//
//  TabBarViewController.swift
//  loginAndRegister
//
//  Created by Ewa Korszaczuk on 02.06.2017.
//  Copyright © 2017 Ewa Korszaczuk. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tabBar.tintColor = UIColor.white
        self.tabBar.unselectedItemTintColor = UIColor.white
        self.tabBarItem = UITabBarItem(title: "Home", image: UIImage(named: "logo"), selectedImage: UIImage(named: "logo"))
    }
    
    func appDelegateFunc() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window = UIWindow(frame: UIScreen.main.bounds)
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let yourVC = mainStoryboard.instantiateViewController(withIdentifier: "TabBarViewController") as! TabBarViewController
        appDelegate.window?.rootViewController = yourVC
        appDelegate.window?.makeKeyAndVisible()
    }
}
