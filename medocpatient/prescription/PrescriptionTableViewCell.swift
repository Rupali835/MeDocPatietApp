//
//  PrescriptionTableViewCell.swift
//  MedocPatient
//
//  Created by iAM on 17/12/18.
//  Copyright © 2018 Kanishka. All rights reserved.
//

import UIKit

class PrescriptionTableViewCell: UITableViewCell {

    @IBOutlet var patient_problem: UILabel!
    @IBOutlet var prescription_pdf : UIImageView!
    @IBOutlet var date: UILabel!
    @IBOutlet var month: UILabel!
    @IBOutlet var year: UILabel!
    @IBOutlet var time: UILabel!
    @IBOutlet var addedby: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        Utilities.shared.cornerRadius(objects: [prescription_pdf], number: 10)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
