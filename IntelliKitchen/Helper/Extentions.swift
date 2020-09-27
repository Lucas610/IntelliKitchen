//
//  Extentions.swift
//  homepage-Food Reminder
//
//  Created by Ricky Zhang on 5/19/20.
//  Copyright © 2020 Yilun Hao. All rights reserved.
//

import UIKit

extension RecipeViewController : UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        let bounds = collectionView.bounds
        let heightVal = self.view.frame.height
        let widthVal = self.view.frame.width
        let cellsize = (heightVal < widthVal) ? bounds.height/2 : bounds.width/2
        return CGSize(width: cellsize, height: cellsize)
    }
}

extension ByIngredientController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if (searchText == "") {
            searching = false
            ingredientTableView.reloadData()
            return
        }
        searchAllIngredient = allIngredient.filter({$0.localizedCaseInsensitiveContains(searchText)})
        searchSelectedIngredient = selectedIngredient.filter({$0.localizedCaseInsensitiveContains(searchText)})
        searching = true
        ingredientTableView.reloadData()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.ingredientSearchBar?.resignFirstResponder()
        self.ingredientTableView?.resignFirstResponder()
    }
}


extension ByNameController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching {
            return searchRecipe.count
        } else {
            return recipeNameArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if searching {
            cell?.textLabel?.text = searchRecipe[indexPath.row]
        } else {
            cell?.textLabel?.text = recipeNameArray[indexPath.row]
        }
        cell?.backgroundColor = lightGreen
        cell?.textLabel?.textColor = .white
        cell?.tintColor = .white
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let index = indexPath.row
        if searching {
            nameSearchBar.text = searchRecipe[index]
        } else {
            nameSearchBar.text = recipeNameArray[index]
        }
        searchRecipe = recipeNameArray.filter({$0.localizedCaseInsensitiveContains(nameSearchBar.text!)})
        searching = true
        nameTableView.reloadData()
    }
}


extension ByIngredientController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching {
            return searchAllIngredient.count + searchSelectedIngredient.count
        } else {
            return allIngredient.count + selectedIngredient.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        let index = indexPath.row
        if searching {
            if index < searchSelectedIngredient.count {
                cell?.textLabel?.text = searchSelectedIngredient[index]
                cell?.accessoryType = UITableViewCell.AccessoryType.checkmark
            } else {
                cell?.textLabel?.text = searchAllIngredient[index - searchSelectedIngredient.count]
                cell?.accessoryType = UITableViewCell.AccessoryType.none
            }
        } else {
            if index < selectedIngredient.count {
                cell?.textLabel?.text = selectedIngredient[index]
                cell?.accessoryType = UITableViewCell.AccessoryType.checkmark
            } else {
                cell?.textLabel?.text = allIngredient[index - selectedIngredient.count]
                cell?.accessoryType = UITableViewCell.AccessoryType.none
            }
            
        }
        cell?.backgroundColor = lightGreen
        cell?.textLabel?.textColor = .white
        cell?.tintColor = .white
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = indexPath.row
        let cell = tableView.cellForRow(at: indexPath)
        let label = (cell?.textLabel?.text)!
        if searching {
            if index < searchSelectedIngredient.count {
                searchSelectedIngredient = searchSelectedIngredient.filter{ $0 != label }
                searchAllIngredient.append(label)
                searchAllIngredient.sort()
                
                selectedIngredient = selectedIngredient.filter { $0 != label }
                allIngredient.append(label)
                allIngredient.sort()
            } else {
                if (selectedIngredient.count >= 20) {
                    let alert = UIAlertController(title: "Too many ingredients!", message: "Please remove ingredients before adding", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                } else {
                    searchSelectedIngredient.append(label)
                    searchSelectedIngredient.sort()
                    searchAllIngredient = searchAllIngredient.filter { $0 != label }
                    
                    selectedIngredient.append(label)
                    selectedIngredient.sort()
                    allIngredient = allIngredient.filter { $0 != label }
                }
            }
        } else {
            if index < selectedIngredient.count {
                selectedIngredient = selectedIngredient.filter { $0 != label }
                allIngredient.append(label)
                allIngredient.sort()
            } else {
                if (selectedIngredient.count >= 20) {
                    let alert = UIAlertController(title: "Too many ingredients!", message: "Please remove ingredients before adding", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                } else {
                    selectedIngredient.append(label)
                    selectedIngredient.sort()
                    allIngredient = allIngredient.filter { $0 != label }
                }
            }
        }
        ingredientTableView.reloadData()
    }
}


extension ByNameController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if searching {
            searchArray = searchRecipe
            searchArray.insert(nameSearchBar.text!, at: 0)
        } else {
            searchArray = []
            searchArray.append(nameSearchBar.text!)
            searchArray.append(nameSearchBar.text!)
        }
        performSegue(withIdentifier: "searchResult", sender: self)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if (searchText == "") {
            searching = false
            nameTableView.reloadData()
            return
        }
        searchRecipe = recipeNameArray.filter({$0.localizedCaseInsensitiveContains(searchText)})
        searching = true
        nameTableView.reloadData()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.nameSearchBar?.resignFirstResponder()
        self.nameTableView?.resignFirstResponder()
    }
}


extension RecipeListScreen: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let recipe = recipes[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeCell") as! RecipeCell
        cell.setRecipe(recipe: recipe)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if recipes.count == 0 {
            return CGFloat(0.0)
        } else {
            return CGFloat(110.0)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let id = newrecipeid[indexPath.row]
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let secondVC = storyboard.instantiateViewController(identifier: "menudetail") as! ScrollViewController
        secondVC.passid = id;
        self.present(secondVC,animated:true,completion: nil)
    }
}

extension MyFoodViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foods.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        /*let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "cell") as! CustomTableViewCell*/
        let cell = foodListTable.dequeueReusableCell(withIdentifier: "cell") as! CustomTableViewCell
        /*foods.append(foodName[indexPath.row] + "          " + boughtDate[indexPath.row] + "          " + expireDate[indexPath.row])*/
        let Food = self.foods[indexPath.row]
        cell.setFood(foods: Food)
        cell.foodLabel.adjustsFontSizeToFitWidth = true
        cell.bdLabel.adjustsFontSizeToFitWidth = true
        cell.edLabel.adjustsFontSizeToFitWidth = true
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            
            data.deleteFood(mfvc: self, index: indexPath.row)
            self.foods.remove(at: indexPath.row)
            self.foodListTable.reloadData()
            self.createAlert(title: "Delete success!", message: "Successfully delete the food!")
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let alertController = UIAlertController(title: "Edit food", message: nil, preferredStyle: .alert)
        alertController.addTextField(configurationHandler: editFoodName)
        alertController.addTextField(configurationHandler: editBoughtDate)
        alertController.addTextField(configurationHandler: editExpireDate)
        row = indexPath.row
        
        let okAction = UIAlertAction(title: "Save", style: .default, handler: self.okHandler)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true)
    }
    
    func editFoodName(textField: UITextField!) {
        editFoodName = textField
        editFoodName?.placeholder = "Name"
    }
    func editBoughtDate(textField: UITextField!) {
        editBoughtDate = textField
        editBoughtDate?.inputView = datePicker
        editBoughtDate?.placeholder = "Bought Date"
    }
    func editExpireDate(textField: UITextField!) {
        editExpireDate = textField
        editExpireDate?.inputView = datePicker2
        editExpireDate?.placeholder = "Expiration Date"
    }
    
    func okHandler(alert: UIAlertAction) {
        if(editExpireDate?.text == "" || editBoughtDate?.text == "" || editFoodName?.text == ""){
            print("error")
        } else {
            //deal with data change here
            data.editFood(mfvc: self, index: row)
            
            let food = self.foods[row]
            food.expireDate = editExpireDate?.text as! String
            food.boughtDate = editBoughtDate?.text as! String
            food.foodName = editFoodName?.text as! String
            self.foodListTable.reloadData()
            
        }
    }
    
}


extension AddFoodViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foods.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = foodListTableView.dequeueReusableCell(withIdentifier: "foodCell") as! AddFoodTableViewCell
        let Food = self.foods[indexPath.row]
        cell.setFood(foods: Food)
        cell.bDateLabel.adjustsFontSizeToFitWidth = true
        cell.eDateLabel.adjustsFontSizeToFitWidth = true
        cell.foodNameLabel.adjustsFontSizeToFitWidth = true
        return cell
    }
    
}

extension AddChoresViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chores.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = choresList.dequeueReusableCell(withIdentifier: "choresCell") as! AddChoresTableViewCell
        //let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "cell")
        let Chore = self.chores[indexPath.row]
        cell.setChore(chore: Chore)
//        cell.nameLabel.text = choreNames[indexPath.row]
//        cell.fLabel.text = frequencyChoice[indexPath.row]
//        cell.ldLabel.text = lastDoneDates[indexPath.row]
        cell.nameLabel.adjustsFontSizeToFitWidth = true
        cell.fLabel.adjustsFontSizeToFitWidth = true
        cell.ldLabel.adjustsFontSizeToFitWidth = true
        //cell.textLabel?.text = chores[indexPath.row]
        //cell.textLabel?.adjustsFontSizeToFitWidth = true
        return cell
    }
}

extension ScrollViewController {
    @objc func touch() {
        self.Comments.endEditing(true)
    }
}


extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}


extension ScrollViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commentcelllist.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let eachcomment = commentcelllist[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell") as! CommentCell
        
        cell.setComments(comment: eachcomment)
        return cell
    }
}


extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}

extension Array where Element: Hashable {
    func removingDuplicates() -> [Element] {
        var addedDict = [Element: Bool]()
        
        return filter {
            addedDict.updateValue(true, forKey: $0) == nil
        }
    }
    
    mutating func removeDuplicates() {
        self = self.removingDuplicates()
    }
}

extension ProfilePageViewController : UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
}

extension ProfilePageViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteRecipes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let favoriteRecipe = favoriteRecipes[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteRecipeCell") as! FavoriteRecipeCell
        
        cell.setFavoriteRecipe(favoriteRecipe: favoriteRecipe)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let id = self.favoriteIDList[indexPath.row]
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let secondVC = storyboard.instantiateViewController(identifier: "menudetail") as! ScrollViewController
        secondVC.passid = id;
        self.present(secondVC,animated:true,completion: nil)
    }
}

extension FoodViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let food = list[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "FoodCell")
        
        cell?.textLabel?.text = food.name
        cell?.textLabel?.font = UIFont(name: "Acumin Pro SemiCondensed", size: 15)
        cell?.textLabel?.textColor = UIColor.darkGray
        if(food.expiredate < 0){
            cell?.backgroundColor = UIColor(red: 150/255, green: 150/255, blue: 150/255, alpha: 1)
        }
        else if(food.expiredate <= 3){
            cell?.backgroundColor = UIColor(red: 250/255, green: 160/255, blue: 160/255, alpha: 1)
        }
        else if(food.expiredate <= 5){
            cell?.backgroundColor = UIColor(red: 255/255, green: 196/255, blue: 196/255, alpha: 1)
        }
        else{
            cell?.backgroundColor = UIColor.white
        }
        tableView.layer.cornerRadius = 20
        cell?.selectionStyle = .none
        return cell!
    }
}

extension ChoresViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let chores = list[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChoresCell") as! ChoresTableViewCell
        if(chores.expiredate < 0){
            cell.backgroundColor = UIColor(red: 250/255, green: 160/255, blue: 160/255, alpha: 1)
        }
        else{
            cell.backgroundColor = UIColor.white
        }
        tableView.layer.cornerRadius = 20
        cell.selectionStyle = .none
        cell.setlabel(chores: chores)
        return cell
    }
}

extension RecipeViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recipelist.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let recipe = recipelist[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
        cell.setCell(recipe: recipe)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let recipe = recipelist[indexPath.item]
        let id = recipe.id
        let storyboard = UIStoryboard(name:"Main",bundle: nil)
        let anotherVC = storyboard.instantiateViewController(identifier: "menudetail") as! ScrollViewController
        anotherVC.passid = id;
        self.present(anotherVC,animated:true,completion: nil)
    }
}
