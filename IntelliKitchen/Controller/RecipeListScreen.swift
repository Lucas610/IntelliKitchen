//
//  RecipeListScreen.swift
//  IntelliKitchen
//
//  Created by sawsa on 4/30/20.
//  Copyright © 2020 jigsaw. All rights reserved.
//

import UIKit

class RecipeListScreen: UIViewController {
    
    // reference and global varaible
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchText: UILabel!
    
    var newrecipeid:[String] = []
    
    let lightGreen = UIColor(red: 146.0/255.0, green: 170.0/255.0, blue: 68.0/255.0, alpha: 1.0)
    var recipes:[Recipe] = []
    
    var searchByName = true
    var searchArray: [String] = []
    var label = UILabel()
    var data: Db = Db()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if searchByName {
            searchText.text = searchArray[0]
        } else {
            var text = ""
            for i in 0...(searchArray.count - 1) {
                if i == 0 {
                    text = searchArray[i]
                } else {
                    text += ", \(searchArray[i])"
                }
            }
            searchText.text = text
        }
        searchText.textColor = lightGreen
        
        // UI design
        label = UILabel(frame: CGRect(x: 0, y: 0, width: 400, height: 50))
        label.center.x = self.view.center.x
        label.center.y = self.view.center.y - 20
        label.textAlignment = .center
        label.text = "No matching result. \nPlease conduct your search again."
        label.font = label.font.withSize(20)
        label.numberOfLines = 0
        self.view.addSubview(label)
        label.isHidden = true
        
        if searchByName {
            createArray(searchByName: true, searchArray: Array(searchArray[1...]))
        } else {
            createArray(searchByName: false, searchArray: searchArray)
        }
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool){
        if searchByName {
            createArray(searchByName: true, searchArray: Array(searchArray[1...]))
        } else {
            createArray(searchByName: false, searchArray: searchArray)
        }
    }
    
    @IBAction func backbutton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func createArray(searchByName: Bool, searchArray: [String]) {
        data.retrieveRecipes(rls: self, searchByName: searchByName, searchArray: searchArray, completion: { searchedRecipes in
            if searchedRecipes.count == 0 {
                self.tableView.isHidden = true
                self.label.isHidden = false
            } else {
                self.recipes = searchedRecipes
                self.tableView.reloadData()
                self.tableView.isHidden = false
                self.label.isHidden = true
            }
        })
    }
    
}

