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
    
    let imageUrl: String = "https://celiakia.zer0def.me/static/images/"
    var products = [Product]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ProductCell
        
        cell.productNameLabel2.text = products[indexPath.row].getName().capitalized
        cell.productBarcodeLabel2.text = products[indexPath.row].getBarcode()
        
        if products[indexPath.row].getGluten() == true {
            let url = NSURL(string: imageUrl + "glutenFree.png")
            cell.productGlutenImageView2.hnk_setImageFromURL(url! as URL)
        } else {
            let url = NSURL(string: imageUrl + "gluten.jpg")
            cell.productGlutenImageView2.hnk_setImageFromURL(url! as URL)        }
        
        let productImageURL = products[indexPath.row].getImage()
        let url = NSURL(string: productImageURL)
        
        if productImageURL != "" {
            cell.productImageView2.hnk_setImageFromURL(url! as URL)
        } else {
            let url = NSURL(string: imageUrl + "znakZap.jpg")
            cell.productImageView2.hnk_setImageFromURL(url! as URL)
        }
        
        cell.selectionStyle = .gray
        
        return cell
    }
}
