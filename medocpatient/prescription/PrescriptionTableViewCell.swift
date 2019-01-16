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
    @IBOutlet var date : UILabel!
    @IBOutlet var drawing_image : UIImageView!
    @IBOutlet var handwritten_image : UIImageView!
    @IBOutlet var blood_pressure : UILabel!
    @IBOutlet var height : UILabel!
    @IBOutlet var other_details : UILabel!
    @IBOutlet var prescription_details : UILabel!
    @IBOutlet var signature_image : UIImageView!
    @IBOutlet var prescription_pdf : UIImageView!
    @IBOutlet var weight : UILabel!
    @IBOutlet var temperature : UILabel!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        Utilities.shared.cornerRadius(objects: [signature_image], number: 10)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
