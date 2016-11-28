//
//  JobRequestTableViewCell.swift
//  AssistMe
//
//  Created by Charles Gong on 11/21/16.
//  Copyright © 2016 Group10. All rights reserved.
//

import UIKit

class JobRequestTableViewCell: UITableViewCell {
    @IBOutlet weak var jobTitleLabel: UILabel!
    @IBOutlet weak var displayNameLabel: UILabel!
    @IBOutlet weak var requestDateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
