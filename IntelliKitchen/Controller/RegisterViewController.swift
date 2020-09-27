//
//  RegisterViewController.swift
//  UserLoginAndRegister
//
//  Created by Emily Xu on 4/29/20.
//  Copyright © 2020 Emily Xu. All rights reserved.
//

import UIKit


class RegisterViewController: UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    let data: Db = Db()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setUpElements()
    }
    
    func setUpElements(){
        errorLabel.alpha = 0
        Utilities.styleTextField(textfield: usernameTextField)
        Utilities.styleTextField(textfield: emailTextField)
        Utilities.styleTextField(textfield: passwordTextField)
        Utilities.styleTextField(textfield: confirmPasswordTextField)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        usernameTextField.resignFirstResponder()
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        confirmPasswordTextField.resignFirstResponder()
    }
    
    // check the fields and validate the data is correct. If everything is correct, return nill. Otherwise, return error massage
    func validateFields() -> String? {
        
        // check that all fields are filled
        if usernameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            confirmPasswordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
            return "Please fill in all fields."
        }
        
        // check if the password is secure
        let cleanedPassword = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if cleanedPassword.count > 20 {
            return "Your password is too long."
        }
        
        if Utilities.isPasswordValid(password: cleanedPassword) == false{
            return "Please make sure your password is at least 6 digits."
        }
        
        if confirmPasswordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines) != cleanedPassword {
            return "Passwords don't match."
        }
        return nil
    }
    
    func showError(_ message:String){
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    
    @IBAction func registerTapped(_ sender: Any) {
        //Validate the fields
        let error = validateFields()
        
        if error != nil{
            //There's something is wrong
            showError(error!)
        }
        else{
            //Create cleaned versions of the data
            let username = usernameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            // Create the user
            data.createUser(username: username,email: email, password: password, rc: self)

            }
        let defaultImageString = "profileTapped"
        guard let myUIImage = UIImage(named: defaultImageString) else { return }
        data.uploadProfileImage(myUIImage){(url) in
        }
    }

    
    func transitionHome() {
        let welcomeController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.welcomeController) as? WelcomeController
        view.window?.rootViewController = welcomeController
        view.window?.makeKeyAndVisible()
    }
}
