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
import AudioToolbox

class SearchProductViewController: UIViewController, UITextFieldDelegate, UISearchBarDelegate  {

    @IBOutlet weak var scanncerView: UIView!
    @IBOutlet weak var productTextView: UITextView!
    
    var scanner: MTBBarcodeScanner?
    var products = [Product]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scanner = MTBBarcodeScanner(previewView: scanncerView)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        barcodeScanner()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.scanner?.stopScanning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showProductDetails2Segue" {
            
            let detailViewController = ((segue.destination) as! ProductDetailsViewController)
            detailViewController.productImageURL = products.first?.getImage()
            detailViewController.productNameString = products.first?.getName()
            detailViewController.productBarcodeString = products.first?.getBarcode()
            detailViewController.productGlutenString = products.first?.getGluten()
            detailViewController.title = products.first?.getName().capitalized
        }
        
        if segue.identifier == "addProductSegue" {
            
            let addProductVC = ((segue.destination) as! AddProductViewController)
            addProductVC.barcodeString = productTextView.text
        }
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("searchText \(searchBar.text)")
        //findProduct()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = nil
        searchBar.showsCancelButton = false
        searchBar.endEditing(true)
        searchBar.resignFirstResponder()
    }
    
    func findProduct(productName: String) {
       // productTextView.text = searchBar.text
        
        //let productName : String
        //productName = searchBar.text!.lowercased()
   
        if productName != "" {
            
            let request = Router.findProduct(key: productName)
            API.sharedInstance.sendRequest(request: request, completion: { (json, error) in
                
                if error == true {
                    let alertController = UIAlertController(title: "Error", message: "Invalid token. You must login.", preferredStyle: .alert)
                    
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                } else {
                    if let resultJSON = json {
                        self.products = Product.arrayFromJSON(json: resultJSON)
                        print(resultJSON.arrayValue)

                        print(self.products.count)
                        if resultJSON.arrayValue.isEmpty {
                            let alertController = UIAlertController(title: "Sorry, nothing found", message: "Do you want to add this product?", preferredStyle: .alert)
                            
                            let yesAction = UIAlertAction(title: "YES", style: UIAlertActionStyle.default, handler: {(alert :UIAlertAction!) in
                                self.performSegue(withIdentifier: "addProductSegue", sender: nil)
                            })
                            alertController.addAction(yesAction)
                            
                            let cancleAction = UIAlertAction(title: "Cancle", style: UIAlertActionStyle.destructive, handler: {(alert :UIAlertAction!) in
                            })
                            alertController.addAction(cancleAction)
                            
                            self.present(alertController, animated: true, completion: nil)
                            
                         self.barcodeScanner()
                            
                            print("brak produktow w bazie")
                        }
                        else {
                            if self.products.count == 1 {
                                self.performSegue(withIdentifier: "showProductDetails2Segue", sender: nil)
                            }
                        }
                    }
                }
            })
        }
    }
    
    func barcodeScanner() {
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
                                self.findProduct(productName: stringValue)
                                self.productTextView.text = stringValue
                                //AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
                            }
                        }
                    })
                } catch {
                    NSLog("Unable to start scanning")
                }
            } else {
                let alertController = UIAlertController(title: "Scanning Unavailable", message: "This app does not have permission to access the camera", preferredStyle: .alert)
                
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                
                self.present(alertController, animated: true, completion: nil)
            }
        })
    }
}



