//
//  Food.swift
//  IntelliKitchen
//
//  Created by Ricky Zhang on 6/6/20.
//  Copyright © 2020 Emily Xu. All rights reserved.
//

import Foundation
import UIKit

class Food {
    var name: String
    var expiredate: Int
    
    init(name: String, expiredate: Int) {
        self.name = name
        self.expiredate = expiredate
    }
}
