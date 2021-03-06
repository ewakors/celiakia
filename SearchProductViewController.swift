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
    var productDetailsVc: ProductDetailsViewController?
    var isProductInDatabase: Bool = false
    
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
        if segue.identifier == Product.showProductDetails2Segue {
            productDetailsVc = segue.destination as? ProductDetailsViewController
            
            for i in 0 ... self.products.count - 1 {
                if self.products[i].getBarcode() == self.productTextView.text {
                    productDetailsVc?.title = products[i].getName()
                    productDetailsVc?.productNameString = products[i].getName()
                    productDetailsVc?.productBarcodeString = products[i].getBarcode()
                    productDetailsVc?.productGlutenBool = products[i].getGluten()
                    productDetailsVc?.productImageURL = products[i].getImage()
                    productDetailsVc?.productGlutenImageString = products[i].getGlutenImage()
                }
            }
            isProductInDatabase = false
        }
        
        if segue.identifier == Product.addProductSegue {
            let addProductVC = ((segue.destination) as! AddProductViewController)
            addProductVC.barcodeString = productTextView.text
        }
    }
    
    func findProduct(productName: String) {
   
        if productName != "" {
            let request = Router.findProduct(key: productTextView.text)
            API.sharedInstance.sendRequest(request: request, completion: { (json, error) in
                
                if error == false {
                    if let resultJSON = json {
                        
                        print("\(self.productTextView.text)")
                        if resultJSON.arrayValue.count >= 0 {
                            for i in 0 ... resultJSON.arrayValue.count - 1 {
                                self.products = Product.arrayFromJSON(json: resultJSON)
                                if self.products[i].getBarcode() == self.productTextView.text {
                                    self.performSegue(withIdentifier: Product.showProductDetails2Segue, sender: nil)
                                    self.isProductInDatabase = true
                                }
                            }
                            if !self.isProductInDatabase {
                                let alertController = UIAlertController(title: "Niestety, nie odnaleziono produktu", message: "Czy chcesz dodać nowy produkt do bazy?", preferredStyle: .alert)
                                
                                let yesAction = UIAlertAction(title: "Tak", style: UIAlertActionStyle.default, handler: {(alert :UIAlertAction!) in
                                    self.performSegue(withIdentifier: Product.addProductSegue, sender: nil)
                                })
                                alertController.addAction(yesAction)
                                
                                let cancleAction = UIAlertAction(title: "Anuluj", style: UIAlertActionStyle.destructive, handler: {(alert :UIAlertAction!) in
                                })
                                alertController.addAction(cancleAction)
                                
                                self.present(alertController, animated: true, completion: nil)
                                
                                self.barcodeScanner()
                            }
                        }
                    }
                } else {
                    let alertController = UIAlertController(title: "Błąd", message: "Nieprawidłowy token. Musisz się zalogować.", preferredStyle: .alert)
                    
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                }
            })
        }
    }
    
    func barcodeScanner() {
        isProductInDatabase = false
        MTBBarcodeScanner.requestCameraPermission(success: { success in
            if success {
                do {
                    try self.scanner?.startScanning(resultBlock: { codes in
                        if let codes = codes {
                            self.scanner?.stopScanning()
                            self.scanner = MTBBarcodeScanner(previewView: self.scanncerView)
                            for code in codes {
                                let stringValue = code.stringValue!
                                self.findProduct(productName: stringValue)
                                self.productTextView.text = stringValue
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
}



