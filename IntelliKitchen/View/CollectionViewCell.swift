//
//  CollectionViewCell.swift
//  homepage-Food Reminder
//
//  Created by Ricky Zhang on 5/16/20.
//  Copyright © 2020 Yilun Hao. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var labelView: UILabel!
    
    func setCell(recipe: Recipehomepage) {
        imageView.image = recipe.image
        imageView.translatesAutoresizingMaskIntoConstraints = true
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 25
        labelView.text = recipe.name
        labelView.font = UIFont(name: "Acumin Pro SemiCondensed", size: 15)
        labelView.textColor = UIColor.darkGray
    }
}
