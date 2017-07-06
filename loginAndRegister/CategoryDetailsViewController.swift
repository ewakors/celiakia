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
    
    let imageUrl: String = "https://celiakia.zer0def.me/static/images/"
    var products = [Product]()
    var product: Product?
    var category:Category?
    var searchActive: Bool = false
    var productDetailsVc: ProductDetailsViewController?
    //var currentProduct: Product?

    override func viewDidLoad() {
        super.viewDidLoad()

        searchBar.delegate = self
        searchBar.enablesReturnKeyAutomatically = true
        searchBar.showsCancelButton = false
        searchBar.sizeToFit()
        searchBar.tintColor = UIColor.white

        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
        self.tableView.reloadData()

        showProductsForCategory()
        products.sort(by: {$0.getName() < $1.getName()})
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "detailsProduct" {
            productDetailsVc = segue.destination as? ProductDetailsViewController
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
                        self.products = Product.arrayFromJSON(json: json)
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    }
                }
            })
        } else {
            showProductsForCategory()
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ProductCell
        
        cell.productNameLabel.text = products[indexPath.row].getName().capitalized
        cell.productBarcodeLabel.text = products[indexPath.row].getBarcode()
        
        if products[indexPath.row].getGluten() == true {
            let url = NSURL(string: imageUrl + "glutenFree.png")
            cell.productGlutenImageView.hnk_setImageFromURL(url! as URL)
        } else {
            let url = NSURL(string: imageUrl + "gluten.jpg")
            cell.productGlutenImageView.hnk_setImageFromURL(url! as URL)
        }
        
        let productImageURL = products[indexPath.row].getImage()
        let url = NSURL(string: productImageURL)
        let data = NSData(contentsOf: url as! URL)
        
        if productImageURL != "" {
            cell.productimageView.hnk_setImageFromURL(url! as URL)
            (cell.contentView.viewWithTag(101) as! UIImageView).image = UIImage(data: data as! Data)
        } else {
            let url = NSURL(string: imageUrl + "znakZap.jpg")
            cell.productimageView.hnk_setImageFromURL(url! as URL)
        }
        
        cell.selectionStyle = .none
        
        return cell
    }
}
