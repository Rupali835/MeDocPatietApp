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
    @IBOutlet var type: UILabel!
    @IBOutlet var timeslot: UILabel!
    @IBOutlet var interval_time: UILabel!
    @IBOutlet var interval_type: UILabel!
    @IBOutlet var interval_period: UILabel!
    @IBOutlet var beforeaftertime: UILabel!
    
    @IBOutlet var start_date: UILabel!
    @IBOutlet var start_month: UILabel!
    @IBOutlet var start_year: UILabel!
    @IBOutlet var start_time: UILabel!
    
    @IBOutlet var end_date: UILabel!
    @IBOutlet var end_month: UILabel!
    @IBOutlet var end_year: UILabel!
    @IBOutlet var end_time: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
class headercell: UITableViewCell {
    
    @IBOutlet var titles: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
