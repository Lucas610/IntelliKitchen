//
//  AddFoodViewController.swift
//  IntelliKitchen_Myfood
//
//  Created by D.WANG on 4/29/20.
//  Copyright © 2020 D.WANG. All rights reserved.
//

import UIKit

class AddFoodViewController: UIViewController {
    
    //reference and global varaible
    @IBOutlet weak var foodNameField: UITextField!
    @IBOutlet weak var boughtDateField: UITextField!
    @IBOutlet weak var expirationDateField: UITextField!
    @IBOutlet weak var foodListTableView: UITableView!
    
    private var datePicker: UIDatePicker?
    private var datePicker2: UIDatePicker?
    
    var foods = [Foods]()
    var data: Db = Db()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        datePicker = UIDatePicker()
        datePicker2 = UIDatePicker()
        datePicker?.datePickerMode = .date
        datePicker2?.datePickerMode = .date
        datePicker?.addTarget(self, action: #selector(AddFoodViewController.dateChanged(datePicker:)), for: .valueChanged)
        datePicker2?.addTarget(self, action: #selector(AddFoodViewController.dateChanged2(datePicker2:)), for: .valueChanged)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(AddFoodViewController.viewTapped(gestureRecognizer:)))
        
        view.addGestureRecognizer(tapGesture)
        boughtDateField?.addTarget(self, action: #selector(self.tapBoughtDate), for: .touchDown)
        expirationDateField?.addTarget(self, action: #selector(self.tapExpDate), for: .touchDown)
        
        boughtDateField.inputView = datePicker
        expirationDateField.inputView = datePicker2
        
    }
    
    @IBAction func addTapped(_ sender: Any) {
        if(foodNameField.text == "" || boughtDateField.text == "" || expirationDateField.text == ""){
            createAlert(title: "Oops", message: "It seems like you miss something!")
        } else {
            self.data.loadAddFood(afvc: self)
            createAlert(title: "Success!", message: "Successfully added food!")
            insertNewFood()
        }
    }
    
    func insertNewFood(){
        let newFood = Foods(foodName: foodNameField.text!, boughtDate: boughtDateField.text!, expireDate: expirationDateField.text!)
        foods.append(newFood)
        foodListTableView.reloadData()
        foodNameField.text = ""
        boughtDateField.text = ""
        expirationDateField.text = ""
    }
    
    // prompt error message
    func createAlert(title:String, message:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {(action) in alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    @objc func viewTapped(gestureRecognizer: UITapGestureRecognizer){
        view.endEditing(true)
    }
    
    @objc func dateChanged(datePicker: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        if( NSDate.init().laterDate(datePicker.date) == datePicker.date){
            createAlert(title: "Oops", message: "Bought date can't be in the futue!")
            view.endEditing(true)
        } else {
            boughtDateField.text = dateFormatter.string(from: datePicker.date)
        }
    }
    
    @objc func dateChanged2(datePicker2: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        if( NSDate.init().earlierDate(datePicker2.date) == datePicker2.date){
            createAlert(title: "Oops", message: "Your food has already expired!")
            view.endEditing(true)
        } else {
            expirationDateField.text = dateFormatter.string(from: datePicker2.date)
        }
    }
    
    @objc func tapBoughtDate() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        boughtDateField.text = dateFormatter.string(from: datePicker!.date)
        view.endEditing(true)
    }
    
    @objc func tapExpDate() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        expirationDateField.text = dateFormatter.string(from: datePicker2!.date)
        view.endEditing(true)
    }
}

