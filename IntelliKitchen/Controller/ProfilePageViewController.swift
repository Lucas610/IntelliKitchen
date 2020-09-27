//
//  ProfilePageViewController.swift
//  IntellK_Profile_Page
//
//  Created by zhangjm on 5/19/20.
//  Copyright © 2020 zhangjm. All rights reserved.
//

import UIKit

class ProfilePageViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate  {
    
    @IBOutlet weak var myImageView: UIImageView!
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var userEmail: UILabel!
    @IBOutlet weak var userPassword: UITextField!
    @IBOutlet weak var saveUsername: UIButton!
    @IBOutlet weak var favRecipeAlert: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var favoriteRecipes:[FavoriteRecipe] = []
    var favoriteIDList:[String] = []
    let data:Db = Db()

    static var systemNotification = false
    var databaseNotification = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        data.loadUserInfo(ppvc:self)
        myImageView?.layer.borderWidth = 1
        myImageView?.layer.masksToBounds = false
        myImageView?.layer.borderColor = UIColor.black.cgColor
        myImageView?.layer.cornerRadius = myImageView.frame.height/2
        myImageView?.clipsToBounds = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func createArray(_ favoriteIDList: [String]) -> [FavoriteRecipe]{
        var temp: [FavoriteRecipe] = []
        data.retrieveFR(ppvc:self, favoriteIDList, completion: {searchedRecipes in
            self.favoriteRecipes = searchedRecipes
            self.tableView?.reloadData()
        })
        
        return temp
    }
    
    @IBAction func showOrHidePassword(_ sender: Any) {
        let tempGoogleUsername = GlobalVariable.googleUsername
        let tempGoogleEmail = GlobalVariable.googleEmail
        
        if tempGoogleUsername != "" && tempGoogleEmail != ""{
            self.createAlert(title: "Notice", message: "You may not change your password by signing in with Google")
        }
        else{
            data.changePasswordHelper(ppvc:self)
        }
    }
    
    func createAlertSignOut(title:String, message:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {(action) in alert.dismiss(animated: true, completion: nil)
            self.signoutTapped((Any).self)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func createAlert(title:String, message:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {(action) in alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func importImage(_ sender: Any) {
        let tempGoogleUsername = GlobalVariable.googleUsername
        let tempGoogleEmail = GlobalVariable.googleEmail
        
        if tempGoogleUsername != "" && tempGoogleEmail != ""{
            self.createAlert(title: "Notice", message: "You may not change your profile photo by signing in with Google")
        }
        else{
            //Given the user the opportunity to pick a picture.
            let image = UIImagePickerController()
            image.delegate = self
            image.sourceType = UIImagePickerController.SourceType.photoLibrary
            image.allowsEditing = false
            
            self.present(image, animated: true){
                //After it is complete.
            }
        }
    }
    

    
    func loadImageFromFirebase(){
        data.loadImageFromFirebaseHelper(ppvc:self)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            myImageView.image = image
            data.uploadProfileImage(ppvc:self, image){(url) in
                
            }
        }
        else{
            //error message
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveUsernameAction(_ sender: Any) {
        let tempGoogleUsername = GlobalVariable.googleUsername
        let tempGoogleEmail = GlobalVariable.googleEmail
        
        if tempGoogleUsername != "" && tempGoogleEmail != ""{
            self.createAlert(title: "Notice", message: "You may not change your username by signing in with Google")
        }
        else{
            data.saveUsernameActionHelper(ppvc:self)
        }
        self.createAlert(title: "Notice", message: "Sucessfully save the username")
    }
    
    @IBAction func signoutTapped(_ sender: Any) {
        data.signoutTappedHelper(ppvc: self)
        
        let loginController = self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.loginController) as? LoginController
        view.window?.rootViewController = loginController
        view.window?.makeKeyAndVisible()
        
        GlobalVariable.googleUsername = ""
        GlobalVariable.googleEmail = ""
        
        GlobalVariable.googleIconUrl = URL(string: "")
    }
}


