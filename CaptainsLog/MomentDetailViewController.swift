//
//  MomentDetailViewController.swift
//  CaptainsLog
//
//  Created by Macallan on 10/1/16.
//  Copyright © 2016 macallanbrown. All rights reserved.
//

import UIKit

class MomentDetailViewController: UIViewController {
    @IBOutlet weak var details: UITextView!
    @IBOutlet weak var location: UITextField!
    
    @IBOutlet weak var happyButton: UIButton!
    @IBOutlet weak var funnyButton: UIButton!
    @IBOutlet weak var sadButton: UIButton!
    @IBOutlet weak var angryButton: UIButton!
    
    @IBOutlet weak var addDetailsButton: UIButton!
    @IBOutlet weak var updateMomentButton: UIButton!
    
    var momentIndex = Int()
    var moment = (details: String, location:String, date:Date, emoji:String)("","", Date(),"")
    var logManager = LogManager.sharedInstance
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        moment = logManager.getMomentAtIndex(index: momentIndex)
        setupWith(details: moment.details, location: moment.location, date: moment.date, emoji: moment.emoji)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupWith(details:String, location:String, date:Date, emoji:String) {
        self.details.text = details
        self.location.text = location
        //self.emojiTag.text = emoji
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yy"
        self.title = dateFormatter.string(from: date)
    }
    
    
    

}
