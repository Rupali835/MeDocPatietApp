//
//  SelectionTableViewCell.swift
//  medocpatient
//
//  Created by Nishikant Ashok UMBARKAR on 16/4/19.
//  Copyright © 2019 kspl. All rights reserved.
//

import UIKit

class SelectionTableViewCell: UITableViewCell {

    @IBOutlet var name: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
