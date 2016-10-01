//
//  RecentMemoryTableViewCell.swift
//  CaptainsLog
//
//  Created by Macallan on 10/1/16.
//  Copyright © 2016 macallanbrown. All rights reserved.
//

import UIKit

class RecentMemoryTableViewCell: UITableViewCell {

    @IBOutlet weak var details: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var emojiTag: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupWith(details:String, location:String, date:Date, emoji:String) {
        self.details.text = details
        self.location.text = location
        self.emojiTag.text = emoji
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yy"
        self.date.text = dateFormatter.string(from: date)
    }

}
