//
//  ViewController.swift
//  CaptainsLog
//
//  Created by Macallan on 9/22/16.
//  Copyright © 2016 macallanbrown. All rights reserved.
//

import UIKit
import CoreData

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var recentMemoryTableView: UITableView!
    
    @IBOutlet weak var detailsTextView: UITextView!
    
    @IBOutlet weak var happyButton: UIButton!
    @IBOutlet weak var funnyButton: UIButton!
    @IBOutlet weak var sadButton: UIButton!
    @IBOutlet weak var angryButton: UIButton!
    @IBOutlet weak var addDetailsButton: UIButton!
    
    let logManager = LogManager.sharedInstance
    var emojiButtonSelected: UIButton? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.logManager.loadMoments()
        recentMemoryTableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: TableView Delegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.logManager.countMoments()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.recentMemoryTableView.dequeueReusableCell(withIdentifier: "recentMemoryTableViewCell", for: indexPath) as! RecentMemoryTableViewCell
        let moment = self.logManager.getMomentAtIndex(index: indexPath.row)
        cell.setupWith(details: moment.details, location: moment.location, date: moment.date, emoji: moment.emoji)
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Your recent memories: "
    }
    
    // MARK: Add to Log clicked
    
    @IBAction func addToLogTouched() {
        view.endEditing(true)
        logManager.addMoment(details: self.detailsTextView.text,
                             location: "",
                             date: Date(),
                             emoji: getSelectedEmoji())
        self.recentMemoryTableView.reloadData()
        self.detailsTextView.text! = ""
        emojiButtonSelected?.isSelected = false
        emojiButtonSelected = nil
    }
    
    @IBAction func addDetailsButtonTouched(_ sender: UIButton) {
        if(sender.isSelected) {
            sender.isSelected = false;
        } else {
            sender.isSelected = true;
        }
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
    
    // MARK: Prepare for Log
    
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
    
    // MARK: Segue Methods
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "showMomentDetailSegue") {
            let momentDetailViewController = segue.destination as! MomentDetailViewController
            
            let momentIndex = self.recentMemoryTableView.indexPathForSelectedRow?.row
            momentDetailViewController.momentIndex = momentIndex!
        }
    }

}

