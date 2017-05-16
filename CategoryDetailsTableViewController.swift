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
            
            self.tableView.tableHeaderView = controller.searchBar
            return controller
        })()
        
        showProductsForCategory()
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
                    print("error category info")
                }
            }

        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {

        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return products.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        (cell.contentView.viewWithTag(10) as! UILabel).text = products[indexPath.row].getName()
        (cell.contentView.viewWithTag(11) as! UILabel).text = products[indexPath.row].getBarcode()
        
        if products[indexPath.row].getGluten() == "True" {
            (cell.contentView.viewWithTag(100) as! UIImageView).image = UIImage(named: "przekreslony-klos-logo.png")
        }
        else {
            (cell.contentView.viewWithTag(100) as! UIImageView).image = UIImage(named: "gluten.png")
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
            detailViewController.productNameString = productName
            detailViewController.productBarcodeString = productBarcode
            detailViewController.productGlutenString = productGluten
            detailViewController.productNameString = productName
            detailViewController.title = productName
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
