//
//  JobListingTableViewCell.swift
//  AssistMe
//
//  Created by Charles Gong on 11/8/16.
//  Copyright © 2016 Group10. All rights reserved.
//

import UIKit

class JobListingTableViewCell: UITableViewCell {
    @IBOutlet weak var profilePicImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var jobTitleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
