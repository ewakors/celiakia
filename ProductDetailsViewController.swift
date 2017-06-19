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
            print(productImageURL)
        }
        else {
            let url = NSURL(string: "http://127.0.0.1:8000/static/images/znakZap.jpg")
            productImageView.hnk_setImageFromURL(url! as URL)
        }
        
        if let gluten = productGlutenString {
            if gluten == "True" {
                let url = NSURL(string: "http://127.0.0.1:8000/static/images/glutenFree.png")
                productGlutenView.hnk_setImageFromURL(url! as URL)
            } else {
                let url = NSURL(string: "http://127.0.0.1:8000/static/images/gluten.jpg")
                productGlutenView.hnk_setImageFromURL(url! as URL)
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
                detailViewController.productNameString = name.capitalized
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
