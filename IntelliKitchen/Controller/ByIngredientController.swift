//
//  ByIngredientController.swift
//  IntelliKitchen
//
//  Created by sawsa on 5/7/20.
//  Copyright © 2020 jigsaw. All rights reserved.
//

import UIKit

class ByIngredientController: UIViewController {
    
    // all the reference and global variables
    @IBOutlet weak var ingredientSearchBar: UISearchBar!
    @IBOutlet weak var ingredientTableView: UITableView!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var searchByName: UIButton!
    @IBOutlet weak var searchByIngredient: UIButton!
    
    let lightGreen = UIColor(red: 146.0/255.0, green: 170.0/255.0, blue: 68.0/255.0, alpha: 1.0)
    let darkGreen = UIColor(red: 87.0/255.0, green: 132.0/255.0, blue: 56.0/255.0, alpha: 0.8)
    
    let data:Db = Db()
    var allIngredient: [String] = []
    var selectedIngredient: [String] = []
    var searchAllIngredient = [String]()
    var searchSelectedIngredient = [String]()
    var searching = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        data.getIngredients(bic:self)
        searchByName.titleLabel?.textAlignment = .center
        searchByIngredient.titleLabel?.textAlignment = .center
        
        searchButton.layer.cornerRadius = 5
        searchButton.backgroundColor = darkGreen
        searchButton.tintColor = .white
        clearButton.layer.cornerRadius = 5
        clearButton.backgroundColor = darkGreen
        clearButton.tintColor = .white
        ingredientTableView.layer.cornerRadius = 20
        ingredientTableView.backgroundColor = lightGreen
    }
    
    
    @IBAction func search(_ sender: Any) {
        if selectedIngredient.count == 0 {
            let alert = UIAlertController(title: "No ingredients!", message: "Please add ingredients before searching", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            performSegue(withIdentifier: "searchResult", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "searchResult" {
            let vc = segue.destination as! RecipeListScreen
            vc.searchArray = self.selectedIngredient
            vc.searchByName = false
        }
    }
    
    @IBAction func clearAll(_ sender: Any) {
        for item in selectedIngredient {
            allIngredient.append(item)
        }
        selectedIngredient = []
        allIngredient.sort()
        searching = false
        ingredientSearchBar.text = ""
        ingredientTableView.reloadData()
    }
}






