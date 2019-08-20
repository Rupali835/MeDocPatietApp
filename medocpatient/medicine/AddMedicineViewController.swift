//
//  AddMedicineViewController.swift
//  medocpatient
//
//  Created by Nishikant Ashok UMBARKAR on 16/7/19.
//  Copyright © 2019 kspl. All rights reserved.
//

import UIKit

class AddMedicineViewController: UIViewController , UITextFieldDelegate{
    
    let bearertoken = UserDefaults.standard.string(forKey: "bearertoken")

    @IBOutlet var close : UIButton!
    @IBOutlet var IntervalTypeRadio: [SKRadioButton]!
    
    @IBOutlet var tf_medicine_name : UITextField!
    @IBOutlet var tf_medicine_type : UITextField!
    @IBOutlet var tf_quantity : UITextField!

    @IBOutlet var tf_period : UITextField!
    @IBOutlet var tf_time_interval : UITextField!
    @IBOutlet var title_period: UILabel!
    @IBOutlet var title_time_interval: UILabel!
    @IBOutlet var height_of_time_interval: NSLayoutConstraint!
    @IBOutlet var height_of_beforeafter_view: NSLayoutConstraint!

    @IBOutlet var view_beforeafter: UIView!
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
    
    @IBOutlet var addbtn: UIButton!
    
    @IBOutlet var tableview: UITableView!
    @IBOutlet var height_of_tableview: NSLayoutConstraint!
    @IBOutlet var donebtn: UIButton!
    
    var selectedIndex_MedicineType = 0
    var allmedicine = [NSDictionary]()
    var timeslot = [String]()
    var images_types = [UIImage?]()
    var getSelectedMedicine: ((_ data: [NSDictionary])->Void)?
    var prescriptionID = 0

    var medicineType = ["Capsules", "Cream", "Drops", "Gel", "Inhaler", "Injection", "Lotion", "Mouthwash", "Ointment", "Others", "Physiotherapy", "Powder", "Spray", "Suppository", "Syrup", "Tablet", "Treatment Session"]
    let pickerview = UIPickerView()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.height_of_tableview.constant = 0
        Utilities.shared.cornerRadius(objects: [addbtn,donebtn], number: 10.0)
        
        close.addTarget(self, action: #selector(closeAction), for: .touchUpInside)
        addbtn.addTarget(self, action: #selector(Action_Add), for: .touchUpInside)
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
            self.height_of_beforeafter_view.constant = 300
            self.view_beforeafter.isHidden = false
        }
        else if self.IntervalTypeRadio[1].isSelected == true{
            self.title_period.text = "Weeks"
            self.title_time_interval.text = "day in a Week"
            self.height_of_time_interval.constant = 45
            self.tf_time_interval.isHidden = false
            self.height_of_beforeafter_view.constant = 300
            self.view_beforeafter.isHidden = false
        }
        else if self.IntervalTypeRadio[2].isSelected == true{
            self.title_period.text = "Days"
            self.title_time_interval.text = "hours"//before or/and after interval.
            self.height_of_time_interval.constant = 45
            self.tf_time_interval.isHidden = false
            self.height_of_beforeafter_view.constant = 0
            self.view_beforeafter.isHidden = true
        }
    }
//    override func viewWillAppear(_ animated: Bool) {
//        UIApplication.shared.statusBarStyle = .default
//    }
//    override func viewWillDisappear(_ animated: Bool) {
//        UIApplication.shared.statusBarStyle = .lightContent
//    }
    @objc func closeAction(){
        // self.dismiss(animated: true, completion: nil)
        navigationController?.popViewController(animated: true)//.popViewControllerWithFlipAnimation(Self: self)
    }
    @objc func Action_Add(){
        print(Validation())
        if Validation() == true {
            Utilities.shared.showToast(text: "Medicine Added", duration: 3.0)
            self.allmedicine.append(oneMedicineData())
            
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0, animations: {
                    self.tableview.layoutIfNeeded()
                    self.height_of_tableview.constant = 300
                }) { (complete) in
                    self.tableview.reloadData()
                }
            }
            allclearfield()
        }
    }
    func allclearfield(){
        tf_medicine_name.text = ""
        tf_medicine_type.text = ""
        tf_quantity.text = ""
        self.IntervalTypeRadio.forEach { (button) in
            button.isSelected = false
        }
        tf_period.text = ""
        tf_time_interval.text = ""
        Radio_before_breakfast.isSelected = false
        tf_before_breakfast.text = ""
        Radio_after_breakfast.isSelected = false
        tf_after_breakfast.text = ""
        Radio_before_lunch.isSelected = false
        tf_before_lunch.text = ""
        Radio_after_lunch.isSelected = false
        tf_after_lunch.text = ""
        Radio_before_dinner.isSelected = false
        tf_before_dinner.text = ""
        Radio_after_dinner.isSelected = false
        tf_after_dinner.text = ""
    }
    @objc func Action_Done(){
        print(json(from: self.allmedicine))
        if self.allmedicine.count == 0 {
            Utilities.shared.showToast(text: "You have to add atleast one medicine", duration: 3.0)
        }
        else if prescriptionID != 0{
            self.uploadmedicineby(prescription_id: prescriptionID)
        }
        else {
            self.getSelectedMedicine?(self.allmedicine)
            navigationController?.popViewController(animated: true)
        }
    }
    func uploadmedicineby(prescription_id: Int){
        Utilities.shared.ShowLoaderView(view: self.view, Message: "Medicine Adding")
        var param : [String: Any] = ["prescription_id": prescription_id,
                                     "medicines": self.json(from: self.allmedicine)!]
        
        ApiServices.shared.FetchPostDataFromUrl(vc: self, Url: ApiServices.shared.baseUrl + "add-medicines-for-a-prescription", bearertoken: bearertoken!, onSuccessCompletion: {
            do {
                let json = try JSONSerialization.jsonObject(with: ApiServices.shared.data, options: .mutableContainers) as! NSDictionary
                if let msg = json.value(forKey: "msg") as? String {
                    if msg == "success" {
                        DispatchQueue.main.async {
                            Utilities.shared.RemoveLoaderView()
                            NotificationCenter.default.post(name: NSNotification.Name("reloaddata"), object: nil)
                            Utilities.shared.showToast(text: "Medicines Added Successfully", duration: 3.0)
                            self.navigationController?.popViewControllerWithFlipAnimation(Self: self)
                        }
                    } else {
                        DispatchQueue.main.sync {
                            Utilities.shared.RemoveLoaderView()
                            Utilities.shared.showToast(text: msg, duration: 3.0)
                        }
                    }
                }
            } catch {
                DispatchQueue.main.sync {
                    Utilities.shared.RemoveLoaderView()
                    Utilities.shared.showToast(text: "Something Went Wrong", duration: 3.0)
                }
                print("catch medicine")
            }
        }) { () -> (Dictionary<String, Any>) in
            param
        }
    }
    func json(from object:Any) -> String? {
        guard let data = try? JSONSerialization.data(withJSONObject:  object, options: []) else
        {
            return nil
        }
        
        return String(data: data, encoding: String.Encoding.utf8)
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
        if self.tf_medicine_name.text?.isEmpty == true {
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
                Utilities.shared.showToast(text: "Enter How Many Hours.", duration: 5.0)
                return false
            }//it will remind you to take medicine in Every Hour on Before OR/AND After Interval
        }
        if self.IntervalTypeRadio[2].isSelected == false {
            if self.Radio_before_breakfast.isSelected == false &&
                self.Radio_after_breakfast.isSelected == false &&
                self.Radio_before_lunch.isSelected == false &&
                self.Radio_after_lunch.isSelected == false &&
                self.Radio_before_dinner.isSelected == false &&
                self.Radio_after_dinner.isSelected == false {
                Utilities.shared.showToast(text: "You have to Atleast Select One \"Before OR After\" Time", duration: 3.0)
                return false
            }
        }
        return true
    }
    func oneMedicineData()->NSDictionary{
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
        dict["interval_time"] = self.tf_time_interval.text!
        dict["medicine_name"] = self.tf_medicine_name.text!
        dict["medicine_quantity"] = self.tf_quantity.text!
        dict["medicine_type"] = self.tf_medicine_type.text!
        
        let nsdict = NSDictionary(dictionary: dict)
        return nsdict
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
extension AddMedicineViewController: UITableViewDataSource , UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.allmedicine.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let addcell = tableView.dequeueReusableCell(withIdentifier: "addmedicinecell") as! addmedicinecell
        addcell.SetCellData(d: allmedicine[indexPath.row], indexPath: indexPath)
        return addcell
    }
}
