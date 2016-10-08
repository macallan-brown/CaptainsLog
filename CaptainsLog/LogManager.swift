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
    
    func countMoments() -> Int {
        return moments.count
    }
    
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
            loadMoments()
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    func updateMoment(index: Int, details:String, location:String, emoji:String) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
        moments[index].setValue(details, forKey: "details")
        moments[index].setValue(location, forKey: "location")
        moments[index].setValue(emoji, forKey: "emojiTag")
        
        appDelegate.saveContext()
    }
    
    func removeMoment(index: Int) {
        do {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let managedContext = appDelegate.persistentContainer.viewContext
            managedContext.delete(moments[index] as NSManagedObject)
            moments.remove(at: index)
            try managedContext.save()
        } catch let error as NSError {
            print("Could not delete \(error), \(error.userInfo)")
        }
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
        let sectionSortDescriptor = NSSortDescriptor(key: "date", ascending: false)
        let sortDescriptors = [sectionSortDescriptor]
        fetchRequest.sortDescriptors = sortDescriptors
        
        do {
            let results = try managedContext.fetch(fetchRequest)
            moments = results as! [NSManagedObject]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    
    func loadMomentsEmoji(emoji:String) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Moment")
        let sectionSortDescriptor = NSSortDescriptor(key: "date", ascending: false)
        let sortDescriptors = [sectionSortDescriptor]
        fetchRequest.predicate = NSPredicate(format: "%K CONTAINS[cd] %@", "emojiTag", emoji)
        fetchRequest.sortDescriptors = sortDescriptors
        
        do {
            let results = try managedContext.fetch(fetchRequest)
            moments = results as! [NSManagedObject]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    
    func loadMomentsSearch(text:String) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Moment")
        let sectionSortDescriptor = NSSortDescriptor(key: "date", ascending: false)
        let sortDescriptors = [sectionSortDescriptor]
        fetchRequest.predicate = NSPredicate(format: "%K CONTAINS[cd] %@", "details", text)
        fetchRequest.sortDescriptors = sortDescriptors
        
        do {
            let results = try managedContext.fetch(fetchRequest)
            moments = results as! [NSManagedObject]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    
    func writeCoreDataObjectToCSV(named: String) -> String {
        /* We assume that all objects are of the same type */
        guard moments.count > 0 else {
            return ""
        }
        let firstObject = moments[0]
        let attribs = Array(firstObject.entity.attributesByName.keys)
        let csvHeaderString = (attribs.reduce("",{($0 as String) + "," + $1 as NSString })).substring(from: 1) + "\n"
        
        let csvArray = moments.map({object in
            (attribs.map({((object.value(forKey: $0) ?? "") as AnyObject).description}).reduce("",{
                $0 + "," + ($1?.replacingOccurrences(of: ",", with: "-"))!
            }) as NSString).substring(from: 1) + "\n"
        })
        let csvString = csvArray.reduce("", +)
        
        return csvHeaderString+csvString
    }
    
    
}
