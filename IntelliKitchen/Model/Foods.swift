//
//  Foods.swift
//  IntelliKitchen
//
//  Created by D.WANG on 6/6/20.
//  Copyright © 2020 Emily Xu. All rights reserved.
//

import Foundation
import UIKit

class Foods {
    var foodName: String
    var boughtDate: String
    var expireDate: String
    
    init(foodName: String, boughtDate: String, expireDate: String) {
        self.foodName = foodName
        self.boughtDate = boughtDate
        self.expireDate = expireDate
    }
}
