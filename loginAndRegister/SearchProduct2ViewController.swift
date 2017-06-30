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
    
    var products = [Product]()
    var searchActive: Bool = false
    let imageUrl: String = "https://celiakia.zer0def.me/static/images/"

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
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showProductDetails2Segue" {
            
            let detailViewController = ((segue.destination) as! ProductDetailsViewController)
            
            let indexPath = self.tableView.indexPathForSelectedRow?.row
            detailViewController.productImageURL = products[indexPath!].getImage()
            detailViewController.productNameString = products[indexPath!].getName()
            detailViewController.productBarcodeString = products[indexPath!].getBarcode()
            detailViewController.productGlutenString = products[indexPath!].getGluten()
            detailViewController.title = products[indexPath!].getName().capitalized
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

        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        products = []
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        findProduct()
        self.tableView.reloadData()
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
                    }
                } else {
                    let alertController = UIAlertController(title: "Error", message: "Invalid token", preferredStyle: .alert)
                    
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                }
            })
        } else {
            self.tableView.reloadData()
            products = []
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
        }
    }
}

extension SearchProduct2ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        products.sort(by: {$0.getName() < $1.getName()})
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        (cell.contentView.viewWithTag(10) as! UILabel).text = products[indexPath.row].getName().capitalized
        (cell.contentView.viewWithTag(11) as! UILabel).text = products[indexPath.row].getBarcode()
        
        if products[indexPath.row].getGluten() == "True" {
            let url = NSURL(string: imageUrl + "glutenFree.png")
            (cell.contentView.viewWithTag(100) as! UIImageView).hnk_setImageFromURL(url! as URL)
            //image = UIImage(named: "glutenFree.png")
        }
        else {
            let url = NSURL(string: imageUrl + "gluten.jpg")

            (cell.contentView.viewWithTag(100) as! UIImageView).hnk_setImageFromURL(url! as URL)
            //.image = UIImage(named: "gluten.png")
        }
        
        let productImageURL = products[indexPath.row].getImage()
        let url = NSURL(string: productImageURL)
        let data = NSData(contentsOf: url as! URL)
        
        if productImageURL != "" {
            (cell.contentView.viewWithTag(101) as! UIImageView).image = UIImage(data: data as! Data)
        } else {
            let url = NSURL(string: imageUrl + "znakZap.jpg")

            (cell.contentView.viewWithTag(101) as! UIImageView).hnk_setImageFromURL(url! as URL)
        }
        
        cell.selectionStyle = .none
        
        return cell
    }
}

extension SearchProduct2ViewController: UITableViewDataSource {
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
}
