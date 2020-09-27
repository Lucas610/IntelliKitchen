//
//  RecipeViewController.swift
//  homepage-Food Reminder
//
//  Created by Ricky Zhang on 5/7/20.
//  Copyright © 2020 Yilun Hao. All rights reserved.
//

import UIKit

class RecipeViewController: UIViewController{
    
    // reference and global variable
    @IBOutlet weak var collectionView: UICollectionView!

    var allRecipe = [String]()
    var list = [Food]()
    var recipelist = [Recipehomepage]()
    var data:Db = Db()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        data.loadRecipe(rvc: self)
    }
    

}
