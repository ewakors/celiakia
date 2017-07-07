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

    var products = [Product]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ProductCell
        
        cell.productNameLabel2.text = products[indexPath.row].getName()
        cell.productBarcodeLabel2.text = products[indexPath.row].getBarcode()
        
        let glutenImageURL = products[indexPath.row].getGlutenImage()
        let glutenUrl = NSURL(string: glutenImageURL)
        cell.productGlutenImageView2.hnk_setImageFromURL(glutenUrl! as URL)
        
        let productImageURL = products[indexPath.row].getImage()
        let imageUrl = NSURL(string: productImageURL)
        cell.productImageView2.hnk_setImageFromURL(imageUrl! as URL)
        
        cell.selectionStyle = .gray
        
        return cell
    }
}

