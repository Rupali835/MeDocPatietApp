//
//  PatientTableViewCell.swift
//  MedocPatient
//
//  Created by iAM on 17/12/18.
//  Copyright © 2018 Kanishka. All rights reserved.
//

import UIKit

class PatientTableViewCell: UITableViewCell {

    @IBOutlet var collectionview: UICollectionView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        collectionview.reloadData()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
