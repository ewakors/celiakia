//
//  CategoriesViewController.swift
//  loginAndRegister
//
//  Created by Ewa Korszaczuk on 12.05.2017.
//  Copyright © 2017 Ewa Korszaczuk. All rights reserved.
//

import UIKit

class CategoriesViewController: UIViewController {

    @IBOutlet weak var categoriesCollectionView: UICollectionView!
    
    var categories = [Category]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        categoriesCollectionView.dataSource = self
        categoriesCollectionView.delegate = self
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        
        displayCategories()
    }
    
    func displayCategories()
    {
        let request = Router.getCategory()
        
        API.sharedInstance.sendRequest(request: request) { (json, erorr) in
            if erorr == false {
                if let json = json {
                    self.categories = Category.arrayFromJSON(json: json)
                    print(json.arrayValue)
                    
                    DispatchQueue.main.async {
                        self.categoriesCollectionView?.reloadData()
                    }
                }
            }
            else {
                print("error category info")
            }
        }
    }
}

extension CategoriesViewController: UICollectionViewDataSource {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "categoryDetailsSegue" {
            
            if let cell = sender as? UICollectionViewCell {
                if let ip = categoriesCollectionView.indexPath(for: cell) {
                    if let vc = segue.destination as? CategoryDetailsTableViewController {
                        vc.category = categories[ip.row]
                    }
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = categoriesCollectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as! CategoryCell
        
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.borderWidth = 0.5
        cell.layer.cornerRadius = 3
        cell.categoryNameLabel.text = categories[indexPath.row].getName()
        
        return cell
    }
}

extension CategoriesViewController: UICollectionViewDelegate {
    
}
