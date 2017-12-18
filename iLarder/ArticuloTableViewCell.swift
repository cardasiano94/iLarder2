//
//  ArticuloTableViewCell.swift
//  iLarder
//
//  Created by Cristobal Galleguillos on 06-12-17.
//  Copyright © 2017 URSis. All rights reserved.
//

import UIKit

class ArticuloTableViewCell: UITableViewCell {
    //MARK: Properties

    @IBOutlet weak var ArticleName: UILabel!
    @IBOutlet weak var ArticleQuantity: UILabel!
    
    @IBOutlet weak var addArticle: UIButton!
    @IBOutlet weak var StatusIcon: UIImageView!
    
    override func awakeFromNib() { 
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
