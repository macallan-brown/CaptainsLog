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
    
    var moments = [NSManagedObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.detailsTextView.setContentOffset(CGPoint.zero, animated: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Moment")

        do {
            let results = try managedContext.fetch(fetchRequest)
            moments = results as! [NSManagedObject]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: TableView Delegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return moments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.recentMemoryTableView.dequeueReusableCell(withIdentifier: "recentMemoryTableViewCell", for: indexPath) as! RecentMemoryTableViewCell
        
        let moment = moments[indexPath.row]
        cell.setupWith(details: moment.value(forKey: "details") as! String,
                       location: moment.value(forKey: "location") as! String,
                       date: moment.value(forKey: "date") as! Date,
                       emoji: moment.value(forKey: "emojiTag") as! String)
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Your recent memories: "
    }
    
    // MARK: Add to Log clicked
    @IBAction func addToLogTouched() {
        self.detailsTextView.text! = ""
        saveMoment(details: self.detailsTextView.text, location: "add location", date: Date(), emoji: "😂")
        self.recentMemoryTableView.reloadData()
    }
    
    func saveMoment(details:String, location:String, date:Date, emoji:String) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let entity =  NSEntityDescription.entity(forEntityName: "Moment",
                                                 in:managedContext)
        
        let moment = NSManagedObject(entity: entity!, insertInto: managedContext)
        moment.setValue(details, forKey: "details")
        moment.setValue(location, forKey: "location")
        moment.setValue(date, forKey: "date")
        moment.setValue(emoji, forKey: "emojiTag")
        
        do {
            try managedContext.save()
            moments.append(moment)
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    }


}

