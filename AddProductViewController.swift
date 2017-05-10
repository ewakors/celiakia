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

    var resultCategories = [Category]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.categoryPickerView.delegate = self
        self.categoryPickerView.dataSource = self
    
        showCategory()
    }

    @IBAction func addNewProductButton(_ sender: Any) {

        let r = categoryPickerView.selectedRow(inComponent: 0)

        if r != -1 {
            print(resultCategories[r].getId())
            print(resultCategories[r].getName())
            let request = Router.addNewProduct(name: "makaron", barcode: "1234", gluten: true, category: resultCategories[r].getId())
                        
            API.sharedInstance.sendRequest(request: request) { (json, error) in
                
                if error == false {
                    print(json)
                    let alertController = UIAlertController(title: "Success", message: "Add product success", preferredStyle: .alert)
                    
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                    
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
    
    func showCategory()
    {
        let request = Router.getCategory()
        
        API.sharedInstance.sendRequest(request: request) { (json, error) in
            
            if error == false {
                
                if let resultJSON = json {
                    self.resultCategories = Category.arrayFromJSON(json: resultJSON)
                    self.categoryPickerView.reloadAllComponents()
                }
                
            } else {
                print("error show category")
                
            }
        }
    }

}

extension AddProductViewController: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return resultCategories.count
    }
}

extension AddProductViewController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print(resultCategories[row].getId())
        print(resultCategories[row].getName())
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return resultCategories[row].getName()
    }
}
