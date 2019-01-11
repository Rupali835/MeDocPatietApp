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
    @IBOutlet var drawing_image : UIImage!
    @IBOutlet var handwritten_image : UIImage!
    @IBOutlet var blood_pressure : UILabel!
    @IBOutlet var height : UILabel!
    @IBOutlet var other_details : UILabel!
    @IBOutlet var prescription_details : UILabel!
    @IBOutlet var signature_image : UIImage!
    @IBOutlet var prescription_pdf : UIImage!
    @IBOutlet var weight : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
