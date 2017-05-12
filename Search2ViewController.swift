//
//  Search2ViewController.swift
//  loginAndRegister
//
//  Created by Ewa Korszaczuk on 12.05.2017.
//  Copyright © 2017 Ewa Korszaczuk. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class Search2ViewController: UIViewController {


    @IBOutlet weak var productTableView: UITableView!
    var resultProducts = [Product]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        productTableView.dataSource = self
        productTableView.delegate = self
        findProduct()
    }

    func displayProductInfo(request: URLRequestConvertible)
    {
        resultProducts = []
        API.sharedInstance.sendRequest(request: request, completion: { (json, error) in
            
            if error == false {
                
                if let resultJSON = json {
                    
                    let product1: Product = Product(json: json!)
                    print(resultJSON.arrayValue)
                    
                    self.productTableView.reloadData()
                }
                else {
                    print("ERROR.brak produktow")
                }
            }
        })
    }
    
    func findProduct() {

        let productName : String
//        productName = searchBar.text!.lowercased()
        let request = Router.findProduct(key: "1111")
        displayProductInfo(request: request)
    }
}

extension Search2ViewController: UITableViewDataSource {
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultProducts.count
    }
    
}

extension Search2ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = productTableView.dequeueReusableCell(withIdentifier: "cell")
        cell?.textLabel?.text = resultProducts[indexPath.row].getName()
        cell?.detailTextLabel?.text = resultProducts[indexPath.row].getGluten()
        print("result \(resultProducts[indexPath.row].getGluten())")
        
        return cell!
    }
}
