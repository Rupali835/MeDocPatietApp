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
    
    @IBOutlet var lastmedicinetakentime : UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        name.text = ""
        type.text = ""
        timeslot.text = ""
        interval_time.text = ""
        interval_type.text = ""
        interval_period.text = ""
        beforeaftertime.text = ""
        
        start_date.text = ""
        start_month.text = ""
        start_year.text = ""
      //  start_time.text = ""
        
        end_date.text = ""
        end_month.text = ""
        end_year.text = ""
      //  end_time.text = ""
        
        lastmedicinetakentime.text = ""
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func SetCellData(data: NSDictionary,images_types: [UIImage?],indexPath: IndexPath){
        
        let id = data.value(forKey: "id") as? Int ?? 0
        let created_by = data.value(forKey: "created_by") as? Int

        let name = data.value(forKey: "medicine_name") as! String
        let medicine_type = data.value(forKey: "medicine_type") as! String
        let medicine_quantity = data.value(forKey: "medicine_quantity") as! String
        
        let interval_period = "\(data.value(forKey: "interval_period") as! Int)"
        let interval_time = data.value(forKey: "interval_time") as! String
        let interval_type = "\(data.value(forKey: "interval_type") as! Int)"
        
        self.name.text = name
        
        if created_by == 0 {
            self.type.text = medicine_type + "\n\"medicine added by me\""
        } else {
            self.type.text = medicine_type
        }
        
        for (index,item) in images_types.enumerated() {
            if item?.accessibilityIdentifier == medicine_type {
                self.img_type.image = item
            }
        }
        
        switch interval_type {
        case "1": //daily
            self.interval_type.text = "Daily - (Quantity: \(medicine_quantity))"
            self.interval_period.text = "Period: \(interval_period) days"
            self.interval_time.text = "";
        case "2": //weekly
            self.interval_type.text = "Weekly - (Quantity: \(medicine_quantity))"
            self.interval_period.text = "Period: \(interval_period) weeks"
            self.interval_time.text = "Times: \(interval_time) times in a week";
        case "3": // timeinterval
            self.interval_type.text = "Time interval - (Quantity: \(medicine_quantity))"
            self.interval_period.text = "Period: \(interval_period) days"
            let times = (8...24).count / Int(interval_time)!
            self.interval_time.text = "Times: \(times) times in a day";
        default:
            print("none")
        }
        
        beforeAftertime(d: data, interval_type: interval_type, interval_time: interval_time)
        
        setDate(d: data, interval_type: interval_type,interval_period: interval_period)
        
        takenmadicine(id: id)
        
    }
    
    func beforeAftertime(d: NSDictionary,interval_type: String,interval_time: String){
        var timeslot = [String]()
        
        timeslot.removeAll()
        
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
        
        if interval_type == "3" {
            self.timeslot.text = ""
            var time = [String]()
            for (index,hour) in (8...24).enumerated() {
                let int_time = interval_time == "" ? 0 : Int(interval_time)!
                if index % int_time == 0{
                    if hour == 12 {
                        let h = "12 PM"
                        time.append(h)
                    }
                    else if hour == 24 {
                        let h = "12 AM"
                        time.append(h)
                    }
                    else if hour > 12 {
                        let h = "\(hour - 12) PM"
                        time.append(h)
                    }
                    else {
                        let h = "\(hour) AM"
                        time.append(h)
                    }
                }
            }
            self.interval_time.text = "Times: \(time.count) times in a day";
            self.beforeaftertime.text = time.joined(separator: " , ")
        }
        else if breakfast == 0 && lunch == 0 && dinner == 0 {
            //ignore
        }
        else {
            self.timeslot.text = "\(breakfast)-\(lunch)-\(dinner)"
            self.beforeaftertime.text = "# \(timeslot.joined(separator: "\n# "))"
        }
    }
    
    func setDate(d: NSDictionary,interval_type: String,interval_period: String){
        let created_at = d.value(forKey: "created_at") as! String
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = df.date(from: created_at)
        
        let df1 = DateFormatter()
        df1.dateFormat = "dd MMM yyyy HH:mm:ss"
        let datestr = df1.string(from: date!)
        
        let Start_dateSeparate = datestr.components(separatedBy: .whitespaces)
        
        self.start_date.text = Start_dateSeparate[0]
        self.start_month.text = Start_dateSeparate[1]
        self.start_year.text = Start_dateSeparate[2]
        // medicinecell.start_time.text = dateSeparate[3]
        
        var endDate: Date?
        
        switch interval_type {
        case "1":
            endDate = Calendar.current.date(byAdding: .day, value: Int(interval_period)!, to: date!)
        case "2":
            endDate = Calendar.current.date(byAdding: .day, value: Int(interval_period)! * 7, to: date!)
        case "3":
            endDate = Calendar.current.date(byAdding: .day, value: Int(interval_period)!, to: date!)
        default:
            break;
        }
        
        if endDate != nil {
            let df1 = DateFormatter()
            df1.dateFormat = "dd MMM yyyy HH:mm:ss"
            let datestr = df1.string(from: endDate!)
            
            let End_dateSeparate = datestr.components(separatedBy: .whitespaces)
            
            self.end_date.text = End_dateSeparate[0]
            self.end_month.text = End_dateSeparate[1]
            self.end_year.text = End_dateSeparate[2]
            // medicinecell.end_time.text = dateSeparate[3]
            
            if endDate! >= Date() {
                // print("\(indexPath.section)/\(indexPath.row)-Current-\(name)-type-\(interval_type)")
                self.cardview.backgroundColor = UIColor(hexString: "#69f0ae")
                self.currentMedicineColor(primarycolor: UIColor.black, secondarycolor: UIColor.darkGray)
            }
            else {
                // print("\(indexPath.section)/\(indexPath.row)-NonCurrent-\(name)-type-\(interval_type)")
                self.cardview.backgroundColor = UIColor.white
                self.non_currentMedicineColor(primarycolor: UIColor.black, secondarycolor: .darkGray)
            }
        }
    }
    
    func takenmadicine(id: Int){
        let takenmedicineArray = UserDefaults(suiteName: group)?.array(forKey: "TakenMedicineTime") as? [[String: Any]]
        
        do {
            if let takenarray = takenmedicineArray {
                for item in takenarray {
                    if item["id"] as! String == String(id) {
                        let formatter = DateFormatter()
                        formatter.dateFormat = "h:mm a 'on' dd/MM/yy"
                        formatter.amSymbol = "AM"
                        formatter.pmSymbol = "PM"
                        let date = item["time"] as? Date
                        let dateString = formatter.string(from: date!)
                        self.lastmedicinetakentime.text = "Last Medicine Taken Time:\n\(dateString)"
                    }
                }
            }
        } catch {
            print("catch takenmedicineArray")
        }
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
