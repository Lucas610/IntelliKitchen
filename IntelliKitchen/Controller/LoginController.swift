//
//  LoginCon.swift
//  UserLoginAndRegister
//
//  Created by Emily Xu on 5/7/20.
//  Copyright © 2020 Emily Xu. All rights reserved.
//

import UIKit
import GoogleSignIn



class LoginController: UIViewController, GIDSignInDelegate{
    
    // all the global varaible and reference
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var googleButton: GIDSignInButton!
    
    let data: Db = Db()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance().delegate = self
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
    
    @IBAction func loginTapped(_ sender: Any) {
        //validate Text Fields
        let error = validateFields()
        //There's something is wrong
        if error != nil{
            showError(error!)
        }
        else{
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            //Signing the user
            data.siginUser(email: email,password: password, lc: self)
        }
    }
    
    // check the fields and validate the data is correct. If everything is correct, return nill. Otherwise, return error massage
    func validateFields() -> String? {
        // check that all fields are filled
        if emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""
        {
            return "Please fill in all fields."
        }
        return nil
    }
    
    func showError(_ message:String){
        errorLabel.text = message
        errorLabel.textColor = UIColor.init(red: 255/255, green: 0/255, blue: 0/255, alpha: 1)
    }
    
    //Google Signin
    @IBAction func googleTapped(_ sender: Any) {
        GIDSignIn.sharedInstance().signIn()
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            self.errorLabel.text = error.localizedDescription
            self.errorLabel.textColor = UIColor.init(red: 255/255, green: 0/255, blue: 0/255, alpha: 1)
            return
        }
        data.googleSignin(user: user, lc: self)
        
    }

}
