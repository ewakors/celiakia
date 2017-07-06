//
//  SearchProduct2ViewController.swift
//  loginAndRegister
//
//  Created by Ewa Korszaczuk on 16.06.2017.
//  Copyright © 2017 Ewa Korszaczuk. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Haneke

class SearchProduct2ViewController: UIViewController, UISearchBarDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var productDetailsVc: ProductDetailsViewController?
    var products = [Product]()
    var searchActive: Bool = false
    let imageUrl: String = "https://celiakia.zer0def.me/static/images/"
    var noDataLabel: UILabel = UILabel()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        searchBar.enablesReturnKeyAutomatically = true
        searchBar.showsCancelButton = false
        searchBar.sizeToFit()
        searchBar.tintColor = UIColor.white
        
        noDataLabel = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
        noDataLabel.textColor = UIColor.gray
        noDataLabel.textAlignment = .center
        
        tableView.delegate = self
        tableView.dataSource = self
        
        self.tableView.backgroundView = noDataLabel
        self.tableView.separatorStyle = .none
        self.tableView.tableFooterView = UIView()
        self.tableView.reloadData()
        
        products.sort(by: {$0.getName() < $1.getName()})
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Product.showProductDetails2Segue {
            if let cell = sender as? UITableViewCell{
                if let ip = tableView.indexPath(for: cell) {
                    productDetailsVc = segue.destination as? ProductDetailsViewController
                    productDetailsVc?.currentProduct = products[ip.row]
                    productDetailsVc?.title = productDetailsVc?.currentProduct?.getName().capitalized
                }
            }
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("searchText \(searchBar.text)")
        findProductWithAlert()
        searchActive = false
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
        searchActive = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = nil
        searchBar.showsCancelButton = false
        searchBar.endEditing(true)
        searchBar.resignFirstResponder()
        searchActive = false

        self.tableView.reloadData()
        products = []
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        findProduct()
    }
    
    func findProduct() {
        
        let productName : String
        productName = searchBar.text!.lowercased()
        
        if productName != "" {
            
            let request = Router.findProduct(key: productName)
            API.sharedInstance.sendRequest(request: request, completion: { (json, error) in
                
                if error == false {
                    if let json = json {
                        print(json)
                        self.products = Product.arrayFromJSON(json: json)
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                        if (json.isEmpty) {
                            self.noDataLabel.text = "Nothing found"
                        }
                    }
                } else {
                    let alertController = UIAlertController(title: "Error", message: "Invalid token", preferredStyle: .alert)
                    
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                }
            })
        } else {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            products = []
            self.noDataLabel.text = ""
        }
    }
    
    func findProductWithAlert() {
        
        let productName : String
        productName = searchBar.text!.lowercased()
        
        if productName != "" {
            let request = Router.findProduct(key: productName)
            API.sharedInstance.sendRequest(request: request, completion: { (json, error) in
                
                if error == false {
                    
                    if let json = json {
                        self.products = Product.arrayFromJSON(json: json)
                        print(json)
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    }
                    
                    if (json?.isEmpty)! {
                        let alertController = UIAlertController(title: "Sorry, nothing found", message: "Do you want to add this product?", preferredStyle: .alert)
                        
                        let yesAction = UIAlertAction(title: "YES", style: UIAlertActionStyle.default, handler: {(alert :UIAlertAction!) in
                            self.performSegue(withIdentifier: Product.addProductSegue, sender: nil)
                        })
                        alertController.addAction(yesAction)
                        
                        let cancleAction = UIAlertAction(title: "Cancle", style: UIAlertActionStyle.destructive, handler: {(alert :UIAlertAction!) in
                        })
                        alertController.addAction(cancleAction)
                        
                        self.present(alertController, animated: true, completion: nil)
                    }
                }
            })
        }
    }
}

extension SearchProduct2ViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        productDetailsVc?.currentProduct = products[indexPath.row]
    }
}

extension SearchProduct2ViewController: UITableViewDataSource {
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ProductCell

        cell.productNameLabel2.text = products[indexPath.row].getName().capitalized
        cell.productBarcodeLabel2.text = products[indexPath.row].getBarcode()
      
        if products[indexPath.row].getGluten() == true {
            let url = NSURL(string: imageUrl + "glutenFree.png")
            cell.productGlutenImageView2.hnk_setImageFromURL(url! as URL)
        } else {
            let url = NSURL(string: imageUrl + "gluten.jpg")
            cell.productGlutenImageView2.hnk_setImageFromURL(url! as URL)        }
        
        let productImageURL = products[indexPath.row].getImage()
        let url = NSURL(string: productImageURL)
        
        if productImageURL != "" {
            cell.productImageView2.hnk_setImageFromURL(url! as URL)
        } else {
            let url = NSURL(string: imageUrl + "znakZap.jpg")
            cell.productImageView2.hnk_setImageFromURL(url! as URL)
        }
        
        cell.selectionStyle = .gray
        
        return cell
    }
}
