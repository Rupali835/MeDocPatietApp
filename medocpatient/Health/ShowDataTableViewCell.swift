//
//  ShowDataTableViewCell.swift
//  medocpatient
//
//  Created by iAM on 16/01/19.
//  Copyright © 2019 kspl. All rights reserved.
//

import UIKit

class ShowDataTableViewCell: UITableViewCell {

    @IBOutlet var value: UILabel!
    @IBOutlet var date: UILabel!
    @IBOutlet var month: UILabel!
    @IBOutlet var year: UILabel!
    @IBOutlet var time: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
