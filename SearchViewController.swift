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
        return resultProducts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = resultProducts[indexPath.row].getName()
        return cell
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        let text = searchController.searchBar.text
        let request = Router.findProduct(key: searchController.searchBar.text!.lowercased())
        
        API.sharedInstance.sendRequest(request: request) { (json, erorr) in
            if erorr == false {
                if let json = json {
                    self.resultProducts = Product.arrayFromJSON(json: json)
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
}

