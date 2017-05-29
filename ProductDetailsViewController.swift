//
//  ProductDetailsViewController.swift
//  loginAndRegister
//
//  Created by Ewa Korszaczuk on 12.05.2017.
//  Copyright © 2017 Ewa Korszaczuk. All rights reserved.
//

import UIKit

class ProductDetailsViewController: UIViewController {

    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productGlutenView: UIImageView!
    
    var productNameString: String!
    var productBarcodeString: String!
    var productGlutenString: String!
    var productImageURL: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if productImageURL != "" {
            let url = NSURL(string: productImageURL)
            let data = NSData(contentsOf: url as! URL)
            productImageView.image = UIImage(data: data as! Data)
        }
        
        if let gluten = productGlutenString {
            if gluten == "True" {
                productGlutenView.image = UIImage(named: "glutenFree.png")
                
            } else {
                productGlutenView.image = UIImage(named: "gluten.png")
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "productDetailSague" {
            let detailViewController = ((segue.destination) as! ProductDetailsTableViewController)
            
            if let name = productNameString {
                detailViewController.productNameString = name
                print(name)
            }
            
            if let barcode = productBarcodeString {
                detailViewController.productBarcodeString = barcode
            }
            
            if let gluten = productGlutenString {
               
                detailViewController.productGlutenString = gluten
            }       
        }
    }
}
