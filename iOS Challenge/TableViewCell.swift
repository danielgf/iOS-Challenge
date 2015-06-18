//
//  TableViewCell.swift
//  iOS Challenge
//
//  Created by Daniel Griso Filho on 6/17/15.
//  Copyright (c) 2015 iOS Daniel. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
   
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var authorLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var imageShow: UIImageView!
    @IBOutlet var activitiShow: UIActivityIndicatorView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        
        
    }

}
