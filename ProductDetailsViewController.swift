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
    var productGlutenBool: Bool!
    var productImageURL: String!
    var productGlutenImageString: String!
    var currentProduct: Product?
    var searchController: SearchProductViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if let product = currentProduct {
            let glutenImageURL = product.getGlutenImage()
            let glutenUrl = NSURL(string: glutenImageURL)
            productGlutenView.hnk_setImageFromURL(glutenUrl! as URL)
            
            let productImageURL = product.getImage()
            let imageUrl = NSURL(string: productImageURL)
            productImageView.hnk_setImageFromURL(imageUrl! as URL)
        } else {
            let productImageURL = self.productImageURL
            let imageUrl = NSURL(string: productImageURL ?? "")
            productImageView.hnk_setImageFromURL(imageUrl! as URL)
            
            let glutenImageURL = self.productGlutenImageString
            let glutenUrl = NSURL(string: glutenImageURL ?? "")
            productGlutenView.hnk_setImageFromURL(glutenUrl! as URL)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "productDetailSague" {
            let detailViewController = ((segue.destination) as! ProductDetailsTableViewController)
            
            if let product = currentProduct {
                detailViewController.productNameString = product.getName()
                detailViewController.productBarcodeString = product.getBarcode()
                detailViewController.productGlutenBool = product.getGluten()
            } else {
                detailViewController.productNameString = productNameString
                detailViewController.productBarcodeString = productBarcodeString
                detailViewController.productGlutenBool = productGlutenBool
            }
        } 
    }
}
