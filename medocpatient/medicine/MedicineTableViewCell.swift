//
//  MedicineTableViewCell.swift
//  MedocPatient
//
//  Created by Prem Sahni on 10/12/18.
//  Copyright © 2018 Kanishka. All rights reserved.
//

import UIKit

class MedicineTableViewCell: UITableViewCell {

    @IBOutlet var cardview: Cardview!
    
    @IBOutlet var name: UILabel!
    @IBOutlet var type: UILabel!
    @IBOutlet var img_type: UIImageView!
    @IBOutlet var timeslot: UILabel!
    @IBOutlet var interval_time: UILabel!
    @IBOutlet var interval_type: UILabel!
    @IBOutlet var interval_period: UILabel!
    @IBOutlet var beforeaftertime: UILabel!
    
    @IBOutlet var start_date: UILabel!
    @IBOutlet var start_month: UILabel!
    @IBOutlet var start_year: UILabel!
    @IBOutlet var start_time: UILabel!
    
    @IBOutlet var to: UILabel!
    
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

    func currentMedicineColor(primarycolor: UIColor,secondarycolor: UIColor){
        name.textColor = primarycolor
        interval_type.textColor = primarycolor
        start_date.textColor = primarycolor
        start_month.textColor = primarycolor
        start_year.textColor = primarycolor
        end_date.textColor = primarycolor
        end_month.textColor = primarycolor
        end_year.textColor = primarycolor
        beforeaftertime.textColor = primarycolor
        
        type.textColor = secondarycolor
        timeslot.textColor = secondarycolor
        interval_period.textColor = secondarycolor
        interval_time.textColor = secondarycolor
    }
    func non_currentMedicineColor(primarycolor: UIColor,secondarycolor: UIColor){
        name.textColor = primarycolor
        interval_type.textColor = primarycolor
        start_date.textColor = primarycolor
        start_month.textColor = primarycolor
        start_year.textColor = primarycolor
        end_date.textColor = primarycolor
        end_month.textColor = primarycolor
        end_year.textColor = primarycolor
        beforeaftertime.textColor = primarycolor
        
        type.textColor = secondarycolor
        timeslot.textColor = secondarycolor
        interval_period.textColor = secondarycolor
        interval_time.textColor = secondarycolor
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
