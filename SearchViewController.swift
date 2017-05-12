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

    var resultProducts = [Product]()
    
    //let tableData = ["One", "Two", "One-Two"]
    var filterTableData = [String]()
    var resultSearchController = UISearchController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        self.resultSearchController = ( {
            
            let controller = UISearchController(searchResultsController: nil)
            controller.searchResultsUpdater = self
            controller.dimsBackgroundDuringPresentation = false
            controller.searchBar.sizeToFit()

            self.tableView.tableHeaderView = controller.searchBar
            return controller
        })()
        
        self.tableView.reloadData()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (self.resultSearchController.isActive) {
            return self.filterTableData.count
        } else {
            return resultProducts.count
        }
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        cell.textLabel?.text = self.resultSearchController.isActive ? filterTableData[indexPath.row] : resultProducts[indexPath.row].getName()
        
        return cell
    }

    func displayProductInfo(request: URLRequestConvertible)
    {
        API.sharedInstance.sendRequest(request: request, completion: { (json, error) in
            
            if error == false {
                
                if let resultJSON = json {

                    let product: Product = Product(json: json!)
                    print(resultJSON.arrayValue)
                    self.tableView.reloadData()
                }
                else {
                    print("ERROR.brak produktow")
                }
            }
        })
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        
        
        filterTableData.removeAll(keepingCapacity: false)
        
        let searchProduct = NSPredicate(format: "SELF CONTAINS[c] %@", searchController.searchBar.text!)
        let request = Router.findProduct(key: searchController.searchBar.text!.lowercased())
        
        print(request)

        let array = (resultProducts as NSArray).filtered(using: searchProduct)
        filterTableData = array as! [String]
        displayProductInfo(request: request)
        
    }

}


