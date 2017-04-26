//
//  AddProductViewController.swift
//  loginAndRegister
//
//  Created by Ewa Korszaczuk on 21.04.2017.
//  Copyright © 2017 Ewa Korszaczuk. All rights reserved.
//

import UIKit

class AddProductViewController: UIViewController {

    @IBOutlet weak var categoryTxt: UITextField!
    @IBOutlet weak var glutenTxt: UITextField!
    @IBOutlet weak var productCodeTxt: UITextField!
    @IBOutlet weak var productNameTxt: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }


    @IBAction func addNewProductButton(_ sender: Any) {
        let request = Router.addNewProduct(name: "bulka", barcode: "123456", gluten: true, category: "meal")
        
                API.sharedInstance.sendRequest(request: request) { (json, error) in
        
                    if error == false {
                        print(json)
                        let alertController = UIAlertController(title: "Success", message: "Add product success", preferredStyle: .alert)
        
                        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                        alertController.addAction(defaultAction)
        
                        self.present(alertController, animated: true, completion: nil)
                        //self.performSegue(withIdentifier: "searchProduct", sender: nil)
        
                    } else {
                        print("error")
                        let alertController = UIAlertController(title: "Error", message: "error", preferredStyle: .alert)
        
                        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                        alertController.addAction(defaultAction)
                        
                        self.present(alertController, animated: true, completion: nil)
                    }
                }

    }


}
