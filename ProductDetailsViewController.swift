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
    
    var currentProduct: Product?
    
    let imageUrl: String = "https://celiakia.zer0def.me/static/images/"
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let product = currentProduct {
            productImageURL = product.getImage()
            productGlutenBool = product.getGluten()
        }
        
        if productImageURL != "" {
            let url = NSURL(string: productImageURL)
            let data = NSData(contentsOf: url as! URL)
            productImageView.image = UIImage(data: data as! Data)
            print(productImageURL)
        }
        else {
            let url = NSURL(string: imageUrl + "znakZap.jpg")
            productImageView.hnk_setImageFromURL(url! as URL)
        }
        
        if let gluten = productGlutenBool {
            
            if productGlutenBool == true {
                let url = NSURL(string: imageUrl + "glutenFree.png")
                productGlutenView.hnk_setImageFromURL(url! as URL)
            } else {
                let url = NSURL(string: imageUrl + "gluten.jpg")
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
            
            if let product = currentProduct {
                detailViewController.productNameString = product.getName().capitalized
                detailViewController.productBarcodeString = product.getBarcode()
                detailViewController.productGlutenBool = product.getGluten()
            }
        }
    }
}
