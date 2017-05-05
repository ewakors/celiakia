//
//  AddProductViewController.swift
//  loginAndRegister
//
//  Created by Ewa Korszaczuk on 21.04.2017.
//  Copyright © 2017 Ewa Korszaczuk. All rights reserved.
//

import UIKit
import Alamofire

class AddProductViewController: UIViewController {

    @IBOutlet weak var categoryPickerView: UIPickerView!
    @IBOutlet weak var categoryTxt: UITextField!
    @IBOutlet weak var glutenTxt: UITextField!
    @IBOutlet weak var productCodeTxt: UITextField!
    @IBOutlet weak var productNameTxt: UITextField!

    var resultValues = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.categoryPickerView.delegate = self
        self.categoryPickerView.dataSource = self
        showCategory()
    }

    @IBAction func addNewProductButton(_ sender: Any) {
        let request = Router.addNewProduct(name: "bulka", barcode: "1234567", gluten: true, category: "1")
        
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

extension AddProductViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func showCategory()
    {
        let request = Router.getCategory()
        
        API.sharedInstance.sendRequest(request: request) { (json, error) in
            
            if error == false {
                var count : Int = json!.count
                for i in 0..<count {
                    if let category = json?[i]["name"].string {
                        print(category)
                        
                        self.resultValues.append(category)

                    }
                }
               
                self.categoryPickerView.reloadAllComponents()

            } else {
                print("error show category")
                
            }
        }
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return resultValues.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return resultValues[row]
    }

}
