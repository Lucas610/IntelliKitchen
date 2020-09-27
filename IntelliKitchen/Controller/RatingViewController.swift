//
//  RatingViewController.swift
//  intellik
//
//  Created by 江南 on 5/4/20.
//  Copyright © 2020 江南. All rights reserved.
//


import UIKit
import Cosmos
import TinyConstraints


class RatingViewController: UIViewController {

    @IBOutlet weak var submitbutton: UIButton!
    @IBOutlet weak var smallerView: UIView!
    
    let data: Db = Db()
    
    var ratingarray: [Int] = [3]
    var passid:String = ""
    var currentUid: String = ""
    var ratedlist:[String] = []
    var ratedornot:Bool = false
    var numofpeople:Int = 0;
    var ratingsum:Int = 0;
    
    
    override func viewDidLoad() {
         super.viewDidLoad()
         smallerView.layer.cornerRadius=10
         view.addSubview(smallerView)
         smallerView.addSubview(cosmosView)
         cosmosView.centerInSuperview()
         cosmosView.didTouchCosmos = {rating in
             self.ratingarray.append(Int(rating))
         }
        data.getRatingdb(rvc: self)
     }
    
    @IBAction func clickCancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func clickSubmit(_ sender: Any) {
        data.tapSubmit(submitbutton: submitbutton, rvc:self)
    }
    
    lazy var cosmosView: CosmosView = {
        var view = CosmosView()
        view.settings.filledImage = UIImage(named: "Icon awesome-star")?.withRenderingMode(.alwaysOriginal)
        view.settings.emptyImage = UIImage(named: "Icon awesome-star2")?.withRenderingMode(.alwaysOriginal)
        view.settings.starSize = 30
        view.settings.fillMode = .full
        
        return view
    }()
    
}
