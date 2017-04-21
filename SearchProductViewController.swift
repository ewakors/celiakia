//
//  SearchProductViewController.swift
//  loginAndRegister
//
//  Created by Ewa Korszaczuk on 19.04.2017.
//  Copyright © 2017 Ewa Korszaczuk. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import MTBBarcodeScanner

class SearchProductViewController: UIViewController, UITextFieldDelegate  {

    @IBOutlet weak var productCodeTxt: UITextField!
    @IBOutlet weak var productNameTxt: UITextField!
    @IBOutlet weak var scanncerView: UIView!
    @IBOutlet weak var productTextView: UITextView!
    @IBOutlet weak var stackView: UIStackView!
    
    var scanner: MTBBarcodeScanner?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scanner = MTBBarcodeScanner(previewView: scanncerView)
        productNameTxt.delegate = self
        productCodeTxt.delegate = self
    }
    func displayProductInfo(request: URLRequestConvertible)
    {
        API.sharedInstance.sendRequest(request: request, completion: { (json, error) in
 
            print(json?[0]["name"].stringValue)
            print(json?[0]["gluten_free"].stringValue)
            
            let gluten = json?[0]["gluten_free"].stringValue
            let name = json?[0]["name"].stringValue
            let barcode = json?[0]["gluten_free"].stringValue
            
            if gluten == "True" {
                print("GLUTEN FREE!!!")
            }
            if gluten == "False"  {
                print("GLUTEN :(( !!!")
            }
            if name == "" && barcode == "" {
                print("brak produktow w bazie")
            }
        })
    }
    
    func findProduct() {
        productTextView.text = productCodeTxt.text
        let barcode : String
        barcode =  productTextView.text
        
        let productName : String
        productName = productNameTxt.text!
        
        if (barcode.isEmpty) && (productName.isEmpty)  {
            print("productCode and productName are empty")
        }
        
        if productName != "" {
            
            let request = Router.findProductByName(name: productName)
            displayProductInfo(request: request)
        }
        else if barcode != "" {
            
            let request = Router.findProductByBarcode(barcode: barcode)
            displayProductInfo(request: request)
        }
       
        if (productName != "" && barcode != "") {
            let request = Router.findProductByBarcodeAndName(barcode: barcode, name: productName)
            displayProductInfo(request: request)
        }
//        else {
//            print("wpisz nazwe produktu albo barcode")
//        }
    }
    
    @IBAction func searchButton(_ sender: Any) {
        findProduct()
    }
    
}
