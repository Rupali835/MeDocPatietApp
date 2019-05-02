//
//  HealthListTableViewCell.swift
//  medocpatient
//
//  Created by iAM on 09/01/19.
//  Copyright © 2019 kspl. All rights reserved.
//

import UIKit

protocol HealthListTableViewCelldelegate : class{
    func indexpath(cell: HealthListTableViewCell)
}
class HealthListTableViewCell: UITableViewCell {

    @IBOutlet var title: UILabel!
    @IBOutlet var add: UIButton!
    weak var delegate: HealthListTableViewCelldelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        add.addTarget(self, action: #selector(addaction), for: .touchUpInside)
    }
    @objc func addaction(){
        delegate?.indexpath(cell: self)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
