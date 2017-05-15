//
//  CategoriesCollectionViewController.swift
//  loginAndRegister
//
//  Created by Ewa Korszaczuk on 12.05.2017.
//  Copyright © 2017 Ewa Korszaczuk. All rights reserved.
//

import UIKit

class CategoriesCollectionViewController: UICollectionViewController {

    @IBOutlet weak var categoriesCollectionView: UICollectionView!
    var resultCategories = [Category]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        categoriesCollectionView.dataSource = self
        categoriesCollectionView.delegate = self
//        collectionView?.delegate = self
//        collectionView?.dataSource = self
//        displayCategories()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return resultCategories.count
    }

    /*override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CategoriesCollectionViewController
        
        let categoryName = resultCategories[indexPath.row].getName()
        cell.categoryNameLabel.text = categoryName
        
        return cell
    }*/
    
    func displayCategories()
    {
        let request = Router.getCategory()
        
        API.sharedInstance.sendRequest(request: request) { (json, erorr) in
            if erorr == false {
                if let json = json {
                    self.resultCategories = Category.arrayFromJSON(json: json)
                    print(json.arrayValue)
                    
                    DispatchQueue.main.async {
                        self.collectionView?.reloadData()
                    }
                }
            }
            else {
                print("error category info")
            }
            
        }
    }

}
