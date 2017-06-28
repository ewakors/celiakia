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
    var screenSize: CGRect!
    var screenWidth: CGFloat!
    var screenHeight: CGFloat!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        screenSize = UIScreen.main.bounds
        screenWidth = screenSize.width
        screenHeight = screenSize.height
        
        categoriesCollectionView.dataSource = self
        categoriesCollectionView.delegate = self
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 5, right: 20)
        layout.itemSize = CGSize(width: screenWidth / 4, height: screenWidth / 4)
        layout.minimumLineSpacing = 20
        layout.minimumInteritemSpacing = 5
        categoriesCollectionView!.collectionViewLayout = layout

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
            } else {
                let alertController = UIAlertController(title: "Error", message: "Error category info", preferredStyle: .alert)
                
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                
                self.present(alertController, animated: true, completion: nil)
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
                        vc.title = vc.category?.getName().capitalized
                    }
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        categories.sort(by: {$0.getName() < $1.getName()})
        let cell = categoriesCollectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as! CategoryCell
        
        //cell.layer.borderColor = UIColor.black.cgColor
        //cell.layer.borderWidth = 0.5
        cell.layer.cornerRadius = 3
        cell.categoryNameLabel.text = categories[indexPath.row].getName()
        
        let categoryImageURL = categories[indexPath.row].getImage()
        let url = NSURL(string: categoryImageURL)
        let data = NSData(contentsOf: url as! URL)
        cell.categoryImageView.image = UIImage(data: data as! Data)

        return cell
    }
}

extension CategoriesViewController: UICollectionViewDelegate {
    
}
