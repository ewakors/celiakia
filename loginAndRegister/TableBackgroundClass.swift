//
//  TableBackgroundClass.swift
//  loginAndRegister
//
//  Created by Ewa Korszaczuk on 07.07.2017.
//  Copyright © 2017 Ewa Korszaczuk. All rights reserved.
//

import UIKit

class TableBackgroundClass {

    static let labelText = "Nothing found"
    static let labelNoText = ""
    static let labelTextColor = UIColor.gray
    static let labelTextAlignment = NSTextAlignment.center
    static let tableSeparatorStyle = UITableViewCellSeparatorStyle.none
    static let tableFooterView = UIView()
    
    func appDelegateFunc() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window = UIWindow(frame: UIScreen.main.bounds)
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let yourVC = mainStoryboard.instantiateViewController(withIdentifier: "TabBarViewController") as! TabBarViewController
        appDelegate.window?.rootViewController = yourVC
        appDelegate.window?.makeKeyAndVisible()
    }
}
