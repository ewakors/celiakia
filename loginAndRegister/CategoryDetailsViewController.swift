//
//  CategoryDetailsViewController.swift
//  loginAndRegister
//
//  Created by Ewa Korszaczuk on 19.06.2017.
//  Copyright © 2017 Ewa Korszaczuk. All rights reserved.
//

import UIKit

class CategoryDetailsTableViewController: UIViewController, UISearchBarDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!

    var products = [Product]()
    var product: Product?
    var category:Category?
    var searchActive: Bool = false
    var productDetailsVc: ProductDetailsViewController?
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

        showProductsForCategory()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "detailsProduct" {
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
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        findProduct()
        searchActive = false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = nil
        searchBar.showsCancelButton = false
        searchBar.endEditing(true)
        searchBar.resignFirstResponder()
        searchActive = false
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        findProduct()
    }
    
    func findProduct() {
        
        let productName : String
        productName = searchBar.text!.lowercased()
        
        if productName != "" {
            let request = Router.findProductInCategory(key: productName, category: (category?.getId())!)
            API.sharedInstance.sendRequest(request: request, completion: { (json, error) in
                
                if error == false {
                    if let json = json {
                        print(json)
                        self.products = Product.arrayFromJSON(json: json)
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    }                    
                    if (json?.isEmpty)! {
                        self.noDataLabel.text = TableBackgroundClass.labelText
                    }
                }
            })
        } else {
            showProductsForCategory()
            noDataLabel.text = TableBackgroundClass.labelNoText
        }
    }
    
    func findProductWithAlert() {
        
        let productName : String
        productName = searchBar.text!.lowercased()
        
        if productName != "" {
            let request = Router.findProductInCategory(key: productName, category: (category?.getId())!)
            API.sharedInstance.sendRequest(request: request, completion: { (json, error) in
                
                if error == false {
                    if let json = json {
                        self.products = Product.arrayFromJSON(json: json)
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    }
                    if (json?.isEmpty)! {
                        let alertController = UIAlertController(title: "Sorry, nothing found", message: "Do you want to add this product?", preferredStyle: .alert)
                        
                        let yesAction = UIAlertAction(title: "YES", style: UIAlertActionStyle.default, handler: {(alert :UIAlertAction!) in
                            self.performSegue(withIdentifier: "addProductSegue", sender: nil)
                        })
                        alertController.addAction(yesAction)
                        
                        let cancleAction = UIAlertAction(title: "Cancle", style: UIAlertActionStyle.destructive, handler: {(alert :UIAlertAction!) in
                        })
                        alertController.addAction(cancleAction)
                        
                        self.present(alertController, animated: true, completion: nil)
                    }
                }
            })
        } else {
            showProductsForCategory()
        }
    }
    
    func showProductsForCategory() {

        if let category = self.category {
            API.sharedInstance.sendRequest(request: Router.categoryProducts(category: category.getId())) { (json, erorr) in
                if erorr == false {
                    if let json = json {
                        self.products = Product.arrayFromJSON(json: json)
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    }
                } else {
                    let alertController = UIAlertController(title: "Error", message: "Not found categories", preferredStyle: .alert)
                    
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
}

extension CategoryDetailsTableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        productDetailsVc?.currentProduct = products[indexPath.row]
    }
}

extension CategoryDetailsTableViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: ProductCell.identifier, for: indexPath) as! ProductCell
        
        cell.productNameLabel.text = products[indexPath.row].getName()
        cell.productBarcodeLabel.text = products[indexPath.row].getBarcode()
        
        let glutenImageURL = products[indexPath.row].getGlutenImage()
        let glutenUrl = NSURL(string: glutenImageURL)
        cell.productGlutenImageView.hnk_setImageFromURL(glutenUrl! as URL)
        
        let productImageURL = products[indexPath.row].getImage()
        let imageUrl = NSURL(string: productImageURL)
        cell.productimageView.hnk_setImageFromURL(imageUrl! as URL)
        
        cell.selectionStyle = .gray
        
        return cell
    }
}
