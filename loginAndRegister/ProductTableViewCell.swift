//
//  ProductTableViewCell.swift
//  loginAndRegister
//
//  Created by Ewa Korszaczuk on 06.07.2017.
//  Copyright © 2017 Ewa Korszaczuk. All rights reserved.
//

import UIKit

class ProductTableViewCell: UITableViewCell {

    @IBOutlet var productBarcodeLabel: UILabel!
    @IBOutlet var productNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
