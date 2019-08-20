//
//  File.swift
//  medocpatient
//
//  Created by Nishikant Ashok UMBARKAR on 30/7/19.
//  Copyright © 2019 kspl. All rights reserved.
//

import UIKit

class addmedicinecell: UITableViewCell {
    
    @IBOutlet var cardview: Cardview!
    
    @IBOutlet var name: UILabel!
    @IBOutlet var type: UILabel!
    @IBOutlet var timeslot: UILabel!
    @IBOutlet var interval_time: UILabel!
    @IBOutlet var interval_type: UILabel!
    @IBOutlet var interval_period: UILabel!
    @IBOutlet var beforeaftertime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    func SetCellData(d: NSDictionary,indexPath: IndexPath){
        var timeslot = [String]()
        
        timeslot.removeAll()
        
        let name = d.value(forKey: "medicine_name") as! String
        let medicine_type = d.value(forKey: "medicine_type") as! String
        let medicine_quantity = d.value(forKey: "medicine_quantity") as! String
        
        let before_bf = "\(d.value(forKey: "before_bf") as! Int)"
        let before_bf_time = "\(d.value(forKey: "before_bf_time") as! Int)"
        if before_bf == "1"{
            if !timeslot.contains("Before \(before_bf_time) minute Of Breakfast"){
                if before_bf_time == "0" {
                    timeslot.append("Before Breakfast")
                } else {
                    timeslot.append("Before \(before_bf_time) minute Of Breakfast")
                }
            }
        }
        
        let after_bf = "\(d.value(forKey: "after_bf") as! Int)"
        let after_bf_time = "\(d.value(forKey: "after_bf_time") as! Int)"
        if after_bf == "1"{
            if !timeslot.contains("After \(after_bf_time) minute Of Breakfast"){
                if after_bf_time == "0" {
                    timeslot.append("After Breakfast")
                } else {
                    timeslot.append("After \(after_bf_time) minute Of Breakfast")
                }
            }
        }
        
        let before_lunch = "\(d.value(forKey: "before_lunch") as! Int)"
        let before_lunch_time = "\(d.value(forKey: "before_lunch_time") as! Int)"
        if before_lunch == "1"{
            if !timeslot.contains("Before \(before_lunch_time) minute Of Lunch"){
                if before_lunch_time == "0" {
                    timeslot.append("Before  Lunch")
                } else {
                    timeslot.append("Before \(before_lunch_time) minute Of Lunch")
                }
            }
        }
        
        let after_lunch = "\(d.value(forKey: "after_lunch") as! Int)"
        let after_lunch_time = "\(d.value(forKey: "after_lunch_time") as! Int)"
        if after_lunch == "1"{
            if !timeslot.contains("After \(after_lunch_time) minute Of Lunch"){
                if after_lunch_time == "0" {
                    timeslot.append("After Lunch")
                } else {
                    timeslot.append("After \(after_lunch_time) minute Of Lunch")
                }
            }
        }
        
        let before_dinner = "\(d.value(forKey: "before_dinner") as! Int)"
        let before_dinner_time = "\(d.value(forKey: "before_dinner_time") as! Int)"
        if before_dinner == "1"{
            if !timeslot.contains("Before \(before_dinner_time) minute Of Dinner"){
                if before_dinner_time == "0" {
                    timeslot.append("Before Dinner")
                } else {
                    timeslot.append("Before \(before_dinner_time) minute Of Dinner")
                }
            }
        }
        
        let after_dinner = "\(d.value(forKey: "after_dinner") as! Int)"
        let after_dinner_time = "\(d.value(forKey: "after_dinner_time") as! Int)"
        if after_dinner == "1"{
            if !timeslot.contains("After \(after_dinner_time) minute Of Dinner"){
                if after_dinner_time == "0" {
                    timeslot.append("After Dinner")
                } else {
                    timeslot.append("After \(after_dinner_time) minute Of Dinner")
                }
            }
        }
        
        let interval_period = "\(d.value(forKey: "interval_period") as! Int)"
        let interval_time = d.value(forKey: "interval_time") as! String
        let interval_type = "\(d.value(forKey: "interval_type") as! Int)"
        
        switch interval_type {
        case "1":
            self.interval_type.text = "Daily - (Quantity: \(medicine_quantity))"
            self.interval_period.text = "Period: \(interval_period) days"
            self.interval_time.text = "";
        case "2":
            self.interval_type.text = "Weekly - (Quantity: \(medicine_quantity))"
            self.interval_period.text = "Period: \(interval_period) weeks"
            self.interval_time.text = "Times: \(interval_time) times in a week";
        case "3":
            self.interval_type.text = "Time interval - (Quantity: \(medicine_quantity))"
            self.interval_period.text = "Period: \(interval_period) days"
            let times = (8...24).count / Int(interval_time)!
            self.interval_time.text = "Times: \(times) times in a day";
        default:
            self.interval_type.text = ""
            self.interval_period.text = ""
            self.interval_time.text = ""
        }
        self.name.text = name
        self.type.text = medicine_type
        
        var breakfast = Int()
        var lunch = Int()
        var dinner = Int()
        
        breakfast = Int(before_bf)! + Int(after_bf)!
        lunch = Int(before_lunch)! + Int(after_lunch)!
        dinner = Int(before_dinner)! + Int(after_dinner)!
        
        if breakfast == 2{
            breakfast = 1
        }
        if lunch == 2{
            lunch = 1
        }
        if dinner == 2{
            dinner = 1
        }
        
        if breakfast == 0 && lunch == 0 && dinner == 0 {
            self.timeslot.text = ""
            self.beforeaftertime.text = ""
        } else {
            if interval_type == "3" {
                self.timeslot.text = ""
                var time = [String]()
                for (index,hour) in (8...24).enumerated() {
                    let int_time = interval_time == "" ? 0 : Int(interval_time)!
                    if index % int_time == 0{
                        if hour > 12 {
                            let h = "\(hour - 12) PM"
                            time.append(h)
                        } else {
                            let h = "\(hour) AM"
                            time.append(h)
                        }
                    }
                }
                self.beforeaftertime.text = time.joined(separator: " , ")
            } else {
                self.timeslot.text = "\(breakfast)-\(lunch)-\(dinner)"
                self.beforeaftertime.text = "# \(timeslot.joined(separator: "\n# "))"
            }
        }
        
    }
}
