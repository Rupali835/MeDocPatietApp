//
//  MedicineTableViewCell.swift
//  MedocPatient
//
//  Created by Prem Sahni on 10/12/18.
//  Copyright © 2018 Kanishka. All rights reserved.
//

import UIKit

class MedicineTableViewCell: UITableViewCell {

    @IBOutlet var name: UILabel!
    @IBOutlet var timeslot: UILabel!
    @IBOutlet var repeattimeslot: UILabel!
    @IBOutlet var quantity: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
