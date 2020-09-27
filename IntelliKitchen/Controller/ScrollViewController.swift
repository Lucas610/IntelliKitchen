//
//  ScrollViewController.swift
//  intellik
//
//  Created by 江南 on 5/5/20.
//  Copyright © 2020 江南. All rights reserved.
//

import UIKit


class ScrollViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var scrollview: UIScrollView!
    @IBOutlet weak var stepsdisplay: UILabel!
    @IBOutlet weak var innerscroll: UIScrollView!
    
    //rating
    @IBOutlet weak var ratinglabel: UILabel!
    
    // title of the menu
    @IBOutlet weak var menutitle: UILabel!
    
    // ingredients container
    @IBOutlet weak var ingrescroll: UIScrollView!
    @IBOutlet weak var lefthalf: UILabel!
    @IBOutlet weak var righthalf: UILabel!
    
    // menu picture
    @IBOutlet weak var menupic: UIImageView!
    @IBOutlet weak var commentstableview: UITableView!
    @IBOutlet weak var submitdisplay: UIButton!
    @IBOutlet weak var Comments: UITextField!
    
    //favourite button
    @IBOutlet weak var FavouriteButton: UIButton!
    
    //let db = Firestore.firestore()
    var currentUid: String = ""
    // varaibles for steps for the first recipe
    var passid = ""
    var mylist:[String] = []
    
    //favourite
    var favlist: [String] = []
    var favornot: Bool = false;
    var wholelist: String = "";
    
    var ingredientlist:[String] = [];
    var leftstring: String = "";
    var rightstring: String = "";
    var imageurl:URL!;
    
    // test comments
    //var ref = Database.database().reference().child("commentstest1")
    var username:String = ""
    var commentlist: [[String]] = [[]];
    var commentcelllist: [Comment] = [];
    
    var commentedlist: [String] = []
    var commentornot: Bool = false;
    
    // test ratings
    var ratingarray = [Double]()
    
    var infoUsername:[String:String] = [:]
    var infoPhoto:[String:Data] = [:]
    var tempname:[String] = []
    
    let data:Db = Db()

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Comments.delegate = self
        stepsdisplay.sizeToFit();
        data.scrollViewDidLoadHelper(svc:self)
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(touch))
         recognizer.numberOfTapsRequired = 1
         recognizer.numberOfTouchesRequired = 1
         scrollview.addGestureRecognizer(recognizer)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillChange(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillChange(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    @IBAction func clickRating(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle:nil)
        let secondVC = storyboard.instantiateViewController(identifier: "Rating") as! RatingViewController
        secondVC.passid = self.passid
        self.present(secondVC, animated: true, completion: nil)
    }
    
    @IBAction func SubmitButton(_ sender: Any) {
        data.submitButtonHelper(submitdisplay: submitdisplay, svc: self)
    }
    
    
    @IBAction func ClickFavouriteButton(_ sender: Any) {
        data.clickFavouriteButtonHelper(FavouriteButton:FavouriteButton, svc:self)

    }
    
    @IBAction func backbutton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let nextstage = segue.destination as! RatingViewController
        nextstage.passid = self.passid
    }
        
    override func viewWillAppear(_ animated: Bool) {
        data.viewWillAppearHelper(svc:self)
    }
    
    
     @objc func keyboardWillChange(notification: Notification) {
        if self.view.frame.origin.y == 0 {
            self.view.frame.origin.y -= 300
        } else {
           self.view.frame.origin.y = 0
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    

}



