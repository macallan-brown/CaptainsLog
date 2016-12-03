//
//  SettingsViewController.swift
//  CaptainsLog
//
//  Created by Macallan on 10/8/16.
//  Copyright © 2016 macallanbrown. All rights reserved.
//

import UIKit
import MessageUI
import UserNotifications

class SettingsViewController: UIViewController, MFMailComposeViewControllerDelegate {

    let logManager = LogManager.sharedInstance
    var mailVC = MFMailComposeViewController()
    
    @IBOutlet weak var csvEmailButton: UIButton!
    @IBOutlet weak var notificationDatePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        csvEmailButton.layer.borderWidth = 2.0
        let myColor : UIColor = UIColor( red: 1.0, green: 1.0, blue:1.0, alpha: 1.0 )
        csvEmailButton.layer.borderColor = myColor.cgColor
        csvEmailButton.layer.cornerRadius = 10.0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func emailMomentsButtonTouched(_ sender: UIButton) {
        
        let csvString = logManager.writeCoreDataObjectToCSV(named: "moment")
        let data = csvString.data(using: String.Encoding.utf8)
        
        mailVC = MFMailComposeViewController()
        mailVC.mailComposeDelegate = self
        mailVC.setToRecipients([])
        mailVC.setSubject("Your Moments from Captains Log")
        mailVC.setMessageBody("Attached is a CSV file with your moments. All commas in your data have been replaced with '-' to create the file.", isHTML: false)
        mailVC.addAttachmentData(data!,
                                   mimeType: "text/csv",
                                   fileName: "CaptainsLogData.csv")
        
        present(mailVC, animated: true, completion: nil)
    }
    
    @IBAction func notificationSwitchChanged(_ sender: UISwitch) {
        if(sender.isOn){
            scheduleLocalNotification()
        } else {
            cancelLocalNotification()
        }
    }
    
    // MARK: MailComposeViewControllerDelegate
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        mailVC.dismiss(animated: true, completion: nil)
    }
    
    func scheduleLocalNotification() {
        let center = UNUserNotificationCenter.current()
        
        let content = UNMutableNotificationContent()
        content.title = "Ahoy Matey"
        content.body = "Don't forget your favorite moment of the day! Record it in your log."
        content.categoryIdentifier = "alarm"
        content.sound = UNNotificationSound.default()
        
        var dateComponents = DateComponents()
        let calendar = NSCalendar.current
        var compos = calendar.dateComponents(in: calendar.timeZone, from: notificationDatePicker.date)

        dateComponents.hour = compos.hour
        dateComponents.minute = compos.minute
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        center.add(request)
    }
    
    func cancelLocalNotification() {
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
