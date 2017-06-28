//
//  ProductTableViewController.swift
//  loginAndRegister
//
//  Created by Ewa Korszaczuk on 28.06.2017.
//  Copyright © 2017 Ewa Korszaczuk. All rights reserved.
//

import UIKit

class ProductTableViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var products = [Product]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ProductTableViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        products.sort(by: {$0.getName() < $1.getName()})
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        (cell.contentView.viewWithTag(10) as! UILabel).text = products[indexPath.row].getName().capitalized
        (cell.contentView.viewWithTag(11) as! UILabel).text = products[indexPath.row].getBarcode()
        
        if products[indexPath.row].getGluten() == "True" {
            let url = NSURL(string: "http://127.0.0.1:8000/static/images/glutenFree.png")
            (cell.contentView.viewWithTag(100) as! UIImageView).hnk_setImageFromURL(url! as URL)
            //image = UIImage(named: "glutenFree.png")
        }
        else {
            let url = NSURL(string: "http://127.0.0.1:8000/static/images/gluten.jpg")
            (cell.contentView.viewWithTag(100) as! UIImageView).hnk_setImageFromURL(url! as URL)
            //.image = UIImage(named: "gluten.png")
        }
        
        let productImageURL = products[indexPath.row].getImage()
        let url = NSURL(string: productImageURL)
        let data = NSData(contentsOf: url as! URL)
        
        if productImageURL != "" {
            (cell.contentView.viewWithTag(101) as! UIImageView).image = UIImage(data: data as! Data)
        } else {
            let url = NSURL(string: "http://127.0.0.1:8000/static/images/znakZap.jpg")
            (cell.contentView.viewWithTag(101) as! UIImageView).hnk_setImageFromURL(url! as URL)
        }
        
        cell.selectionStyle = .none
        
        return cell
    }
}

extension ProductTableViewController: UITableViewDataSource {
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
}
