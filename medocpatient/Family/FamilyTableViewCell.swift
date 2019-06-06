//
//  FamilyTableViewCell.swift
//  medocpatient
//
//  Created by Nishikant Ashok UMBARKAR on 5/6/19.
//  Copyright © 2019 kspl. All rights reserved.
//

import UIKit

class FamilyTableViewCell: UITableViewCell {

    @IBOutlet var lbl_name: UILabel!
    @IBOutlet var lbl_relationship: UILabel!
    @IBOutlet var lbl_cheif_complain: UILabel!
    @IBOutlet var lbl_hospital_name: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
