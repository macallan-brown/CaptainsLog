//
//  LogManager.swift
//  CaptainsLog
//
//  Created by Macallan on 10/1/16.
//  Copyright © 2016 macallanbrown. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class LogManager {
    class var sharedInstance: LogManager {
        struct Singleton {
            static let instance = LogManager()
        }
        return Singleton.instance
    }
    
    var moments = [NSManagedObject]()
    
    func addMoment(details:String, location:String, date:Date, emoji:String) {
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
    
    func countMoments() -> Int {
        return moments.count
    }
    
    func removeMoment() {
        
    }
    
    func getMomentAtIndex(index: Int) -> (details: String, location:String, date:Date, emoji:String) {
        let moment = moments[index]
        let details = moment.value(forKey: "details") as! String
        let location = moment.value(forKey: "location") as! String
        let date = moment.value(forKey: "date") as! Date
        let emoji = moment.value(forKey: "emojiTag") as! String
        return (details, location, date, emoji)
    }
    
    func loadMoments() {
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
}
