//
//  SearchViewController.swift
//  loginAndRegister
//
//  Created by Ewa Korszaczuk on 10.05.2017.
//  Copyright © 2017 Ewa Korszaczuk. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class SearchViewController: UITableViewController, UISearchResultsUpdating {
    
    var products = [Product]()
    var searchController: UISearchController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        self.searchController = UISearchController(searchResultsController: nil)
        searchController?.searchResultsUpdater = self
        searchController?.dimsBackgroundDuringPresentation = false
        searchController?.searchBar.sizeToFit()
        searchController.searchBar.enablesReturnKeyAutomatically = true
        searchController.searchBar.tintColor = UIColor.white
        
        self.tableView.tableHeaderView = searchController?.searchBar
        self.tableView.tableFooterView = UIView()
        self.tableView.reloadData()
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
            (cell.contentView.viewWithTag(100) as! UIImageView).image = UIImage(named: "gluten.png")
        }
        
        let productImageURL = products[indexPath.row].getImage()
        let url = NSURL(string: products[indexPath.row].getImage())
        let data = NSData(contentsOf: url as! URL)
        
        if productImageURL != "" {
            (cell.contentView.viewWithTag(101) as! UIImageView).image = UIImage(data: data as! Data)
        }
        
        cell.selectionStyle = .none
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailsProductSegue" {
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
    
    func updateSearchResults(for searchController: UISearchController) {
        let text = searchController.searchBar.text        
        let request = Router.findProduct(key: searchController.searchBar.text!.lowercased())
        
        API.sharedInstance.sendRequest(request: request) { (json, erorr) in
            if erorr == false {
                if let json = json {
                    self.products = Product.arrayFromJSON(json: json)
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                } else {
                                            print("brak produktow w bazie")
                }
            }
//            else {
//                let alertController = UIAlertController(title: "Error", message: "You must login. Invalid token", preferredStyle: .alert)
//                
//                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
//                alertController.addAction(defaultAction)
//                
//                self.present(alertController, animated: true, completion: nil)
//            }
        }
    }
}

