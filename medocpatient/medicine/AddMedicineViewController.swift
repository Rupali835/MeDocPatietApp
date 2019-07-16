//
//  AddMedicineViewController.swift
//  medocpatient
//
//  Created by Nishikant Ashok UMBARKAR on 16/7/19.
//  Copyright © 2019 kspl. All rights reserved.
//

import UIKit

class AddMedicineViewController: UIViewController , UITextFieldDelegate{

    @IBOutlet var close : UIButton!
    @IBOutlet var IntervalTypeRadio: [SKRadioButton]!
    
    @IBOutlet var tf_patient_Problem : UITextField!
    @IBOutlet var tf_medicine_name : UITextField!
    @IBOutlet var tf_medicine_type : UITextField!
    @IBOutlet var tf_quantity : UITextField!

    @IBOutlet var tf_period : UITextField!
    @IBOutlet var tf_time_interval : UITextField!
    @IBOutlet var title_period: UILabel!
    @IBOutlet var title_time_interval: UILabel!
    @IBOutlet var height_of_time_interval: NSLayoutConstraint!

    @IBOutlet var tf_before_breakfast : UITextField!
    @IBOutlet var tf_after_breakfast : UITextField!
    @IBOutlet var tf_before_lunch : UITextField!
    @IBOutlet var tf_after_lunch : UITextField!
    @IBOutlet var tf_before_dinner : UITextField!
    @IBOutlet var tf_after_dinner : UITextField!

    @IBOutlet var Radio_before_breakfast: SKRadioButton!
    @IBOutlet var Radio_after_breakfast: SKRadioButton!
    @IBOutlet var Radio_before_lunch: SKRadioButton!
    @IBOutlet var Radio_after_lunch: SKRadioButton!
    @IBOutlet var Radio_before_dinner: SKRadioButton!
    @IBOutlet var Radio_after_dinner: SKRadioButton!
    
    @IBOutlet var donebtn: UIButton!
    var selectedIndex_MedicineType = 0
    
    var medicineType = ["Capsules", "Cream", "Drops", "Gel", "Inhaler", "Injection", "Lotion", "Mouthwash", "Ointment", "Others", "Physiotherapy", "Powder", "Spray", "Suppository", "Syrup", "Tablet", "Treatment Session"]
    let pickerview = UIPickerView()

    override func viewDidLoad() {
        super.viewDidLoad()
        close.addTarget(self, action: #selector(closeAction), for: .touchUpInside)
        donebtn.addTarget(self, action: #selector(Action_Done), for: .touchUpInside)
        
        tf_before_breakfast.addTarget(self, action: #selector(Handle_tf_before_breakfast), for: .editingChanged)
        tf_after_breakfast.addTarget(self, action: #selector(Handle_tf_after_breakfast), for: .editingChanged)
        tf_before_lunch.addTarget(self, action: #selector(Handle_tf_before_lunch), for: .editingChanged)
        tf_after_lunch.addTarget(self, action: #selector(Handle_tf_after_lunch), for: .editingChanged)
        tf_before_dinner.addTarget(self, action: #selector(Handle_tf_before_dinner), for: .editingChanged)
        tf_after_dinner.addTarget(self, action: #selector(Handle_tf_after_dinner), for: .editingChanged)
        
        self.tf_medicine_type.inputView = pickerview
        self.tf_medicine_type.delegate = self
        self.pickerview.reloadAllComponents()
        self.pickerview.reloadInputViews()
        self.pickerview.dataSource = self
        self.pickerview.delegate = self
        self.pickerview.backgroundColor = UIColor.lightText
        // Do any additional setup after loading the view.
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if self.tf_medicine_type.isFirstResponder == true {
            self.pickerview.selectRow(self.selectedIndex_MedicineType, inComponent: 0, animated: true)
            self.pickerView(self.pickerview, didSelectRow: self.selectedIndex_MedicineType, inComponent: 0)
            self.tf_medicine_type.text = self.medicineType[self.selectedIndex_MedicineType]
        }
    }
    @objc func Handle_tf_before_breakfast(sender: UITextField){
        if sender.text?.isEmpty == true {
            self.Radio_before_breakfast.isSelected = false
        } else {
            self.Radio_before_breakfast.isSelected = true
        }
    }
    @objc func Handle_tf_after_breakfast(sender: UITextField){
        if sender.text?.isEmpty == true {
            self.Radio_after_breakfast.isSelected = false
        } else {
            self.Radio_after_breakfast.isSelected = true
        }
    }
    @objc func Handle_tf_before_lunch(sender: UITextField){
        if sender.text?.isEmpty == true {
            self.Radio_before_lunch.isSelected = false
        } else {
            self.Radio_before_lunch.isSelected = true
        }
    }
    @objc func Handle_tf_after_lunch(sender: UITextField){
        if sender.text?.isEmpty == true {
            self.Radio_after_lunch.isSelected = false
        } else {
            self.Radio_after_lunch.isSelected = true
        }
    }
    @objc func Handle_tf_before_dinner(sender: UITextField){
        if sender.text?.isEmpty == true {
            self.Radio_before_dinner.isSelected = false
        } else {
            self.Radio_before_dinner.isSelected = true
        }
    }
    @objc func Handle_tf_after_dinner(sender: UITextField){
        if sender.text?.isEmpty == true {
            self.Radio_after_dinner.isSelected = false
        } else {
            self.Radio_after_dinner.isSelected = true
        }
    }
    
    @IBAction func IntervalTypeRadioAction(sender: SKRadioButton){
        self.IntervalTypeRadio.forEach { (button) in
            button.isSelected = false
        }
        sender.isSelected = true
        if self.IntervalTypeRadio[0].isSelected == true{
            self.title_period.text = "Days"
            self.title_time_interval.text = ""
            self.height_of_time_interval.constant = 0
            self.tf_time_interval.isHidden = true
        }
        else if self.IntervalTypeRadio[1].isSelected == true{
            self.title_period.text = "Weeks"
            self.title_time_interval.text = "day in a Week"
            self.height_of_time_interval.constant = 45
            self.tf_time_interval.isHidden = false
        }
        else if self.IntervalTypeRadio[2].isSelected == true{
            self.title_period.text = "Days"
            self.title_time_interval.text = "times to take Medicine on Before OR After Interval"
            self.height_of_time_interval.constant = 45
            self.tf_time_interval.isHidden = false
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        UIApplication.shared.statusBarStyle = .default
    }
    override func viewWillDisappear(_ animated: Bool) {
        UIApplication.shared.statusBarStyle = .lightContent
    }
    @objc func closeAction(){
        // self.dismiss(animated: true, completion: nil)
        navigationController?.popViewControllerWithFlipAnimation(Self: self)
    }
    @objc func Action_Done(){
        print(Validation())
        print(postdata().sorted(by: { $0.0 < $1.0 })
)
    }
    @IBAction func Action_before_breakfast(sender: SKRadioButton){
        if sender.isSelected == false {
            sender.isSelected = true
        }
        else if sender.isSelected == true {
            sender.isSelected = false
        }
    }
    @IBAction func Action_after_breakfast(sender: SKRadioButton){
        if sender.isSelected == false {
            sender.isSelected = true
        }
        else if sender.isSelected == true {
            sender.isSelected = false
        }
    }
    @IBAction func Action_before_lunch(sender: SKRadioButton){
        if sender.isSelected == false {
            sender.isSelected = true
        }
        else if sender.isSelected == true {
            sender.isSelected = false
        }
    }
    @IBAction func Action_after_lunch(sender: SKRadioButton){
        if sender.isSelected == false {
            sender.isSelected = true
        }
        else if sender.isSelected == true {
            sender.isSelected = false
        }
    }
    @IBAction func Action_before_dinner(sender: SKRadioButton){
        if sender.isSelected == false {
            sender.isSelected = true
        }
        else if sender.isSelected == true {
            sender.isSelected = false
        }
    }
    @IBAction func Action_after_dinner(sender: SKRadioButton){
        if sender.isSelected == false {
            sender.isSelected = true
        }
        else if sender.isSelected == true {
            sender.isSelected = false
        }
    }
    func Validation()->Bool{
        if self.tf_patient_Problem.text?.isEmpty == true {
            Utilities.shared.showToast(text: "Enter \(self.tf_patient_Problem.placeholder!)", duration: 3.0)
            return false
        }
        else if self.tf_medicine_name.text?.isEmpty == true {
            Utilities.shared.showToast(text: "Enter \(self.tf_medicine_name.placeholder!)", duration: 3.0)
            return false
        }
        else if self.tf_medicine_type.text?.isEmpty == true {
            Utilities.shared.showToast(text: "Enter \(self.tf_medicine_type.placeholder!)", duration: 3.0)
            return false
        }
        else if self.tf_quantity.text?.isEmpty == true {
            Utilities.shared.showToast(text: "Enter \(self.tf_quantity.placeholder!)", duration: 3.0)
            return false
        }
        else if self.IntervalTypeRadio[0].isSelected == false && self.IntervalTypeRadio[1].isSelected == false && self.IntervalTypeRadio[2].isSelected == false {
            Utilities.shared.showToast(text: "You have to select Interval Type Daily OR Weekly OR Time Interval", duration: 3.0)
            return false
        }
        else if self.IntervalTypeRadio[0].isSelected == true{
            if self.tf_period.text?.isEmpty == true {
                Utilities.shared.showToast(text: "Enter How Many Days in Period", duration: 3.0)
                return false
            }
        }
        else if self.IntervalTypeRadio[1].isSelected == true{
            if self.tf_period.text?.isEmpty == true {
                Utilities.shared.showToast(text: "Enter How Many Weeks in Period", duration: 3.0)
                return false
            }
            else if self.tf_time_interval.text?.isEmpty == true{
                Utilities.shared.showToast(text: "Enter How Many Day in a Week in Interval", duration: 3.0)
                return false
            }
        }
        else if self.IntervalTypeRadio[2].isSelected == true{
            if self.tf_period.text?.isEmpty == true {
                Utilities.shared.showToast(text: "Enter How Many Days in Period", duration: 3.0)
                return false
            }
            else if self.tf_time_interval.text?.isEmpty == true{
                Utilities.shared.showToast(text: "Enter How Many Time To Take Medicine on Before OR After Interval", duration: 5.0)
                return false
            }
        }
        if self.Radio_before_breakfast.isSelected == false &&
           self.Radio_after_breakfast.isSelected == false &&
           self.Radio_before_lunch.isSelected == false &&
           self.Radio_after_lunch.isSelected == false &&
           self.Radio_before_dinner.isSelected == false &&
           self.Radio_after_dinner.isSelected == false {
            Utilities.shared.showToast(text: "You have to Atleast Select One \"Before OR After\" Time", duration: 3.0)
            return false
        }
        return true
    }
    func postdata()->[String: Any]{
        var dict = [String: Any]()
        dict["after_bf"] = self.Radio_after_breakfast.isSelected == true ? 1 : 0
        dict["after_bf_time"] = self.Radio_after_breakfast.isSelected == true ? self.tf_after_breakfast.text == "" ? 0 : Int(self.tf_after_breakfast.text!) : 0
        
        dict["after_dinner"] = self.Radio_after_dinner.isSelected == true ? 1 : 0
        dict["after_dinner_time"] = self.Radio_after_dinner.isSelected == true ? self.tf_after_dinner.text == "" ? 0 : Int(self.tf_after_dinner.text!) : 0
        
        dict["after_lunch"] = self.Radio_after_lunch.isSelected == true ? 1 : 0
        dict["after_lunch_time"] = self.Radio_after_lunch.isSelected == true ? self.tf_after_lunch.text == "" ? 0 : Int(self.tf_after_lunch.text!) : 0
        
        dict["before_bf"] = self.Radio_before_breakfast.isSelected == true ? 1 : 0
        dict["before_bf_time"] = self.Radio_before_breakfast.isSelected == true ? self.tf_before_breakfast.text == "" ? 0 : Int(self.tf_before_breakfast.text!) : 0
        
        dict["before_dinner"] = self.Radio_before_dinner.isSelected == true ? 1 : 0
        dict["before_dinner_time"] = self.Radio_before_dinner.isSelected == true ? self.tf_before_dinner.text == "" ? 0 : Int(self.tf_before_dinner.text!) : 0
        
        dict["before_lunch"] = self.Radio_before_lunch.isSelected == true ? 1 : 0
        dict["before_lunch_time"] = self.Radio_before_lunch.isSelected == true ? self.tf_before_lunch.text == "" ? 0 : Int(self.tf_before_lunch.text!) : 0
        
        if self.IntervalTypeRadio[0].isSelected == true{
            dict["interval_type"] = 1
        }
        else if self.IntervalTypeRadio[1].isSelected == true{
            dict["interval_type"] = 2
        }
        else if self.IntervalTypeRadio[2].isSelected == true{
            dict["interval_type"] = 3
        }

        dict["interval_period"] = Int(self.tf_period.text!)
        dict["interval_time"] = Int(self.tf_time_interval.text!)
        dict["medicine_name"] = self.tf_medicine_name.text!
        dict["medicine_quantity"] = Int(self.tf_quantity.text!)
        dict["medicine_type"] = self.tf_medicine_type.text!
        
        return dict
    }
}
extension AddMedicineViewController: UIPickerViewDelegate,UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.medicineType.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.medicineType[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if self.medicineType.count == 0{
            
        } else {
            self.tf_medicine_type.text = self.medicineType[row]
            self.selectedIndex_MedicineType = row
        }
    }
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 45
    }
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var label: UILabel
        if let view = view as? UILabel{
            label = view
        } else {
            label = UILabel()
        }
        label.textColor = UIColor.black
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.text = self.medicineType[row]
        
        return label
    }
    
}
