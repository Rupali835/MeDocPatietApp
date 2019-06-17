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
       // Utilities.shared.shadow(object: [self])
        self.layer.cornerRadius = 5.0
        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.layer.shadowRadius = 2.0
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        // Initialization code
    }

}
