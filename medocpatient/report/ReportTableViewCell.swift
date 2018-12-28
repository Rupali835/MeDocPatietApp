//
//  ReportTableViewCell.swift
//  MedocPatient
//
//  Created by iAM on 17/12/18.
//  Copyright © 2018 Kanishka. All rights reserved.
//

import UIKit

class ReportTableViewCell: UITableViewCell {

    @IBOutlet var images: UIImageView!
    @IBOutlet var pre: UILabel!
    @IBOutlet var remark: UILabel!
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
