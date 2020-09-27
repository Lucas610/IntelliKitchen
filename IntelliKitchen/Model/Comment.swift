//
//  Comment.swift
//  intellik
//
//  Created by 江南 on 5/14/20.
//  Copyright © 2020 江南. All rights reserved.
//

import Foundation
import UIKit

class Comment{
    var image: UIImage
    var description: String
    var name: String
    
    init(image: UIImage, name: String, description: String){
        self.image = image
        self.description = description
        self.name = name
    }
}
