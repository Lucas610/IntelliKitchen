//
//  Db.swift
//  IntelliKitchen
//
//  Created by sawsa on 6/6/20.
//  Copyright © 2020 Emily Xu. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseAuth
import UserNotifications
import FirebaseDatabase
import FirebaseFirestore
import FirebaseStorage
import GoogleSignIn


class Db {
    var db = Firestore.firestore()
    
    
    // Function from LoginController
    func siginUser(email: String, password: String, lc: LoginController){
        //Signing the user
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if error != nil{
                let errorMessage = error!.localizedDescription
                lc.errorLabel.text = errorMessage.split(separator: ".")[0] + "."
                lc.errorLabel.textColor = UIColor.init(red: 255/255, green: 0/255, blue: 0/255, alpha: 1)
            }
            else{
                let profileController = lc.storyboard?.instantiateViewController(identifier: Constants.Storyboard.profileController) as? ProfilePageViewController
                lc.view.window?.rootViewController = profileController
                lc.view.window?.makeKeyAndVisible()
            }
        }
    }
    
    
    func googleSignin(user: GIDGoogleUser, lc: LoginController){
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,accessToken: authentication.accessToken)
        
        Auth.auth().signIn(with: credential) { (result, error) in
            if let error = error {
                lc.errorLabel.text = error.localizedDescription
                lc.errorLabel.textColor = UIColor.init(red: 255/255, green: 0/255, blue: 0/255, alpha: 1)
            }
            else {
                let ProfileController = lc
                    .storyboard?.instantiateViewController(identifier: Constants.Storyboard.profileController) as? ProfilePageViewController
                lc.view.window?.rootViewController = ProfileController
                lc.view.window?.makeKeyAndVisible()
            }
            
        }
        // Perform any operations on signed in user here.
        GlobalVariable.googleUsername = user.profile.name
        GlobalVariable.googleEmail = user.profile.email
        GlobalVariable.googleIconUrl = user.profile.imageURL(withDimension: 400)
    }
    
    //Function from ForgetPasswordController
    func sendUserEmail(email: String, fg: ForgetPasswordViewController){
        Auth.auth().sendPasswordReset(withEmail: email) { (error) in
            if error == nil{
                fg.message.alpha = 1
                fg.message.textColor = UIColor.init(red: 146/255, green: 170/255, blue: 68/255, alpha: 1)
                fg.message.text = "A link has been sent to your email!"
            }
            else{
                fg.message.alpha = 1
                fg.message.textColor = UIColor.init(red: 255/255, green: 0/255, blue: 0/255, alpha: 1)
                fg.message.text = "Can't find the email"
            }
        }
    }
    
    
    
    // functions from RegisterViewController
    
    
    func createUser(username: String, email:String, password:String ,rc:RegisterViewController){
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            
            if error != nil{
                let errorMessage = error!.localizedDescription
                rc.showError(errorMessage.split(separator: ".")[0] + ".")
            }
            else{
                //created sucessfully
                let db = Firestore.firestore()
                db.collection("users").document(result!.user.uid).setData(["username":username, "email":email, "uid": result!.user.uid, "favRecipe":[]]) { (error) in
                    if error != nil{
                        rc.showError("Error saving user's data")
                    }
                }
                // Transition to the home scree
                rc.transitionHome()
            }
        }
    }
    
    
    
    
    func uploadProfileImage(_ image:UIImage, completion: @escaping ((_ url:URL?)->())){
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let storageRef = Storage.storage().reference().child("users/\(uid)")
        
        guard let imageData = image.jpegData(compressionQuality: 0.75) else {return}
        
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        
        storageRef.putData(imageData, metadata: metaData) {metaData, error in
            if error == nil, metaData != nil {
                completion(nil)
                
            } else {
                completion(nil)
            }
            //success
        }
    }
    
    
    //Functions from RatingViewController
    
    func getRatingdb(rvc: RatingViewController){
        rvc.currentUid = Auth.auth().currentUser!.uid
        let db = Firestore.firestore()
        let ratingdb = Database.database().reference().child("Recipe/-M8IVR-st6dljGq6M4xN/"+rvc.passid+"/rating");
        //get ratingnumber
        ratingdb.observeSingleEvent(of: .value) { (snapshot) in
            let ratingtuple = snapshot.value as! [Int];
            rvc.numofpeople = ratingtuple[1]
            rvc.ratingsum = ratingtuple[0]
        }
        //get ratedlist
        db.collection("users").document(rvc.currentUid).getDocument { (document, error) in
            if error == nil {
                if document != nil && document!.exists {
                    let documentData = document?.data()
                    rvc.ratedlist = documentData?["ratedlist"] as? [String] ?? []
                    if rvc.ratedlist.contains(rvc.passid){
                        rvc.ratedornot = true
                    }
                } else {
                    print("Can read the document but the document might not exists")
                }
            } else {
                print("Something wrong reading the document")
            }
        }
        //return ratingdb
    }
    
    
    
    func tapSubmit(submitbutton: UIButton!, rvc: RatingViewController){
        let db = Firestore.firestore()
        if (!rvc.ratedornot){
            rvc.ratedlist.append(rvc.passid)
            db.collection("users").document(rvc.currentUid).updateData(["ratedlist" : rvc.ratedlist])
            rvc.numofpeople = rvc.numofpeople + 1
            rvc.ratingsum = rvc.ratingsum + rvc.ratingarray.last!
            let ratingdb = Database.database().reference().child("Recipe/-M8IVR-st6dljGq6M4xN/"+rvc.passid+"/rating");
            ratingdb.setValue([rvc.ratingsum,rvc.numofpeople])
            rvc.ratedornot = true
            rvc.dismiss(animated: true, completion: nil)}
            //ref.setValue(ratingarray.last)}
        else {
            let alert = UIAlertController(title: "Already rated", message: "You have already rated this recipe~", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            rvc.present(alert, animated: true, completion: nil)
            submitbutton.isEnabled = false
            submitbutton.setTitleColor(.gray, for: .normal)
        }
    }
    
    
    
    
    
    
    
    
    // Function from MyChoresViewController
    func loadMyChores(mcvc: MyChoresViewController) {
        let currentUid = Auth.auth().currentUser!.uid
        db.collection("users").document(currentUid).collection("chores").getDocuments { (snapshot, error) in
            for document in snapshot!.documents{
                let data = document.data()
                let name = data["choreName"] as? String ?? ""
                let ldDate = data["lastDone"] as? String ?? ""
                let freq = data["frequency"] as? String ?? ""
                let rDate = data["remindDate"] as? String ?? ""
                let rOrNot = data["remindOrNot"] as? Bool ?? false
                let chore = Chore(task: name, lastDone: ldDate, timePeriod: freq, remindDate: rDate, remindOrNot: rOrNot)
                mcvc.chores.append(chore)
            }
            mcvc.choresList.reloadData()
        }
    }
    
    func deleteChores (mcvc: MyChoresViewController, taskName: String, index: Int) {
        let currentUid = Auth.auth().currentUser!.uid
        let choreRef = self.db.collection("users").document(currentUid).collection("chores").document(taskName)
        choreRef.getDocument { (document, error) in
            if error == nil {
                if document != nil && document!.exists {
                    let documentData = document?.data()
                    let remindOrNot = documentData?["remindOrNot"] as! Bool
                    if remindOrNot{
                        let reminderID = documentData?["reminderID"] as! String
                        let center = UNUserNotificationCenter.current()
                        center.removePendingNotificationRequests(withIdentifiers: [reminderID])
                    }
                    self.db.collection("users").document(currentUid).collection("chores").document(taskName).delete()
                    mcvc.chores.remove(at: index)
                    mcvc.choresList.reloadData()
                }
            }
        }
    }
    
    func skipChores(mcvc: MyChoresViewController, taskName: String) {
        let currentUid = Auth.auth().currentUser!.uid
        let choreRef = self.db.collection("users").document(currentUid).collection("chores").document(taskName)
        choreRef.getDocument { (document, error) in
            if error == nil {
                if document != nil && document!.exists {
                    let documentData = document?.data()
                    let remindOrNot = documentData?["remindOrNot"] as! Bool
                    if remindOrNot{
                        let reminderID = documentData?["reminderID"] as! String
                        let center = UNUserNotificationCenter.current()
                        center.removePendingNotificationRequests(withIdentifiers: [reminderID])
                    }
                    let choreName = documentData?["choreName"] as! String
                    let lastDone = documentData?["lastDone"] as! String
                    let remindDate = documentData?["remindDate"] as! String
                    let frequency = documentData?["frequency"] as! String
                    let formatter = DateFormatter()
                    formatter.dateFormat = "MM/dd/yyyy"
                    let newRemindDate = mcvc.updateRemindDate(date: formatter.string(from: Date()), freq: frequency)
                    var newRequestID = ""
                    if remindOrNot{
                        newRequestID = self.pushNotification(chore: choreRef, choreName: choreName, frequency: frequency, lastDone: lastDone, remindDate: remindDate)
                    }
                    choreRef.setData(["choreName": choreName, "frequency": frequency, "lastDone": lastDone, "remindDate": newRemindDate, "remindOrNot": remindOrNot, "reminderID": newRequestID])
                    mcvc.choresList.reloadData()
                }
            }
        }
    }
    
    func remindChores(mcvc: MyChoresViewController, taskName: String) {
        let currentUid = Auth.auth().currentUser!.uid
        let choreRef = self.db.collection("users").document(currentUid).collection("chores").document(taskName)
        choreRef.getDocument { (document, error) in
            if error == nil {
                if document != nil && document!.exists {
                    let documentData = document?.data()
                    let choreName = documentData?["choreName"] as! String
                    let lastDone = documentData?["lastDone"] as! String
                    var remindDate = documentData?["remindDate"] as! String
                    let frequency = documentData?["frequency"] as! String
                    let date = Date()
                    let formatter = DateFormatter()
                    formatter.dateFormat = "MM/dd/yyyy"
                    let remindDateObj = formatter.date(from: remindDate)
                    let reChoose = remindDateObj ?? date < date // is true if remind date is in the past
                    if reChoose {
                        //1. Create the alert controller.
                        let alert = UIAlertController(title: "Your remind date has passed", message: "Please reselect your remind date", preferredStyle: .alert)
                        
                        //2. Add the text field. You can configure it however you need.
                        alert.addTextField { (textField) in
                            mcvc.doDatePicker()
                            textField.inputView = mcvc.datePicker
                            textField.text = formatter.string(from: mcvc.datePicker!.date)
                            mcvc.RemindRechooseTextF = textField
                            mcvc.datePicker?.addTarget(mcvc, action: #selector(mcvc.datePickerChanged), for: .valueChanged)
                        }
                        
                        // 3. Grab the value from the text field, and print it when the user clicks OK.
                        alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { [weak alert] (_) in
                            let formatter = DateFormatter()
                            formatter.dateFormat = "MM/dd/yyyy"
                            mcvc.remindDate = formatter.string(from: mcvc.datePicker!.date)
                            
                            if mcvc.RemindRechoosePastDate {
                                mcvc.createAlert(title: "Remind failed", message: "You have to set the remind date to a future day")
                            } else {
                                self.pushNotification(chore: choreRef, choreName: choreName, frequency: frequency, lastDone: lastDone, remindDate: mcvc
                                    .remindDate)
                                mcvc.createAlert(title: "Remind success", message: "Remind date changed successfully!")
                            }
                        }))
                        // 4. Present the alert.
                        mcvc.present(alert, animated: true, completion: nil)
                        
                    } else {
//                        remindDate = formatter.string(from: date)
                        
                        self.pushNotification(chore: choreRef, choreName: choreName, frequency: frequency, lastDone: lastDone, remindDate: remindDate)
                        mcvc.createAlert(title: "Remind success!", message: "Successfully set the reminder")
                    }
                }
            }
        }
    }
    
    func finishChores(mcvc: MyChoresViewController, taskName: String, index: Int) {
        let currentUid = Auth.auth().currentUser!.uid
        var choreRef = self.db.collection("users").document(currentUid).collection("chores").document(taskName)
        choreRef.getDocument { (document, error) in
            if error == nil {
                if document != nil && document!.exists {
                    let documentData = document?.data()
                    let remindOrNot = documentData?["remindOrNot"] as! Bool
                    if remindOrNot{
                        let reminderID = documentData?["reminderID"] as! String
                        let center = UNUserNotificationCenter.current()
                        center.removePendingNotificationRequests(withIdentifiers: [reminderID])
                    }
                    
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "MM/dd/yyyy"
                    mcvc.remindDate = mcvc.updateRemindDate(date: dateFormatter.string(from: Date()), freq: mcvc
                        .chores[index].timePeriod)
                    let choreName = documentData?["choreName"] as! String
                    let lastDone = documentData?["lastDone"] as! String
                    let remindDate = documentData?["remindDate"] as! String
                    let frequency = documentData?["frequency"] as! String
                    let date = Date()
                    let formatter = DateFormatter()
                    formatter.dateFormat = "MM/dd/yyyy"
                    
                    mcvc.chores[index].lastDone = formatter.string(from: date)
                    
                    if remindOrNot {
                        let requestID = self.pushNotification(chore: choreRef, choreName: choreName, frequency: frequency, lastDone: lastDone, remindDate: remindDate)
                        self.db.collection("users").document(currentUid).collection("chores").document(taskName)
                            .setData(
                                ["choreName":mcvc.chores[index].task,
                                 "lastDone": mcvc.chores[index].lastDone,
                                 "frequency": mcvc.chores[index].timePeriod,
                                 "remindDate": mcvc.remindDate,
                                 "remindOrNot": mcvc.chores[index].remindOrNot,
                                 "reminderID": requestID])
                    } else {
                        self.db.collection("users").document(currentUid).collection("chores").document(taskName)
                            .setData(
                                ["choreName":mcvc.chores[index].task,
                                 "lastDone": mcvc.chores[index].lastDone,
                                 "frequency": mcvc.chores[index].timePeriod,
                                 "remindDate": mcvc.remindDate,
                                 "remindOrNot": mcvc.chores[index].remindOrNot])
                    }
                    mcvc.choresList.reloadData()
                }
            }
        }
    }
    
    func editDeleteChores (taskName: String) {
        let currentUid = Auth.auth().currentUser!.uid
        self.db.collection("users").document(currentUid).collection("chores").document(taskName).delete()
    }
    
    func editAddChores(mcvc: MyChoresViewController, remindDate: String) {
        let currentUid = Auth.auth().currentUser!.uid
        db.collection("users").document(currentUid).collection("chores").document(mcvc.editTaskName?.text ?? "").setData(["choreName": mcvc.editTaskName?.text ?? "", "lastDone": mcvc.editLastDoneDate?.text ?? "", "frequency": mcvc.editFrequency?.text ?? "", "remindDate":remindDate, "remindOrNot": false])
    }
    
    func pushNotification (chore:  DocumentReference, choreName: String, frequency:String, lastDone:String, remindDate:String) -> String {
        let choreRemindingDate = remindDate
        let year = Int(choreRemindingDate.split(separator: "/")[2])
        let day = Int(choreRemindingDate.split(separator: "/")[1])
        let month = Int(choreRemindingDate.split(separator: "/")[0])
        
        // Notification
        // Step 1: Ask for permission
        let center = UNUserNotificationCenter.current()
        
        center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
        }
        
        // Step 2: Create the notification content
        let content = UNMutableNotificationContent()
        content.title = "Chores Reminder from IntelliKitchen"
        content.body = "You have to do " + choreName + " on " + remindDate
        
        // Step 3: Create the notification trigger
        var dateComponents = DateComponents()
        dateComponents.year = year
        dateComponents.month = month
        dateComponents.day = day
        dateComponents.timeZone = TimeZone(abbreviation: "PST")
        dateComponents.hour = 15
        dateComponents.minute = 27
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        
        // Step 4: Create the request
        
        let uuidString = UUID().uuidString
        
        let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)
        let requestID = request.identifier // Need to save to Firebase
        
        // Step 5: Register the request
        center.add(request) { (error) in
            // Check the error parameter and handle any errors
        }
        
        // update information in databse
        chore.setData(["choreName": choreName, "frequency": frequency, "lastDone": lastDone, "remindDate": remindDate, "remindOrNot": true, "reminderID": requestID])
        return requestID
    }
    
    
    // Function from AddFoodViewController
    func loadAddFood (afvc: AddFoodViewController) {
        let currentUid = Auth.auth().currentUser!.uid
        self.db.collection("users").document(currentUid).collection("foods").document(afvc.foodNameField.text ?? "")
            .setData(
                ["foodName": afvc.foodNameField.text ?? "",
                 "boughtDate": afvc.boughtDateField.text ?? "",
                 "expireDate": afvc.expirationDateField.text ?? ""])
    }
    
    // Function from MyFoodViewController
    func loadMyFood (mfvc: MyFoodViewController) {
        let currentUid = Auth.auth().currentUser!.uid
        self.db.collection("users").document(currentUid).collection("foods").getDocuments { (snapshot, error) in
            for document in snapshot!.documents{
                let data = document.data()
                let name = data["foodName"] as? String ?? ""
                let bDate = data["boughtDate"] as? String ?? ""
                let eDate = data["expireDate"] as? String ?? ""
                let newFood = Foods(foodName: name, boughtDate: bDate, expireDate: eDate)
                mfvc.foods.append(newFood)
            }
            mfvc.foodListTable.reloadData()
        }
    }
    
    func deleteFood(mfvc: MyFoodViewController, index: Int) {
        let currentUid = Auth.auth().currentUser!.uid
        self.db.collection("users").document(currentUid).collection("foods").document(mfvc.foods[index].foodName).delete()
    }
    
    func editFood(mfvc: MyFoodViewController, index: Int) {
        let currentUid = Auth.auth().currentUser!.uid
        db.collection("users").document(currentUid).collection("foods").document(mfvc.foods[index].foodName).delete()
        db.collection("users").document(currentUid).collection("foods").document(mfvc.editFoodName?.text ?? "").setData(["foodName":mfvc.editFoodName?.text ?? "", "boughtDate":mfvc.editBoughtDate?.text ?? "", "expireDate":mfvc.editExpireDate?.text ?? ""])
    }
    
    // Function from FoodViewController
    func loadFoodInfo (fvc: FoodViewController) {
        let currentUid = Auth.auth().currentUser!.uid
        self.db.collection("users").document(currentUid).collection("foods").getDocuments { (snapshot,error) in
            if(error != nil){
                print(error!)
            }else{
                for document in (snapshot!.documents){
                    let name = document.data()["foodName"] as! String
                    let expireSingle = document.data()["expireDate"] as! String
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "MM/dd/yyyy"
                    dateFormatter.locale = Locale.init(identifier: "en_GB")
                    if(expireSingle != ""){
                        let d = dateFormatter.date(from: expireSingle)!
                        let today = Date()
                        let calendar = Calendar.current
                        // Replace the hour (time) of both dates with 00:00
                        let date1 = calendar.startOfDay(for: today)
                        let date2 = calendar.startOfDay(for: d)
                        
                        let components = calendar.dateComponents([.day], from: date1, to: date2)
                        let inday = components.day!
                        fvc.list.append(Food(name: name,expiredate: inday))
                    }
                    fvc.list = fvc.list.sorted(by: { $0.expiredate < $1.expiredate })
                    fvc.tableView.reloadData()
                }
            }
        }
    }
    
    // Function from ChoresViewController
    func loadChoresInfo(cvc: ChoresViewController){
        
        let currentUid = Auth.auth().currentUser!.uid
        let db = Firestore.firestore()
        db.collection("users").document(currentUid).collection("chores").getDocuments { (snapshot,error) in
            if (error != nil) {
                print(error!)
            } else {
                for document in (snapshot!.documents){
                    let name = document.data()["choreName"] as! String
                    //self.foodList.append(name)
                    let expireSingle = document.data()["remindDate"] as! String
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "MM/dd/yyyy"
                    dateFormatter.locale = Locale.init(identifier: "en_GB")
                    if(expireSingle != "") {
                        let d = dateFormatter.date(from: expireSingle)!
                        let today = Date()
                        let calendar = Calendar.current
                        // Replace the hour (time) of both dates with 00:00
                        let date1 = calendar.startOfDay(for: today)
                        let date2 = calendar.startOfDay(for: d)
                        let components = calendar.dateComponents([.day], from: date1, to: date2)
                        let inday = components.day!
                        var message = ""
                        var message2 = ""
                        if(inday < 0){
                            message = "Did not " + name + " for "
                            message2 = String(0-inday) + " days"
                        }
                        else if(inday == 0){
                            message = name
                            message2 = "today"
                        }
                        else if(inday > 0){
                            message = name + " in "
                            message2 = String(inday) + " days"
                        }
                        cvc.list.append(Choreshomepage(name: name,expiredate: inday, message: message, message2: message2))
                    }
                    cvc.list = cvc.list.sorted(by: { $0.expiredate < $1.expiredate })
                    cvc.tableView.reloadData()
                }
            }
        }
    }
    
    
    // Function from ByIngredientController
    func getIngredients(bic:ByIngredientController) {
        let ingredientRef = Database.database().reference().child("Ingredients")
        ingredientRef.observeSingleEvent(of: .value) { (snapshot) in
            for child in snapshot.children {
                let snap = child as! DataSnapshot
                bic.allIngredient.append(snap.key)
                bic.ingredientTableView.reloadData()
            }
        }
    }
    
    // Function from ByNameController
    func getRecipeNames(bnc:ByNameController) {
        let nameRef = Database.database().reference().child("RecipeNameTOId")
        nameRef.observeSingleEvent(of: .value) { (snapshot) in
            for child in snapshot.children {
                let snap = child as! DataSnapshot
                bnc.recipeNameArray.append(snap.key)
                bnc.nameTableView.reloadData()
            }
        }
    }
    
    // Function from RecipeViewController
    
    // Function from MyChoresViewController
    
    //Functions from ProfilepageViewController
    func loadUserInfo(ppvc: ProfilePageViewController){
        let db = Firestore.firestore()
        
        let tempGoogleUsername = GlobalVariable.googleUsername
        let tempGoogleEmail = GlobalVariable.googleEmail
        let tempGoogleIconUrl = GlobalVariable.googleIconUrl
        
        //handle google log in
        if tempGoogleUsername != "" && tempGoogleEmail != ""{
            ppvc.userName?.text = tempGoogleUsername
            
            ppvc.userEmail?.text = tempGoogleEmail
            
            guard let imageURL = tempGoogleIconUrl else { return  }
            
            DispatchQueue.global().async {
                guard let imageData = try? Data(contentsOf: imageURL) else { return }
                
                let image = UIImage(data: imageData)
                DispatchQueue.main.async {
                    ppvc.myImageView?.image = image
                    self.uploadProfileImage(ppvc: ppvc, image!){(url) in
                        
                    }
                }
            }
            let currentUid = Auth.auth().currentUser!.uid
            
            db.collection("users").document(currentUid).collection("favoriteRecipe").getDocuments{ (snapshot, error) in
                for document in snapshot!.documents{
                    let documentData = document.data()
                    ppvc.favoriteIDList = documentData["favRecipe"] as! [String]
                    if ppvc.favoriteIDList.count == 0{
                        ppvc.favRecipeAlert?.text = "Add Some Favorite while Searching"
                    } else {
                        ppvc.favRecipeAlert?.text = "My Favorite Recipes:"
                        
                    }
                    ppvc.favoriteRecipes = ppvc.createArray(ppvc.favoriteIDList)
                }
            }
            
            db.collection("users").document(currentUid).setData(["username":tempGoogleUsername, "email":tempGoogleEmail, "uid": currentUid]) { (error) in
                if error != nil{
                    print(" error when saving google sign in information")
                }
            }
            //handle normal login
        } else {
            let currentUid = Auth.auth().currentUser!.uid
            db.collection("users").document(currentUid).getDocument { (document, error) in
                print(ppvc.userName?.text)
                if error == nil {
                    if document != nil && document!.exists {
                        let documentData = document?.data()
                        
                        ppvc.userName?.text = documentData?["username"] as? String
                        ppvc.userEmail?.text = documentData?["email"] as? String
                        ppvc.loadImageFromFirebase()
                        
                    } else {
                        print("Can read the document but the document might not exists")
                    }
                    
                } else {
                    print("Something wrong reading the document")
                }
            }
            db.collection("users").document(currentUid).collection("favoriteRecipe").getDocuments{ (snapshot, error) in
                for document in snapshot!.documents{
                    let documentData = document.data()
                    ppvc.favoriteIDList = documentData["favRecipe"] as! [String]
                    if ppvc.favoriteIDList.count == 0{
                        ppvc.favRecipeAlert?.text = "Add Some Favorite while Searching"
                    } else {
                        ppvc.favRecipeAlert?.text = "My Favorite Recipes:"
                    }
                    ppvc.favoriteRecipes = ppvc.createArray(ppvc.favoriteIDList)
                }
            }
        }
    }
    
    
    func retrieveFR(ppvc: ProfilePageViewController, _ favoriteIDList: [String], completion: @escaping (_ searchedRecipes: [FavoriteRecipe]) -> Void){
        let ref = Database.database().reference()
        var temp: [FavoriteRecipe] = []
        
        for recipe in favoriteIDList{
            let currentRecipeString = "Recipe/-M8IVR-st6dljGq6M4xN/" + recipe
            let recipeRef = ref.child(currentRecipeString)
            recipeRef.observe(.value, with: {snapshot in
                let snap = snapshot as! DataSnapshot
                if let dict = snap.value as? [String: Any]{
                    var currentImage = UIImage()
                    var urlString = try! dict["img"] as? String
                    if urlString == nil {
                        urlString = try! dict["recipe_pic"] as! String
                    }
                    if urlString == nil {
                        currentImage = UIImage(imageLiteralResourceName: "RecipeImage.jpg")
                    } else {
                        var imageUrl = URL(string: urlString!)
                        let imageData = try! Data(contentsOf: imageUrl!)
                        currentImage = UIImage(data: imageData)!
                    }
                    var currentTitle = dict["recipe_name"] as! String
                    let tempFR = FavoriteRecipe(image: currentImage, title: currentTitle)
                    temp.append(tempFR)
                }
                completion(temp)
            })
        }
    }
    
    func uploadProfileImage(ppvc: ProfilePageViewController, _ image:UIImage, completion: @escaping ((_ url:URL?)->())){
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let storageRef = Storage.storage().reference().child("users/\(uid)")
        
        guard let imageData = image.jpegData(compressionQuality: 0.75) else {return}
        
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        
        storageRef.putData(imageData, metadata: metaData) {metaData, error in
            if error == nil, metaData != nil {
                //if let url = storageRef.downloadURL(completion: (URL?, Error?) -> Void){
                completion(nil)
                
            } else {
                completion(nil)
            }
            //success
        }
    }
    
    func changePasswordHelper(ppvc: ProfilePageViewController){
        let email = Auth.auth().currentUser?.email
        
        Auth.auth().sendPasswordReset(withEmail: email!) { (error) in
            if error == nil{
                ppvc.createAlertSignOut(title: "Success", message: "A link has been sent to your email!")
            }
            else{
                ppvc.createAlert(title: "Oops!", message: "There‘s something wrong. Please try again.")
            }
        }
    }
    
    func loadImageFromFirebaseHelper(ppvc:ProfilePageViewController){
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let storageRef = Storage.storage().reference().child("users/\(uid)")
        storageRef.getData(maxSize: 1*65536*65536) {data, error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                // Data for "images/island.jpg" is returned
                ppvc.myImageView?.image = UIImage(data: data!)
            }
        }
    }
    
    
    func saveUsernameActionHelper(ppvc: ProfilePageViewController){
        let db = Firestore.firestore()
        let currentUid = Auth.auth().currentUser!.uid
        let updateString = ppvc.userName!.text
        db.collection("users").document(currentUid).updateData(["username": updateString])
    }
    
    func signoutTappedHelper(ppvc: ProfilePageViewController){
        
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
    //Function from ScrollViewController
    func scrollViewDidLoadHelper(svc: ScrollViewController){
        let db = Firestore.firestore()
        
        
        let rootRef = Database.database().reference().child("Recipe/-M8IVR-st6dljGq6M4xN/"+svc.passid+"/steps");
        let titledb = Database.database().reference().child("Recipe/-M8IVR-st6dljGq6M4xN/"+svc.passid+"/recipe_name");
        let ingredientsdb = Database.database().reference().child("Recipe/-M8IVR-st6dljGq6M4xN/"+svc.passid+"/ingredients");
        var imagedb = Database.database().reference().child("Recipe/-M8IVR-st6dljGq6M4xN/"+svc.passid+"/img");
        var imagedbnew = Database.database().reference().child("Recipe/-M8IVR-st6dljGq6M4xN/"+svc.passid+"/recipe_pic");
        var ratingdb = Database.database().reference().child("Recipe/-M8IVR-st6dljGq6M4xN/"+svc.passid+"/rating");
        
        
        
        let currentUid = Auth.auth().currentUser!.uid
        db.collection("users").document(currentUid).collection("favoriteRecipe").getDocuments { (snapshot, error) in
            for document in snapshot!.documents{
                let documentData = document.data()
                svc.favlist = documentData["favRecipe"] as? [String] ?? []
                if svc.favlist.contains(svc.passid){
                    svc.favornot = true
                }
                if svc.favornot{
                    svc.FavouriteButton.setImage(UIImage(named:"feather-heart"), for: .normal)
                }
                else{
                    svc.FavouriteButton.setImage(UIImage(named:"Ellipse 2"), for: .normal)
                }
            }
        }
        
        //get rating
        ratingdb.observeSingleEvent(of: .value) { (snapshot) in
            var ratingtuple = snapshot.value as! [Int];
            var avrating = Double(ratingtuple[0])/Double(ratingtuple[1])
            svc.ratinglabel.text = "Average Rating: " + String(format: "%.1f", avrating) + "     " + String(ratingtuple[1]) + " have rated"
        }
        
        
        //grab steps from db
        rootRef.observe(.value, with: { snapshot in
            svc.mylist = snapshot.value as! [String];
            let length = svc.mylist.count;
            
            for i in 0...length-1{
                svc.wholelist = svc.wholelist + String(i+1) + ". " + svc.mylist[i]+"\n\n";
            }
            svc.stepsdisplay.text = svc.wholelist;
            svc.innerscroll.contentLayoutGuide.bottomAnchor.constraint(equalTo: svc.stepsdisplay.bottomAnchor).isActive = true
            
        })
        
        // grab menutitle
        titledb.observeSingleEvent(of: .value) { (snapshot) in
            svc.menutitle.text = snapshot.value as! String;
            svc.menutitle.text = (svc.menutitle.text)?.capitalized;
        }
        
        // grab ingredients
        ingredientsdb.observe(.value) { (snapshot) in
            svc.ingredientlist = snapshot.value as! [String];
            svc.ingredientlist = (svc.ingredientlist).removingDuplicates();
            let length2 = svc.ingredientlist.count;
            for j in 0...length2-1{
                if (j%2 == 0) {
                    svc.leftstring = svc.leftstring + (svc.ingredientlist[j]).capitalized + "\n";
                }
                else{
                    svc.rightstring = svc.rightstring + (svc.ingredientlist[j]).capitalized + "\n";
                }
            }
            svc.lefthalf.text = svc.leftstring;
            svc.righthalf.text = svc.rightstring;
            svc.ingrescroll.contentLayoutGuide.bottomAnchor.constraint(equalTo: svc.lefthalf.bottomAnchor).isActive = true
            
        }
        
        // grab recipe photo
        imagedb.observeSingleEvent(of: .value) { (snapshot) in
            if(!(snapshot.value is NSNull)){
                svc.imageurl = URL(string: snapshot.value as! String);
                svc.menupic.load(url: svc.imageurl);
                svc.menupic.layer.cornerRadius = 10;
            }
            else{
                imagedbnew.observeSingleEvent(of: .value) { (snapshot) in
                    if(snapshot.value != nil){
                        svc.imageurl = URL(string: snapshot.value as! String);
                        svc.menupic.load(url: svc.imageurl);
                        svc.menupic.layer.cornerRadius = 10;
                    }
                }
            }
        }
        
        self.forloopHelper(svc: svc);
        
        db.collection("users").document(currentUid).getDocument { (document, error) in
            if error == nil {
                if document != nil && document!.exists {
                    let documentData = document?.data()
                    svc.commentedlist = documentData?["commentedlist"] as? [String] ?? []
                    if svc.commentedlist.contains(svc.passid){
                        svc.commentornot = true
                    }
                } else {
                    print("Can read the document but the document might not exists")
                }
                
            } else {
                print("Something wrong reading the document")
            }
        }
    }
    
    func submitButtonHelper(submitdisplay: UIButton, svc: ScrollViewController){
        let db = Firestore.firestore()
        let currentUid = Auth.auth().currentUser!.uid
        if (!svc.commentornot){
            let commentdb = Database.database().reference().child("Recipe/-M8IVR-st6dljGq6M4xN/"+svc.passid+"/comments");
            svc.commentcelllist.removeAll()
            svc.commentlist.append([currentUid, svc.Comments.text!]);
            commentdb.setValue(svc.commentlist);
            svc.commentedlist.append(svc.passid)
            db.collection("users").document(currentUid).updateData(["commentedlist" : svc.commentedlist])
            
            
            svc.commentornot = true
            svc.Comments.text = nil
        } else {
            let alert = UIAlertController(title: "Already commented", message: "You have already commented this recipe~", preferredStyle: UIAlertController.Style.alert)
            svc.Comments.text = nil
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            svc.present(alert, animated: true, completion: nil)
            svc.submitdisplay.isEnabled = false
            svc.submitdisplay.setTitleColor(.gray, for: .normal)
        }
    }
    
    func clickFavouriteButtonHelper(FavouriteButton: UIButton, svc:ScrollViewController){
        let db = Firestore.firestore()
        let currentUid = Auth.auth().currentUser!.uid
        if(!svc.favornot) {
            svc.FavouriteButton.setImage(UIImage(named:"feather-heart"), for: .normal)
            svc.favlist.append(svc.passid)
            db.collection("users").document(currentUid).collection("favoriteRecipe").document("favRecipeList").setData(["favRecipe": svc.favlist])
            svc.favornot = true
        }
        else{
            svc.FavouriteButton.setImage(UIImage(named:"Ellipse 2"), for: .normal)
            let index = svc.favlist.firstIndex(of: svc.passid)
            svc.favlist.remove(at: index!)
            db.collection("users").document(currentUid).collection("favoriteRecipe").document("favRecipeList").setData(["favRecipe": svc.favlist])
            svc.favornot = false
        }
    }
    
    func beforeforloopHelper(svc:ScrollViewController, completion: @escaping (_ temptemp: [[String]]) ->Void){
        var temptemp: [[String]] = [[""]]
        let commentdb = Database.database().reference().child("Recipe/-M8IVR-st6dljGq6M4xN/"+svc.passid+"/comments");
        commentdb.observe(.value) { (snapshot) in
            temptemp = snapshot.value as! [[String]] ;
            completion(temptemp)
        }
    }
    
    func generateuserpicHelper(svc:ScrollViewController, _ currentid: String, completion: @escaping (_ picarray: Data ) -> Void){
        //self.commentlist = temptemp
        generateusernameHelper(svc: svc, currentid, completion: { namearray in
            var picarray: Data?
            svc.infoUsername[currentid] = namearray
            let storageRef = Storage.storage().reference().child("users/\(currentid)")
            storageRef.getData(maxSize: 1*65536*655366) { (data, error) in
                if (data == nil) {
                    picarray = try! Data(contentsOf: URL(string:"https://revleap.com/wp-content/themes/revleap/images/no-profile-image.jpg")!)
                }
                else{
                    picarray = data
                }
                completion(picarray!)
            }
        })
    }
    
    func generateusernameHelper(svc:ScrollViewController, _ currentid: String, completion: @escaping (_ namearray: (String) ) -> Void){
        let db = Firestore.firestore()
        let currentUid = Auth.auth().currentUser!.uid
        var namearray:String = ""
        db.collection("users").document(currentid).getDocument { (document, error) in
            if error == nil {
                if document != nil && document!.exists {
                    let documentData = document?.data()
                    namearray = documentData?["username"] as? String ?? ""
                    
                } else {
                    print("Can read the document but the document might not exists")
                }
                
            } else {
                print("Something wrong reading the document")
            }
            completion(namearray)
        }
    }
    
    func forloopHelper(svc:ScrollViewController){
        beforeforloopHelper (svc:svc, completion: {temptemp in
            svc.commentlist = temptemp
            var count = 0
            for eachstring in svc.commentlist {
                let currentid = eachstring[0]
                self.generateuserpicHelper(svc: svc, currentid, completion: { namepic in
                    svc.infoPhoto[currentid] = namepic
                    
                    let tempcomment = Comment(image: UIImage(data: svc.infoPhoto[currentid]!)!, name: svc.infoUsername[currentid] ?? "", description: eachstring[1]);
                    count = count + 1
                    svc.commentcelllist.append(tempcomment)
                    if svc.commentcelllist.count == 0{
                        svc.commentstableview.isHidden = true
                    } else {
                        svc.commentstableview.isHidden = false
                        svc.commentstableview.reloadData()
                    }
                })
            }
            
        })
    }
    
    func viewWillAppearHelper(svc: ScrollViewController){
        var ratingdb = Database.database().reference().child("Recipe/-M8IVR-st6dljGq6M4xN/"+svc.passid+"/rating");
        ratingdb.observeSingleEvent(of: .value) { (snapshot) in
            var ratingtuple = snapshot.value as! [Int];
            var avrating = Double(ratingtuple[0])/Double(ratingtuple[1])
            svc.ratinglabel.text = "Average Rating: " + String(format: "%.1f", avrating) + "     " + String(ratingtuple[1]) + " have rated"
        }
    }
    
    //function from AddChoresViewController
    func addTappedHelper(acvc: AddChoresViewController){
        let db = Firestore.firestore()
        let currentUid = Auth.auth().currentUser!.uid
        db.collection("users").document(currentUid).collection("chores").document(acvc.taskField.text ?? "").setData(["choreName":acvc.taskField.text ?? "", "lastDone":acvc.lastDoneField.text ?? "", "frequency":acvc.timePeriodField.text ?? "", "remindDate":acvc.remindDate, "remindOrNot": false])
        acvc.createAlert(title: "Success!", message: "Successfully added chore!")
    }
    
    // Function from RecipeViewController
    func loadRecipe(rvc: RecipeViewController) {
        var ref = Database.database().reference()
        let db = Firestore.firestore()
        let currentUid = Auth.auth().currentUser!.uid
        db.collection("users").document(currentUid).collection("foods").getDocuments { (snapshot,error) in
            if(error != nil){
                print(error!)
            }else{
                for document in (snapshot!.documents){
                    let name = document.data()["foodName"] as! String
                    let expireSingle = document.data()["expireDate"] as! String
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "MM/dd/yyyy"
                    dateFormatter.locale = Locale.init(identifier: "en_GB")
                    if(expireSingle != ""){
                        let d = dateFormatter.date(from: expireSingle)!
                        let today = Date()
                        let calendar = Calendar.current
                        // Replace the hour (time) of both dates with 00:00
                        let date1 = calendar.startOfDay(for: today)
                        let date2 = calendar.startOfDay(for: d)
                        
                        let components = calendar.dateComponents([.day], from: date1, to: date2)
                        let inday = components.day!
                        if(inday>0){
                            rvc.list.append(Food(name: name,expiredate: inday))
                        }
                    }
                }
                rvc.list = rvc.list.sorted(by: { $0.expiredate < $1.expiredate })
                self.getdicList(rvc: rvc, completionHandler: { (list) in
                    let list = list
                    for index in list{
                        let databaseHandle = ref.child("Recipe/-M8IVR-st6dljGq6M4xN/"+String(index)).observe(.value, with: { (snapshot) in
                            let value = snapshot.value as? NSDictionary
                            let recipe_name = value?.value(forKey: "recipe_name") as! String
                            if(!rvc.allRecipe.contains(recipe_name)){
                                var image = UIImage(named: "Mask Group 7")
                                if(value?.value(forKey: "img") != nil){
                                    let name = value?.value(forKey: "img") as! String
                                    let imageURL = URL(string: name)
                                    let data = try? Data(contentsOf: imageURL!)
                                    image = UIImage(data: data!)
                                    rvc.allRecipe.append(recipe_name)
                                    rvc.recipelist.append(Recipehomepage(image: image!, name: recipe_name, id: String(index)))
                                    rvc.collectionView.reloadData()
                                    rvc.collectionView .layoutIfNeeded()
                                }
                                else{
                                    if(value?.value(forKey: "recipe_pic") != nil){
                                        let name = value?.value(forKey: "recipe_pic") as! String
                                        let imageURL = URL(string: name)
                                        let data = try? Data(contentsOf: imageURL!)
                                        image = UIImage(data: data!)
                                        rvc.allRecipe.append(recipe_name)
                                        rvc.recipelist.append(Recipehomepage(image: image!, name: recipe_name, id: String(index)))
                                        rvc.collectionView.reloadData()
                                        rvc.collectionView .layoutIfNeeded()
                                    }
                                }
                            }
                        })
                    }
                })
            }
        }
    }
    
    func getRecipeList(rvc: RecipeViewController, name: String, completionHandler:@escaping ([Int], [Int]) -> ()) {
        let name2 = name.replacingOccurrences(of: " ", with: "").lowercased()
        var currentfood:[Int] = []
        var transfer:[Int] = []
        var ref = Database.database().reference()

        let databaseHandle = ref.child("Ingredients/"+name2).observe(.value, with: { (snapshot) in
            if(snapshot.exists()){
                transfer.append(contentsOf: snapshot.value as! [Int])
                currentfood = snapshot.value as! [Int]
            }
            let databaseHandle = ref.child("Ingredients/"+name2+"s").observe(.value, with: { (snapshot) in
                if(snapshot.exists()){
                    transfer.append(contentsOf: snapshot.value as! [Int])
                    currentfood = snapshot.value as! [Int]
                }
                completionHandler(transfer, currentfood)
            })
        })
    }
    
    func getdicList(rvc: RecipeViewController, completionHandler:@escaping ([Int]) -> ()) {
        var list:[Int] = []
        for food in rvc.list{
            self.getRecipeList(rvc: rvc, name: food.name){ (translist, currlist) in
                list.append(contentsOf: translist)
                let currlist = currlist
                let mappedItems = list.map { ($0, 1) }
                var returned = [Int]()
                let counts = Dictionary(mappedItems, uniquingKeysWith: +)
                for key in counts.keys{
                    if(counts[key]! >= 2 && returned.count<3){
                        returned.append(key)
                        list = list.filter{$0 != key}
                    }
                }
                while(counts.count > 0 && food.expiredate <= 3 && food.expiredate > 0 && currlist.count > 0 && returned.count<3){
                    returned.append(currlist.randomElement()!)
                }
                while(counts.count > 0 && food.expiredate <= 5 && food.expiredate > 3 && currlist.count > 0 && returned.count<2){
                    returned.append(currlist.randomElement()!)
                }
                while(counts.count > 0 && food.expiredate > 5 && currlist.count > 0 && returned.count<1){
                    returned.append(currlist.randomElement()!)
                }
                completionHandler(returned)
            }
        }
    }
    
    // Function from RecipeListScreen
    func retrieveRecipes(rls: RecipeListScreen, searchByName: Bool, searchArray: [String], completion: @escaping (_ searchedRecipes: [Recipe]) -> Void) {
        var ref = Database.database().reference()

        var tempRecipes: [Recipe] = []
        
        getRecipeID(searchByName, searchArray, completion: { recipeID in
            if recipeID.count == 0 {
                completion(tempRecipes)
            } else {
                let recipeRef = Database.database().reference().child("Recipe/-M8IVR-st6dljGq6M4xN")
                recipeRef.observe(.value, with: { snapshot in
                    for child in snapshot.children {
                        let snap = child as! DataSnapshot
                        if recipeID.contains(Int(snap.key)!) {
                            rls.newrecipeid.append(snap.key)
                            if let dict = snap.value as? [String: Any] {
                                var image = UIImage()
                                if dict["img"] == nil {
                                    if dict["recipe_pic"] == nil {
                                        image = UIImage(imageLiteralResourceName: "RecipeImage.jpg")
                                    } else {
                                        let imageUrl = URL(string: dict["recipe_pic"] as! String)
                                        let imageData = try! Data(contentsOf: imageUrl!)
                                        image = UIImage(data: imageData)!
                                    }
                                } else {
                                    let imageUrl = URL(string: dict["img"] as! String)
                                    let imageData = try! Data(contentsOf: imageUrl!)
                                    image = UIImage(data: imageData)!
                                }
                                let ratingsArray = dict["rating"] as! [Int]
                                let ratingDouble = Double(ratingsArray[0])/Double(ratingsArray[1])
                                let ratingString = String(format: "%.1f", ratingDouble)
                                
                                let recipe = Recipe(image: image, title: dict["recipe_name"] as! String, rating: ratingString)
                                tempRecipes.append(recipe)
                            }
                        }
                    }
                    completion(tempRecipes)
                    
                })
            }
        })
    }
    
    func getRecipeID(_ searchByName: Bool, _ searchArray: [String], completion: @escaping (_ recipeID: [Int]) -> Void) {
        if searchByName {
            var recipeID: [Int] = []
            let recipeRef = Database.database().reference().child("RecipeNameTOId")
            recipeRef.observe(.value, with: {snapshot in
                for child in snapshot.children {
                    let snap = child as! DataSnapshot
                    if searchArray.contains(snap.key) {
                        recipeID.append(contentsOf: (snap.value as? [Int])!)
                    }
                }
                completion(recipeID)
            })
        } else {
            var result = Set<Int>()
            var first = true
            
            let ingredientRef = Database.database().reference().child("Ingredients")
            ingredientRef.observe(.value, with: {snapshot in
                for child in snapshot.children {
                    let snap = child as! DataSnapshot
                    if searchArray.contains(snap.key) {
                        let value = (snap.value as? [Int])!
                        let valueSet = Set(value)
                        if first {
                            result = valueSet
                            first = false
                        } else {
                            result = result.intersection(valueSet)
                        }
                        if result.count == 0 {
                            break
                        }
                    }
                }
                completion(Array(result))
            })
        }
    }
}

