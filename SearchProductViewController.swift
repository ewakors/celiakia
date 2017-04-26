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
    @IBOutlet weak var stackView: UIStackView!
    
    var scanner: MTBBarcodeScanner?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scanner = MTBBarcodeScanner(previewView: scanncerView)
        searchBar.delegate = self
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(SearchProductViewController.dismissKeyboard)))

    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        print("searchText ::: \(searchBar)")
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("searchText \(searchBar.text)")
        findProduct()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        print(self.searchBar.text)
    }
    
    func displayProductInfo(request: URLRequestConvertible)
    {
            API.sharedInstance.sendRequest(request: request, completion: { (json, error) in
                
                if error == false {
                    let gluten = json![0]["gluten_free"].stringValue
                    let name = json![0]["name"].stringValue
                    let barcode = json![0]["bar_code"].stringValue
                    //print(json)
                    print(name)
                    print(barcode)
                    
                    if name != "" {
                        
                        if gluten == "True" {
                            let alertController = UIAlertController(title: "GLUTEN FREE", message: "\(name) \n\(barcode)", preferredStyle: .alert)
                            
                            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                            alertController.addAction(defaultAction)
                            
                            self.present(alertController, animated: true, completion: nil)
                            print("GLUTEN FREE!!!")
                        }
                        if gluten == "False"  {
                            let alertController = UIAlertController(title: "PRODUCT WITH GLUTEN", message: "\(name) \n\(barcode)", preferredStyle: .alert)
                            
                            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                            alertController.addAction(defaultAction)
                            
                            self.present(alertController, animated: true, completion: nil)
                            print("GLUTEN :(( !!!")
                        }
                    }
                    
                    if ( name == "" && barcode == "" && gluten == "" ) {
                        let alertController = UIAlertController(title: "Sorry, nothing found", message: "Do you want to add this product?", preferredStyle: .alert)
                        
                        let yesAction = UIAlertAction(title: "YES", style: UIAlertActionStyle.default, handler: {(alert :UIAlertAction!) in
                            self.performSegue(withIdentifier: "addProductSegue", sender: nil)
                            print("yes button tapped")
                        })
                        alertController.addAction(yesAction)
                        
                        let cancleAction = UIAlertAction(title: "Cancle", style: UIAlertActionStyle.destructive, handler: {(alert :UIAlertAction!) in
                            print("cancle button tapped")
                        })
                        alertController.addAction(cancleAction)
                        
                        self.present(alertController, animated: true, completion: nil)
                        print("brak produktow w bazie")
                    }
                }
                else {
                    print("ERROR.brak produktow")
                }
                
            })
 }
    
    func findProduct() {
        productTextView.text = searchBar.text
        
        let productName : String
        productName = searchBar.text!.lowercased()
   
        if productName != "" {
            
            let request = Router.findProduct(key: productName)
            displayProductInfo(request: request)
        }

    }
    override func viewDidAppear(_ animated: Bool) {
        enableKeyboardHideOnTop()
    }
    
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        searchBar.resignFirstResponder()
    }
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchBar.resignFirstResponder()
        return true
    }

    private func enableKeyboardHideOnTop() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(SearchProductViewController.keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(SearchProductViewController.keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SearchProductViewController.hideKeyboard))
        
        self.view.addGestureRecognizer(tap)
    }
    
    
    func keyboardWillShow (notification: NSNotification) {
        let info = notification.userInfo!
        let keyboardFrame: CGRect = (info [UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let duration = notification.userInfo! [UIKeyboardAnimationDurationUserInfoKey] as! Double
        
        UIView.animate(withDuration: duration) {

            self.view.layoutIfNeeded()
            
        }
        
    }

    func keyboardWillHide(notification: NSNotification) {
        let duration = notification.userInfo! [UIKeyboardAnimationDurationUserInfoKey] as! Double
        
        UIView.animate(withDuration: duration) {
            // self.toolBarContainer.constant = self.toolBarContainerValue
            self.view.layoutIfNeeded()
        }
    }

    func hideKeyboard() {
        self.view.endEditing(true)
    }
    
}
