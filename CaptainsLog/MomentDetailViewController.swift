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
    var emojiButtonSelected: UIButton? = nil
    var logManager = LogManager.sharedInstance
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        moment = logManager.getMomentAtIndex(index: momentIndex)
        setupWith(details: moment.details, location: moment.location, date: moment.date, emoji: moment.emoji)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Delete", style: .plain, target: self, action: #selector(deleteTapped))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupWith(details:String, location:String, date:Date, emoji:String) {
        self.details.text = details
        self.location.text = location
        if let emojiButton = getButtonFromEmoji(emoji: emoji) {
            emojiButton.isSelected = true
            self.emojiButtonSelected = emojiButton
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yy"
        self.title = dateFormatter.string(from: date)
    }
    
    @IBAction func updateMomentButtonTouched(_ sender: AnyObject) {
        logManager.updateMoment(index: momentIndex,
                                details:self.details.text!,
                                location:self.location.text!,
                                emoji:getSelectedEmoji())
    }
    
    
    @IBAction func emojiButtonTouched(_ sender: UIButton) {
        if emojiButtonSelected != nil  {
            emojiButtonSelected?.isSelected = false;
            emojiButtonSelected = nil
        }
        
        if(sender.isSelected) {
            sender.isSelected = false;
            emojiButtonSelected = nil
        } else {
            sender.isSelected = true;
            emojiButtonSelected = sender
        }
    }
    
    private func getSelectedEmoji() -> String {
        if (emojiButtonSelected != nil) {
            switch emojiButtonSelected! {
            case self.happyButton:
                return "😀"
            case self.funnyButton:
                return "😂"
            case self.sadButton:
                return "😢"
            case self.angryButton:
                return "😠"
            default:
                return ""
            }
        }
        return ""
    }
    
    private func getButtonFromEmoji(emoji:String) -> UIButton? {
            switch emoji{
            case "😀":
                return self.happyButton
            case "😂":
                return self.funnyButton
            case "😢":
                return self.sadButton
            case "😠":
                return self.angryButton
            default:
                return nil
            }
    }
    
    func deleteTapped(){
        let deleteAlert = UIAlertController(title: "Delete moment?", message: "All data will be lost.", preferredStyle: UIAlertControllerStyle.alert)
        
        deleteAlert.addAction(UIAlertAction(title: "Delete", style: .default, handler: { (action: UIAlertAction!) in
            self.logManager.removeMoment(index: self.momentIndex)
            _ = self.navigationController?.popViewController(animated: true)
        }))
        
        deleteAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
        }))
        
        present(deleteAlert, animated: true, completion: nil)
    }
    
    
    

}
