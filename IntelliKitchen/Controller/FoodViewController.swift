//
//  FoodViewController.swift
//  homepage-Food Reminder
//
//  Created by Ricky Zhang on 4/29/20.
//  Copyright © 2020 Yilun Hao. All rights reserved.
//

import UIKit

class FoodViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var list = [Food]()
    var data: Db = Db()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        data.loadFoodInfo(fvc: self)
    }
}

