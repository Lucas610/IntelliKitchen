//
//  CustomTableViewCell.swift
//  IntelliKitchen_Myfood
//
//  Created by D.WANG on 5/23/20.
//  Copyright © 2020 D.WANG. All rights reserved.
//

import UIKit


class CommentCell: UITableViewCell {
    
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var comments: UILabel!
    
    func setComments(comment: Comment) {
        photo.image = comment.image;
        name.text = comment.name;
        comments.text = comment.description;
        photo.layer.cornerRadius = 10;
    }
}


class FavoriteRecipeCell: UITableViewCell {
    
    @IBOutlet weak var favoriteRecipeImage: UIImageView!
    @IBOutlet weak var favoriteRecipeLabel: UILabel!
    
    func setFavoriteRecipe(favoriteRecipe: FavoriteRecipe) {
        favoriteRecipeImage.image = favoriteRecipe.image
        favoriteRecipeLabel.text = favoriteRecipe.title
    }
}

class MyChoresTableViewCell: UITableViewCell {
    @IBOutlet weak var taskNameLabel: UILabel!
    @IBOutlet weak var lastDoneLabel: UILabel!
    @IBOutlet weak var frequencyLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setChore(chore: Chore) {
        taskNameLabel.text = chore.task
        lastDoneLabel.text = chore.lastDone
        frequencyLabel.text = chore.timePeriod
    }
}


class AddFoodTableViewCell: UITableViewCell {
    
    @IBOutlet weak var foodNameLabel: UILabel!
    @IBOutlet weak var bDateLabel: UILabel!
    @IBOutlet weak var eDateLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setFood(foods: Foods) {
        foodNameLabel.text = foods.foodName
        bDateLabel.text = foods.boughtDate
        eDateLabel.text = foods.expireDate
    }
}

class RecipeCell: UITableViewCell {
    
    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var recipeTitle: UILabel!
    @IBOutlet weak var recipeRating: UILabel!
    
    func setRecipe(recipe:Recipe) {
        recipeImage.image = recipe.image
        recipeTitle.text = recipe.title
        recipeRating.text = "Average Rating: \(recipe.rating)"
    }
}

class CustomTableViewCell: UITableViewCell {
    
    @IBOutlet weak var foodLabel: UILabel!
    @IBOutlet weak var edLabel: UILabel!
    @IBOutlet weak var bdLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setFood(foods: Foods) {
        foodLabel.text = foods.foodName
        edLabel.text = foods.expireDate
        bdLabel.text = foods.boughtDate
    }
}


class AddChoresTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ldLabel: UILabel!
    @IBOutlet weak var fLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setChore(chore: Chore) {
        nameLabel.text = chore.task
        ldLabel.text = chore.lastDone
        fLabel.text = chore.timePeriod
    }
    
    
}


class ChoresTableViewCell: UITableViewCell {

    @IBOutlet weak var labelView: UILabel!
    @IBOutlet weak var orilabelView: UILabel!
    
    func setlabel(chores:Choreshomepage) {
        orilabelView.text = chores.message
        orilabelView.font = UIFont(name: "Acumin Pro SemiCondensed", size: 15)
        orilabelView.textColor = UIColor.darkGray
        labelView.text = chores.message2
        labelView.font = UIFont(name: "Acumin Pro SemiCondensed", size: 15)
        labelView.textColor = UIColor.darkGray
    }
}
