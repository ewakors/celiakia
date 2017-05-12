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
    
    @IBOutlet weak var name: UILabel!
    var scanner: MTBBarcodeScanner?
    
    var resultProducts = [Product]()
    let picker: UIPickerView = UIPickerView(frame:
        CGRect(x: 0, y: 50, width: 260, height: 100));
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scanner = MTBBarcodeScanner(previewView: scanncerView)
        searchBar.delegate = self
        
        picker.delegate = self;
        picker.dataSource = self;
        
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
                
                if let resultJSON = json {
                    self.resultProducts = Product.arrayFromJSON(json: resultJSON)
                    if self.resultProducts.count > 0 {
                        print("resultProducts.count > 1 \(self.resultProducts.count)")
                    }
                    let product: Product = Product(json: json!)
                    print(resultJSON.arrayValue)
                    print(resultJSON.count)
                    if resultJSON.arrayValue.isEmpty {
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
                    else {
                        let alert = UIAlertController(title: "Product", message: "\n\n\n\n\n\n", preferredStyle: .alert);
                        self.picker.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
                        alert.view.addSubview(self.picker);
                        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                        alert.addAction(defaultAction)
                        
                        self.present(alert, animated: true, completion: {
                            self.picker.frame.size.width = alert.view.frame.size.width
                        })
                    }
                }
                else {
                    print("ERROR.brak produktow")
                }
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
        //let keyboardFrame: CGRect = (info [UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let duration = notification.userInfo! [UIKeyboardAnimationDurationUserInfoKey] as! Double
        
        UIView.animate(withDuration: duration) {

            self.view.layoutIfNeeded()
        }
    }

    func keyboardWillHide(notification: NSNotification) {
        let duration = notification.userInfo! [UIKeyboardAnimationDurationUserInfoKey] as! Double
        
        UIView.animate(withDuration: duration) {
            self.view.layoutIfNeeded()
        }
    }

    func hideKeyboard() {
        self.view.endEditing(true)
    }
}

extension SearchProductViewController: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return resultProducts.count
    }
}

extension SearchProductViewController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print(resultProducts[row].getName())
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if resultProducts[row].getGluten() == "True" {
            return resultProducts[row].getName() + " " + resultProducts[row].getBarcode() + " Gluten gfree"
        }
        else {
            return resultProducts[row].getName() + " " + resultProducts[row].getBarcode() + " Gluten"
        }
    }
}
