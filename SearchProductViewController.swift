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

class SearchProductViewController: UIViewController, UITextFieldDelegate, UISearchBarDelegate  {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var scanncerView: UIView!
    @IBOutlet weak var productTextView: UITextView!
    
    var scanner: MTBBarcodeScanner?
    var products = [Product]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scanner = MTBBarcodeScanner(previewView: scanncerView)
        
        searchBar.delegate = self
        searchBar.showsCancelButton = false
        searchBar.sizeToFit()
        searchBar.tintColor = UIColor.white
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
            addProductVC.barcodeString = searchBar.text! as String
        }
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("searchText \(searchBar.text)")
        findProduct()        
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
    
    func findProduct() {
        productTextView.text = searchBar.text
        
        let productName : String
        productName = searchBar.text!.lowercased()
   
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
                            print("brak produktow w bazie")
                        }
                        else {
                            self.performSegue(withIdentifier: "showProductDetails2Segue", sender: nil)
                        }
                    }
                }
            })
        } else {
            print("null")
        }
    }
}



