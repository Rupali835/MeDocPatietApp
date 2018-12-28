//
//  PatientHomePageTableViewCell.swift
//  MedocPatient
//
//  Created by Prem Sahni on 08/12/18.
//  Copyright © 2018 Kanishka. All rights reserved.
//

import UIKit

class PatientHomePageCollectionViewCell: UICollectionViewCell {

    @IBOutlet var icon: UIImageView!
    @IBOutlet var title: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        Utilities.shared.shadow(object: [self])
        // Initialization code
    }


}
