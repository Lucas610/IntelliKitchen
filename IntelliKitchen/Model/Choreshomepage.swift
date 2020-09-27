//
//  Choreshomepage.swift
//  IntelliKitchen
//
//  Created by sawsa on 6/6/20.
//  Copyright © 2020 Emily Xu. All rights reserved.
//

import Foundation
import UIKit

class Choreshomepage {
    var name: String
    var expiredate: Int
    var message: String
    var message2: String
    
    init(name: String, expiredate: Int, message: String, message2: String) {
        self.name = name
        self.expiredate = expiredate
        self.message = message
        self.message2 = message2
    }
}
