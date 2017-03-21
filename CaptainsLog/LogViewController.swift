//
//  LogViewController.swift
//  CaptainsLog
//
//  Created by Macallan on 10/2/16.
//  Copyright © 2016 macallanbrown. All rights reserved.
//

import UIKit

class LogViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var happyButton: UIButton!
    @IBOutlet weak var funnyButton: UIButton!
    @IBOutlet weak var sadButton: UIButton!
    @IBOutlet weak var angryButton: UIButton!
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var momentsTableView: UITableView!
    var emojiButtonSelected:UIButton? = nil
    
    let logManager = LogManager.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        momentsTableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func emojiButtonTouched(_ sender: UIButton) {
        searchTextField.text = ""
        
        if (sender == emojiButtonSelected) {
            sender.isSelected = false
            emojiButtonSelected = nil
            logManager.loadMoments()
        } else if (emojiButtonSelected != nil) {
            emojiButtonSelected?.isSelected = false
            sender.isSelected = true
            emojiButtonSelected = sender
            logManager.loadMomentsEmoji(emoji: getSelectedEmoji())
        } else {
            sender.isSelected = true;
            emojiButtonSelected = sender
            logManager.loadMomentsEmoji(emoji: getSelectedEmoji())
        }
        
        
        momentsTableView.reloadData()
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
    
    @IBAction func searchTextChanged(_ sender: UITextField) {
        emojiButtonSelected?.isSelected = false
        emojiButtonSelected = nil
        
        if (sender.text! != "") {
            logManager.loadMomentsSearch(text: sender.text!)
        } else {
            logManager.loadMoments()
        }
        momentsTableView.reloadData()
    }
    
    // MARK: TableView Delegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.logManager.countMoments()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.momentsTableView.dequeueReusableCell(withIdentifier: "momentsTableViewCell", for: indexPath) as! RecentMemoryTableViewCell
        let moment = self.logManager.getMomentAtIndex(index: indexPath.row)
        cell.setupWith(details: moment.details, location: moment.location, date: moment.date, emoji: moment.emoji)
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Moments: "
    }

    // MARK: Segue Methods
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "showMomentDetailSegue") {
            let momentDetailViewController = segue.destination as! MomentDetailViewController
            
            let momentIndex = self.momentsTableView.indexPathForSelectedRow?.row
            momentDetailViewController.momentIndex = momentIndex!
        }
    }

    @IBAction func swipeRight(_ sender: UISwipeGestureRecognizer) {
       _ = self.navigationController?.popViewController(animated: true)
    }
}
