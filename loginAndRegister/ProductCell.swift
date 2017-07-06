//
//  ProductCell.swift
//  loginAndRegister
//
//  Created by Ewa Korszaczuk on 04.07.2017.
//  Copyright © 2017 Ewa Korszaczuk. All rights reserved.
//

import UIKit

class ProductCell: UITableViewCell {

    @IBOutlet var productimageView: UIImageView!
    @IBOutlet var productGlutenImageView: UIImageView!
    @IBOutlet var productBarcodeLabel: UILabel!
    @IBOutlet var productNameLabel: UILabel!
    
    @IBOutlet var productGlutenImageView2: UIImageView!
    @IBOutlet var productImageView2: UIImageView!
    @IBOutlet var productBarcodeLabel2: UILabel!
    @IBOutlet var productNameLabel2: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
