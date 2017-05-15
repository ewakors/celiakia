//
//  ProductDetailsViewController.swift
//  loginAndRegister
//
//  Created by Ewa Korszaczuk on 12.05.2017.
//  Copyright © 2017 Ewa Korszaczuk. All rights reserved.
//

import UIKit

class ProductDetailsViewController: UIViewController {

    @IBOutlet weak var productNameLabel: UILabel!
    
    var productNameString: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let text = productNameString {
            productNameLabel.text = text
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
