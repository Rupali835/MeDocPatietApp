//
//  LatestDataTableViewCell.swift
//  medocpatient
//
//  Created by iAM on 16/01/19.
//  Copyright © 2019 kspl. All rights reserved.
//

import UIKit

class LatestDataTableViewCell: UITableViewCell {
    
    @IBOutlet var firstdata: UILabel!
    @IBOutlet var seconddata: UILabel!
    @IBOutlet var date: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
