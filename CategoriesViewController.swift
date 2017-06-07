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
        
        /*let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: screenWidth / 3, height: screenWidth / 3)
       // categoriesCollectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0*/
        //categoriesCollectionView!.collectionViewLayout = layout

        
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
        
        let categoryImageURL = categories[indexPath.row].getImage()
        let url = NSURL(string: categoryImageURL)
        let data = NSData(contentsOf: url as! URL)
        cell.categoryImageView.image = UIImage(data: data as! Data)

        return cell
    }
    
    /*func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        if indexPath.row == 0
        {
            return CGSize(width: screenWidth, height: screenWidth/3)
        }
        return CGSize(width: screenWidth/3, height: screenWidth/3);
        
    }*/
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        
        return 1
    }
}

extension CategoriesViewController: UICollectionViewDelegate {
    
}
