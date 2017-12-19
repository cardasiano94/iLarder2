//
//  LogTableViewCell.swift
//  iLarder
//
//  Created by Cristobal Galleguillos on 18-12-17.
//  Copyright © 2017 URSis. All rights reserved.
//

import UIKit

class LogTableViewCell: UITableViewCell {

    @IBOutlet weak var addedUnits: UILabel!
    @IBOutlet weak var existingUnits: UILabel!
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
