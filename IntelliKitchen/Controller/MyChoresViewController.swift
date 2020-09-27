//
//  MyChoresViewController.swift
//  IntelliKitchen_Myfood
//
//  Created by D.WANG on 5/16/20.
//  Copyright © 2020 D.WANG. All rights reserved.
//

import UIKit

class MyChoresViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var choresList: UITableView!

    var chores = [Chore]()
    var editTaskName: UITextField?
    var editLastDoneDate: UITextField?
    var editFrequency: UITextField?
    public var datePicker: UIDatePicker?
    public var pickerView: UIPickerView?
    var remindDate: String = ""
    var row: Int = 0
    let toolBar = UIToolbar()
    var RemindRechooseTextF: UITextField?
    var RemindRechoosePastDate = false
    var data:Db = Db()
    
    let frequencyStr = ["Once a day", "Twice a day", "Once a week", "Twice a week", "Once a month", "Twice a month"]
    
    override func viewDidLoad() {
        
        self.data.loadMyChores(mcvc:self)
        pickerView = UIPickerView()
        pickerView?.dataSource = self
        pickerView?.delegate = self
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .date
        datePicker?.addTarget(self, action: #selector(self.dateChanged(datePicker:)), for: .valueChanged)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(MyChoresViewController.viewTapped(gestureRecognizer:)))
        
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
            view.endEditing(true)
        } else {
            editLastDoneDate?.text = dateFormatter.string(from: datePicker.date)
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return frequencyStr[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return frequencyStr.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        editFrequency?.text = frequencyStr[row]
    }
}

extension MyChoresViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
    {
        let taskName = self.chores[indexPath.row].task
        let index = indexPath.row
        // Write action code for the trash
        let DeleteAction = UIContextualAction(style: .normal, title:  "Delete", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in

            self.data.deleteChores(mcvc: self, taskName: taskName, index: index)
            self.createAlert(title: "Delete success!", message: "Successfully delete the task")
            success(true)
        })
        DeleteAction.backgroundColor = UIColor.init(red: 253/255, green: 131/255, blue: 131/255, alpha: 0.9)
        
        // Write action code for the Flag
        let SkipAction = UIContextualAction(style: .normal, title:  "Skip", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            
            self.data.skipChores(mcvc: self, taskName: taskName)
            self.createAlert(title: "Skip success!", message: "Successfully skip the task")
            success(true)
        })
        SkipAction.backgroundColor = UIColor.init(red: 255/255, green: 139/255, blue: 23/255, alpha: 0.75)
        
        // Write action code for the More
        let RemindAction = UIContextualAction(style: .normal, title:  "Remind", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            self.data.remindChores(mcvc: self, taskName: taskName)
        })
        RemindAction.backgroundColor = UIColor.init(red: 255/255, green: 211/255, blue: 0/255, alpha: 0.85)
        
        let FinishAction = UIContextualAction(style: .normal, title:  "Finish", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            self.data.finishChores(mcvc: self, taskName: taskName, index: index)
            self.createAlert(title: "Finish success!", message: "Successfully finish the task")
            success(true)
        })
        FinishAction.backgroundColor =  UIColor.init(red: 101/255, green: 154/255, blue: 65/255, alpha: 0.75)
        
        return UISwipeActionsConfiguration(actions: [DeleteAction,SkipAction,RemindAction,FinishAction])
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chores.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = choresList.dequeueReusableCell(withIdentifier: "cell") as! MyChoresTableViewCell
        let Chore = self.chores[indexPath.row]
        cell.setChore(chore: Chore)
        cell.taskNameLabel.adjustsFontSizeToFitWidth = true
        cell.frequencyLabel.adjustsFontSizeToFitWidth = true
        cell.lastDoneLabel.adjustsFontSizeToFitWidth = true
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let alertController = UIAlertController(title: "Edit chores", message: nil, preferredStyle: .alert)
        alertController.addTextField(configurationHandler: editTaskName)
        alertController.addTextField(configurationHandler: editLastDoneDate)
        alertController.addTextField(configurationHandler: editFrequency)
        row = indexPath.row
        
        let okAction = UIAlertAction(title: "Save", style: .default, handler: self.okHandler)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true)
    }
    
    func editTaskName(textField: UITextField!) {
        editTaskName = textField
        editTaskName?.placeholder = "Name"
    }
    func editLastDoneDate(textField: UITextField!) {
        editLastDoneDate = textField
        editLastDoneDate?.inputView = datePicker
        editLastDoneDate?.placeholder = "Last Done Date"
    }
    func editFrequency(textField: UITextField!) {
        editFrequency = textField
        editFrequency?.inputView = pickerView
        editFrequency?.placeholder = "Frequency"
    }
    
    func okHandler(alert: UIAlertAction) {
        if(editTaskName?.text == "" || editFrequency?.text == "" || editLastDoneDate?.text == ""){
            print("error")
        } else {
            //backend deal with data change here
            let taskName = self.chores[row].task
            self.data.editDeleteChores(taskName: taskName)
 
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd/yyyy"
            var dateObj = dateFormatter.date(from: editLastDoneDate?.text ?? "")
            
            if (editFrequency?.text == "Once a day" || editFrequency?.text == "Twice a day") {
                dateObj = dateObj?.addingTimeInterval(86400)
            } else if (editFrequency?.text == "Once a week") {
                dateObj = dateObj?.addingTimeInterval(604800)
            } else if (editFrequency?.text == "Twice a week") {
                dateObj = dateObj?.addingTimeInterval(302400)
            } else if (editFrequency?.text == "Once a month") {
                dateObj = dateObj?.addingTimeInterval(2592000)
            } else if (editFrequency?.text == "Twice a month") {
                dateObj = dateObj?.addingTimeInterval(1296000)
            }
            remindDate = dateFormatter.string(from: dateObj!)
            
            self.data.editAddChores(mcvc: self, remindDate: remindDate)
            
            //data change appear in frontend
            self.chores.remove(at: row)
            let _choreName = editTaskName?.text ?? ""
            let _lastDone = editLastDoneDate?.text ?? ""
            let _frequency = editFrequency?.text ?? ""
            let _remindDates = remindDate
            let _remindOrNot = false
            let newChore = Chore(task: _choreName, lastDone: _lastDone, timePeriod: _frequency, remindDate: _remindDates, remindOrNot: _remindOrNot)
            self.chores.append(newChore)
            choresList.reloadData()
        }
    }
    
    func createAlert(title:String, message:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {(action) in alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
        
    }
    

    
    func updateRemindDate(date: String, freq: String) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        if(freq == "Once a day" || freq == "Twice a day"){
            var dateObj = dateFormatter.date(from: date)
            dateObj = dateObj?.addingTimeInterval(86400)
            let remindDate = dateFormatter.string(from: dateObj!)
            return remindDate
        }
        else if(freq == "Once a week"){
            var dateObj = dateFormatter.date(from: date)
            dateObj = dateObj?.addingTimeInterval(604800)
            let remindDate = dateFormatter.string(from: dateObj!)
            return remindDate
        }
        else if(freq == "Twice a week"){
            var dateObj = dateFormatter.date(from: date)
            dateObj = dateObj?.addingTimeInterval(302400)
            let remindDate = dateFormatter.string(from: dateObj!)
            return remindDate
        }
        else if(freq == "Once a month"){
            var dateObj = dateFormatter.date(from: date)
            dateObj = dateObj?.addingTimeInterval(2592000)
            let remindDate = dateFormatter.string(from: dateObj!)
            return remindDate
        }
        else{
            var dateObj = dateFormatter.date(from: date)
            dateObj = dateObj?.addingTimeInterval(1296000)
            let remindDate = dateFormatter.string(from: dateObj!)
            return remindDate
        }
    }
    
    func doDatePicker(){
        self.datePicker = UIDatePicker(frame:CGRect(x: 0, y: self.view.frame.size.height - 220, width:self.view.frame.size.width, height: 216))
        self.datePicker?.backgroundColor = UIColor.white
        datePicker?.datePickerMode = .date
        doneClick()
    }
    
    
    @objc func doneClick() {

    }
    
    @objc func datePickerChanged() {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        if( NSDate.init().earlierDate(self.datePicker!.date) == self.datePicker!.date){
            self.RemindRechooseTextF?.text = "You have to choose a future date"
            self.RemindRechoosePastDate = true
        } else {
            self.remindDate = formatter.string(from: self.datePicker!.date)
            self.RemindRechooseTextF?.text = formatter.string(from: self.datePicker!.date)
            self.RemindRechoosePastDate = false
        }
    }
}
