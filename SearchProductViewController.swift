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
    
    let picker: UIPickerView = UIPickerView(frame:
        CGRect(x: 0, y: 50, width: 260, height: 100));
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scanner = MTBBarcodeScanner(previewView: scanncerView)
        
        searchBar.delegate = self
        searchBar.showsCancelButton = true
        picker.delegate = self;
        picker.dataSource = self;
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showProductDetails2Segue" {
            let detailViewController = ((segue.destination) as! ProductDetailsViewController)
            /*detailViewController.productNameString = searchBar.text
            
            let indexPath = self.tableView.indexPathForSelectedRow!
            let productName = products[indexPath.row].getName()
            let productGluten = products[indexPath.row].getGluten()
            let productBarcode = products[indexPath.row].getBarcode()
            let productImageURL = products[indexPath.row].getImage()
            
            detailViewController.productNameString = productName
            detailViewController.productBarcodeString = productBarcode
            detailViewController.productGlutenString = productGluten
            detailViewController.productImageURL = productImageURL
            detailViewController.title = productName.uppercased()*/
        }
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        print("searchText ::: \(searchBar)")
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("searchText \(searchBar.text)")
        findProduct()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
//        print(self.searchBar.text)
        searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        // Stop doing the search stuff
        // and clear the text in the search bar
        searchBar.text = nil
        // Hide the cancel button
        searchBar.showsCancelButton = false
        searchBar.endEditing(true)
        // You could also change the position, frame etc of the searchBar
    }
    func displayProductInfo(request: URLRequestConvertible)
    {
        
        API.sharedInstance.sendRequest(request: request, completion: { (json, error) in

            if error == false {
                
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

                        //self.performSegue(withIdentifier: "showProductDetails2Segue", sender: nil)
                        

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
}

extension SearchProductViewController: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return products.count
    }
}

extension SearchProductViewController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print(products[row].getName())
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if products[row].getGluten() == "True" {
            return products[row].getName() + " " + products[row].getBarcode() + " Gluten gfree"
        }
        else {
            return products[row].getName() + " " + products[row].getBarcode() + " Gluten"
        }
    }
}

extension SearchProductViewController: UITableViewDataSource {
    
     func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = products[indexPath.row].getName()
        cell.detailTextLabel?.text = products[indexPath.row].getBarcode()
        return cell
    }
}
