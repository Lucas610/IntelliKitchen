//
//  ChoresViewController.swift
//  homepage-Food Reminder
//
//  Created by Ricky Zhang on 5/7/20.
//  Copyright © 2020 Yilun Hao. All rights reserved.
//

import UIKit

class ChoresViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var list = [Choreshomepage]()
    var data: Db = Db()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        
        data.loadChoresInfo(cvc: self)
    }
}
