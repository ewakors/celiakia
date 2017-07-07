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
    
    static let identifier = "cell"

    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .gray
    }

    func setProduct(product: Product) {
        
        productNameLabel2.text = product.getName()
        productBarcodeLabel2.text = product.getBarcode()
        
        let glutenImageURL = product.getGlutenImage()
        let glutenUrl = NSURL(string: glutenImageURL)
        productGlutenImageView2.hnk_setImageFromURL(glutenUrl! as URL)
        
        let productImageURL = product.getImage()
        let imageUrl = NSURL(string: productImageURL)
        productImageView2.hnk_setImageFromURL(imageUrl! as URL)
    }
    
    func setProductInCategory(product: Product) {
        
        productNameLabel.text = product.getName()
        productBarcodeLabel.text = product.getBarcode()
        
        let glutenImageURL = product.getGlutenImage()
        let glutenUrl = NSURL(string: glutenImageURL)
        productGlutenImageView.hnk_setImageFromURL(glutenUrl! as URL)
        
        let productImageURL = product.getImage()
        let imageUrl = NSURL(string: productImageURL)
        productimageView.hnk_setImageFromURL(imageUrl! as URL)
    }
}

