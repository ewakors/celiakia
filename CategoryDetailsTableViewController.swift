//
//  CategoryDetailsTableViewController.swift
//  loginAndRegister
//
//  Created by Ewa Korszaczuk on 15.05.2017.
//  Copyright © 2017 Ewa Korszaczuk. All rights reserved.
//

import UIKit

class CategoryDetailsTableViewController: UITableViewController, UISearchResultsUpdating  {

    var products = [Product]()
    var searchController = UISearchController()
    
    var category:Category?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        self.searchController = ({
            
            let controller = UISearchController(searchResultsController: nil)
            controller.searchResultsUpdater = self
            controller.dimsBackgroundDuringPresentation = false
            controller.searchBar.sizeToFit()
            controller.searchBar.tintColor = UIColor.white
            
            self.tableView.tableHeaderView = controller.searchBar
            self.tableView.tableFooterView = UIView()

            return controller
        })()
        
        showProductsForCategory()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {

        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return products.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        (cell.contentView.viewWithTag(10) as! UILabel).text = products[indexPath.row].getName().capitalized
        (cell.contentView.viewWithTag(11) as! UILabel).text = products[indexPath.row].getBarcode()
        
        if products[indexPath.row].getGluten() == "True" {
            (cell.contentView.viewWithTag(100) as! UIImageView).image = UIImage(named: "glutenFree.png")
        }
        else {
            (cell.contentView.viewWithTag(100) as! UIImageView).image = UIImage(named: "http://127.0.0.1:8000/static/images/gluten.jpg")
        }
        
        let productImageURL = products[indexPath.row].getImage()
        let url = NSURL(string: productImageURL)
        let data = NSData(contentsOf: url as! URL)
        
        if productImageURL != "" {
            (cell.contentView.viewWithTag(101) as! UIImageView).image = UIImage(data: data as! Data)
        } else {
            (cell.contentView.viewWithTag(101) as! UIImageView).image = UIImage(named: "http://127.0.0.1:8000/static/images/znakZap.jpg")
        }
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "detailsProduct" {
            let detailViewController = ((segue.destination) as! ProductDetailsViewController)
            
            let indexPath = self.tableView.indexPathForSelectedRow!
            let productName = products[indexPath.row].getName()
            let productGluten = products[indexPath.row].getGluten()
            let productBarcode = products[indexPath.row].getBarcode()
            let productImageURL = products[indexPath.row].getImage()
            
            detailViewController.productNameString = productName
            detailViewController.productBarcodeString = productBarcode
            detailViewController.productGlutenString = productGluten
            detailViewController.productImageURL = productImageURL            
            detailViewController.title = productName.capitalized
        }        
    }
    
    func showProductsForCategory() {
        if let category = self.category {
            API.sharedInstance.sendRequest(request: Router.categoryProducts(categoryId: category.getId())) { (json, erorr) in
                
                if erorr == false {
                    if let json = json {
                        self.products = Product.arrayFromJSON(json: json)
                        
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    }
                }
                else {
                    let alertController = UIAlertController(title: "Error", message: "Not found categories", preferredStyle: .alert)
                    
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        
        let request = Router.findProduct(key: searchController.searchBar.text!.lowercased())
        
        API.sharedInstance.sendRequest(request: request) { (json, erorr) in
            if erorr == false {
                if let json = json {
                    self.products = Product.arrayFromJSON(json: json)
                    print(json.arrayValue)
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
}
