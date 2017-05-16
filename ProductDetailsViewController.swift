//
//  ProductDetailsViewController.swift
//  loginAndRegister
//
//  Created by Ewa Korszaczuk on 12.05.2017.
//  Copyright © 2017 Ewa Korszaczuk. All rights reserved.
//

import UIKit

class ProductDetailsViewController: UIViewController {

    @IBOutlet weak var productGlutenLabel: UILabel!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productBarcodeLabel: UILabel!
    
    var productNameString: String!
    var productBarcodeString: String!
    var productGlutenString: String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let name = productNameString {
            productNameLabel.text = name
        }
        
        if let barcode = productBarcodeString {
            productBarcodeLabel.text = barcode
            print(barcode)
        }
        
        if let gluten = productGlutenString {
            if gluten == "True" {
                productGlutenLabel.text = "Gluten FREE"

            } else {
                productGlutenLabel.text = "Gluten"
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
