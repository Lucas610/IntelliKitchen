//
//  ViewController.swift
//  IntelliKitchen_Myfood
//
//  Created by D.WANG on 4/25/20.
//  Copyright © 2020 D.WANG. All rights reserved.
//

import UIKit

class MyFoodViewController: UIViewController{
    
    
    @IBOutlet weak var foodListTable: UITableView!
    
    //var ref: DatabaseReference?
    var foodName = [String]()
    var boughtDate = [String]()
    var expireDate = [String]()
    var foods = [Foods]()
    var editFoodName: UITextField?
    var editBoughtDate: UITextField?
    var editExpireDate: UITextField?
    var row: Int = 0
    var data:Db = Db()
    
    public var datePicker: UIDatePicker?
    public var datePicker2: UIDatePicker?
    
    override func viewDidLoad() {

        data.loadMyFood(mfvc: self)
        datePicker = UIDatePicker()
        datePicker2 = UIDatePicker()
        datePicker?.datePickerMode = .date
        datePicker2?.datePickerMode = .date
        datePicker?.addTarget(self, action: #selector(self.dateChanged(datePicker:)), for: .valueChanged)
        datePicker2?.addTarget(self, action: #selector(self.dateChanged2(datePicker2:)), for: .valueChanged)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(MyFoodViewController.viewTapped(gestureRecognizer:)))
        
        view.addGestureRecognizer(tapGesture)
        
        super.viewDidLoad()
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
            editBoughtDate?.text = dateFormatter.string(from: datePicker.date)
        }
    }
    
    @objc func dateChanged2(datePicker2: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        if( NSDate.init().earlierDate(datePicker2.date) == datePicker2.date){
            createAlert(title: "Oops", message: "Your food has already expired!")
            view.endEditing(true)
        } else {
            editExpireDate?.text = dateFormatter.string(from: datePicker2.date)
        }
    }
    
    func createAlert(title:String, message:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {(action) in alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
        
    }
    
}

