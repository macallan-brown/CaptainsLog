//
//  SettingsViewController.swift
//  CaptainsLog
//
//  Created by Macallan on 10/8/16.
//  Copyright © 2016 macallanbrown. All rights reserved.
//

import UIKit
import MessageUI

class SettingsViewController: UIViewController, MFMailComposeViewControllerDelegate {

    let logManager = LogManager.sharedInstance
    var mailVC = MFMailComposeViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
        mailVC.setSubject("Subject for email")
        mailVC.setMessageBody("Email message string", isHTML: false)
        mailVC.addAttachmentData(data!,
                                   mimeType: "text/csv",
                                   fileName: "mydata.csv")
        
        present(mailVC, animated: true, completion: nil)
    }
    
    // MARK: MailComposeViewControllerDelegate
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        mailVC.dismiss(animated: true, completion: nil)
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
