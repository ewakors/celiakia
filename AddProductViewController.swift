//
//  AddProductViewController.swift
//  loginAndRegister
//
//  Created by Ewa Korszaczuk on 21.04.2017.
//  Copyright © 2017 Ewa Korszaczuk. All rights reserved.
//

import UIKit
import Alamofire
import MTBBarcodeScanner

class AddProductViewController: UIViewController {

    @IBOutlet weak var categoryPickerView: UIPickerView!
    @IBOutlet weak var productCodeTxt: UITextField!
    @IBOutlet weak var productNameTxt: UITextField!
    @IBOutlet weak var scanncerView: UIView!
    @IBOutlet weak var checkButton: UIButton!
    
    var scanner: MTBBarcodeScanner?
    var checkbox = UIImage(named: "check")
    var unCheckbox = UIImage(named: "uncheck")
    var isBoxClicked: Bool!
    var glutenFree: Bool!
    var barcodeString: String!

    var resultCategories = [Category]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scanner = MTBBarcodeScanner(previewView: scanncerView)
        isBoxClicked = false
        glutenFree = false
        self.categoryPickerView.delegate = self
        self.categoryPickerView.dataSource = self
        productCodeTxt.text = barcodeString
    
        showCategory()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        MTBBarcodeScanner.requestCameraPermission(success: { success in
            if success {
                do {
                    try self.scanner?.startScanning(resultBlock: { codes in
                        if let codes = codes {
                            self.scanner?.stopScanning()
                            self.scanner = MTBBarcodeScanner(previewView: self.scanncerView)
                            for code in codes {
                                let stringValue = code.stringValue!
                                print("Found code: \(stringValue)")
                                self.productCodeTxt.text = stringValue
                            }
                        }
                    })
                } catch {
                    NSLog("Unable to start scanning")
                }
            } else {
                UIAlertView(title: "Scanning Unavailable", message: "This app does not have permission to access the camera", delegate: nil, cancelButtonTitle: nil, otherButtonTitles: "Ok").show()
            }
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.scanner?.stopScanning()
        
        super.viewWillDisappear(animated)
    }
    @IBAction func addNewProductButton(_ sender: Any) {

        let r = categoryPickerView.selectedRow(inComponent: 0)
        
        if r != -1 {
            let request = Router.addNewProduct(name: productNameTxt.text!, barcode: productCodeTxt.text!, gluten: glutenFree, category: resultCategories[r].getId())
            
            API.sharedInstance.sendRequest(request: request) { (json, error) in
                if let json = json {
                    if error == false {
                        //print(json)
                        let alertController = UIAlertController(title: "Success", message: "Add product success", preferredStyle: .alert)
                        
                        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                        alertController.addAction(defaultAction)
                        
                        self.present(alertController, animated: true, completion: nil)
                        
                    } else {
                        let warning = Warning(json: json).getError()
                        API.Warning(delegate: self, message: warning)
                    }
                }
            }
        }
    }
    
    @IBAction func clickedCheckbox(_ sender: UIButton) {
        if isBoxClicked == true {
            isBoxClicked = false
        } else {
            isBoxClicked = true
        }
        
        if isBoxClicked == true {
            sender.setImage(checkbox, for: UIControlState.normal)
            return glutenFree = true
        } else {
            sender.setImage(unCheckbox, for: UIControlState.normal)
            return glutenFree = false
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
                let alertController = UIAlertController(title: "Error", message: "Not found category", preferredStyle: .alert)
                
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                
                self.present(alertController, animated: true, completion: nil)
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
