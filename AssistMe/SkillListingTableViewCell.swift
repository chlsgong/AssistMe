//
//  SkillListingTableViewCell.swift
//  AssistMe
//
//  Created by Bhavish on 11/8/16.
//  Copyright © 2016 Group10. All rights reserved.
//

import UIKit

class SkillListingTableViewCell: UITableViewCell {

    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var skillOne: UILabel!
    @IBOutlet weak var skillTwo: UILabel!
    @IBOutlet weak var skillThree: UILabel!
    @IBOutlet weak var skillFour: UILabel!
    @IBOutlet weak var date: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
