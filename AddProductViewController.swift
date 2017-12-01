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
import AudioToolbox

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
                            for code in codes {
                                let stringValue = code.stringValue!
                                self.productCodeTxt.text = stringValue
                                AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
                            }
                        }
                    })
                } catch {
                    NSLog("Unable to start scanning")
                }
            } else {
                let alertController = UIAlertController(title: "Skanowanie niedostępne", message: "Ta aplikacja nie ma uprawnień do używania kamery", preferredStyle: .alert)
                
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                
                self.present(alertController, animated: true, completion: nil)
            }
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.scanner?.stopScanning()
    }
    
    @IBAction func addNewProductButton(_ sender: Any) {

        let r = categoryPickerView.selectedRow(inComponent: 0)
        
        if r != -1 {
            let request = Router.addNewProduct(name: productNameTxt.text!, barcode: productCodeTxt.text!, gluten: glutenFree, category: resultCategories[r].getId())
            
            API.sharedInstance.sendRequest(request: request) { (json, error) in
                if let json = json {
                    if error == false {
                        let alertController = UIAlertController(title: "Dodawanie produktu", message: "Twój produkt został pomyślnie przesłany do bazy", preferredStyle: .alert)
                        
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
                let alertController = UIAlertController(title: "Błąd", message: "Nie odnaleziono kategorii", preferredStyle: .alert)
                
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
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return resultCategories[row].getName()
    }
}
