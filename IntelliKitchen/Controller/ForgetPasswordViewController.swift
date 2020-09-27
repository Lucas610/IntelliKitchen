//
//  ForgetPasswordViewController.swift
//  UserLoginAndRegister
//
//  Created by Emily Xu on 4/30/20.
//  Copyright © 2020 Emily Xu. All rights reserved.
//

import UIKit


class ForgetPasswordViewController: UIViewController {
    
    // reference and global variable
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var message: UITextField!
    
    let data: Db = Db()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Utilities.styleTextField(textfield: emailTextField)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        emailTextField.resignFirstResponder()
    }
    
    @IBAction func resetTapped(_ sender: Any) {
        if emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            message.alpha = 1
            message.textColor = UIColor.init(red: 255/255, green: 0/255, blue: 0/255, alpha: 1)
            message.text = "Please fill in your email"
        }
        else{
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            data.sendUserEmail(email: email, fg:self)
        }
    }
}
