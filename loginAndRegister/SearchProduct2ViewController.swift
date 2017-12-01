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
    
    let productCell = ProductCell()
    var productDetailsVc: ProductDetailsViewController?
    var products = [Product]()
    var searchActive: Bool = false
    var noDataLabel: UILabel = UILabel()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        searchBar.enablesReturnKeyAutomatically = SearchBarClass.searchBarEnableReturnKey
        searchBar.showsCancelButton = SearchBarClass.searchBarShowCancleButton
        searchBar.sizeToFit()
        searchBar.tintColor = SearchBarClass.searchBarTintColor
        
        noDataLabel = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
        noDataLabel.textColor = TableBackgroundClass.labelTextColor
        noDataLabel.textAlignment = TableBackgroundClass.labelTextAlignment
        
        tableView.delegate = self
        tableView.dataSource = self        
        tableView.backgroundView = noDataLabel
        tableView.separatorStyle = TableBackgroundClass.tableSeparatorStyle
        tableView.tableFooterView = TableBackgroundClass.tableFooterView
        tableView.reloadData()
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
                    productDetailsVc?.title = productDetailsVc?.currentProduct?.getName()
                }
            }
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
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

        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
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
                            self.noDataLabel.text = TableBackgroundClass.labelText
                        }
                    }
                } else {
                    let alertController = UIAlertController(title: "Błąd", message: "Nieprawidłowy token", preferredStyle: .alert)
                    
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
            self.noDataLabel.text = TableBackgroundClass.labelNoText
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
                        let alertController = UIAlertController(title: "Niestety, nie odnaleziono produktu", message: "Czy chcesz dodać nowy produkt do bazy?", preferredStyle: .alert)
                        
                        let yesAction = UIAlertAction(title: "Tak", style: UIAlertActionStyle.default, handler: {(alert :UIAlertAction!) in
                            self.performSegue(withIdentifier: Product.addProductSegue, sender: nil)
                        })
                        alertController.addAction(yesAction)
                        
                        let cancleAction = UIAlertAction(title: "Anuluj", style: UIAlertActionStyle.destructive, handler: {(alert :UIAlertAction!) in
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

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: ProductCell.identifier, for: indexPath) as! ProductCell        
        cell.setProduct(product: products[indexPath.row])

        return cell
    }
}
