//
//  ProductDetailsTableViewController.swift
//  loginAndRegister
//
//  Created by Ewa Korszaczuk on 19.05.2017.
//  Copyright © 2017 Ewa Korszaczuk. All rights reserved.
//

import UIKit

class ProductDetailsTableViewController: UITableViewController {

    @IBOutlet weak var productGlutenLabel: UILabel!
    @IBOutlet weak var productBarcodeLabel: UILabel!
    @IBOutlet weak var productNameLAbel: UILabel!
    @IBOutlet var productTableView: UITableView!
    
    var productNameString: String!
    var productBarcodeString: String!
    var productGlutenBool: Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        productTableView.dataSource = self
        productTableView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewWillAppear(_ animated: Bool) {
        
        if let name = productNameString {
            productNameLAbel.text = name
        }
        
        if let barcode = productBarcodeString {
            productBarcodeLabel.text = barcode
        }
        
        if let gluten = productGlutenBool {
            if gluten == true {
                productGlutenLabel.text = "Gluten FREE"
                
            } else {
                productGlutenLabel.text = "Gluten"
                productGlutenLabel.textColor = UIColor.red
            }
        }
    }
}
