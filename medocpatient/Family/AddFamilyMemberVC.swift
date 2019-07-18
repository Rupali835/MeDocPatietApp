//
//  AddFamilyMemberVC.swift
//  medocpatient
//
//  Created by Nishikant Ashok UMBARKAR on 18/6/19.
//  Copyright © 2019 kspl. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class AddFamilyMemberVC: UIViewController {
    
    @IBOutlet var close : UIButton!
    @IBOutlet var FullNameTF: UITextField!
    @IBOutlet var DateOfBirthTF: UITextField!
    @IBOutlet var RelationshipBtn: UIButton!
    @IBOutlet var RelationshipTF: UITextField!
    @IBOutlet var GenderRadio: [SKRadioButton]!
    @IBOutlet var PasswordTF: UITextField!
    @IBOutlet var Add: UIButton!
    
    var relationship = ""
    var name_relationship = ""
    var dateview = UIDatePicker()
    var selectedGender = 0
    var registernumber = ""
    var callback: (() -> Void)?
    
    let contact_no = UserDefaults.standard.string(forKey: "contact_no")
    let name = UserDefaults.standard.string(forKey: "name")
    let pickerview = UIPickerView()

    override func viewDidLoad() {
        super.viewDidLoad()
        Utilities.shared.cornerRadius(objects: [Add], number: 10.0)
        
        close.addTarget(self, action: #selector(closeAction), for: .touchUpInside)
        Add.addTarget(self, action: #selector(AddAction), for: .touchUpInside)
       // RelationshipBtn.addTarget(self, action: #selector(Actionselectrelation), for: .touchUpInside)
        self.pickerview.reloadAllComponents()
        self.pickerview.reloadInputViews()
        self.pickerview.dataSource = self
        self.pickerview.delegate = self
        self.pickerview.backgroundColor = UIColor.lightText
        
        RelationshipTF.delegate = self
        RelationshipTF.inputView = pickerview
        // PasswordTF.addTarget(self, action: #selector(updatePassword), for: .editingChanged)

        self.registernumber = contact_no!

        DateOfBirthTF.inputView = dateview
        
        dateview.datePickerMode = .date
        dateview.maximumDate = Date()
        dateview.backgroundColor = UIColor.white
        dateview.setValue(UIColor.black, forKeyPath: "textColor")
        dateview.setDate(Date(), animated: true)
        dateview.addTarget(self, action: #selector(setdate), for: .valueChanged)
        
//        let button = UIButton(type: .system)
//        button.setTitle("Show", for: .normal)
//        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
      //  button.frame = CGRect(x: CGFloat(PasswordTF.frame.size.width - 10), y: CGFloat(0), width: CGFloat(80), height: CGFloat(40))
//        button.tintColor = #colorLiteral(red: 0.2117647059, green: 0.09411764706, blue: 0.3294117647, alpha: 1)
//        button.addTarget(self, action: #selector(self.showpassword), for: .touchUpInside)
       // PasswordTF.rightView = button
      //  PasswordTF.rightViewMode = .always
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UIApplication.shared.statusBarStyle = .default
    }
    override func viewWillDisappear(_ animated: Bool) {
        UIApplication.shared.statusBarStyle = .lightContent
    }
    @objc func showpassword(sender: UIButton){
        if sender.titleLabel?.text == "Show"{
            PasswordTF.isSecureTextEntry = false
            sender.setTitle("Secure", for: .normal)
        } else {
            sender.setTitle("Show", for: .normal)
            PasswordTF.isSecureTextEntry = true
        }
    }
    @objc func updatePassword(){
        if PasswordTF.isFirstResponder {
            if let text = PasswordTF.text {
                if let floatingLabelTextField = PasswordTF as? SkyFloatingLabelTextField {
                    if text.count >= 0{
                        if text.isValidPassword() {
                            floatingLabelTextField.errorMessage = ""
                        }
                        else if text.isEmpty == true{
                            floatingLabelTextField.errorMessage = ""
                        }
                        else {
                            floatingLabelTextField.errorMessage = "Invalid password"
                        }
                    }
                }
            }
        }
    }
    @objc func Actionselectrelation(){
        self.selectrelationshipAlert(title: "Select Relationship With \(self.name_relationship)", msg: "")
    }
    @objc func AddAction(){
        if (self.FullNameTF.text?.isEmpty)! {
            Utilities.shared.showToast(text: "Enter \(self.FullNameTF.placeholder!)", duration: 3.0)
        }
        else if self.DateOfBirthTF.text?.isEmpty == true {
            Utilities.shared.showToast(text: "Select Date Of Birth", duration: 3.0)
        }
        else if self.relationship == "" {
            Utilities.shared.showToast(text: "Select Relationship", duration: 3.0)
        }
        else if self.selectedGender == 0{
            Utilities.shared.showToast(text: "Select Gender", duration: 3.0)
        }
//        else if (self.PasswordTF.text?.isEmpty)! {
//            Utilities.shared.showToast(text: "Enter \(self.PasswordTF.placeholder!)", duration: 3.0)
//        }
//        else if self.PasswordTF.text?.isValidPassword() == false{
//            Utilities.shared.showToast(text: "Invalid Password", duration: 3.0)
//        }
        else {
            
            let without_patient_id = "name=\(self.FullNameTF.text!)&contact_no=\(self.registernumber)&gender=\(self.selectedGender)&relationship=\(relationship)&dob=\(self.DateOfBirthTF.text!)&email=&password=\(987654321)&c_password=\(987654321)"
            
            NetworkManager.isReachable { _ in
                self.register(parameter: without_patient_id)
            }
            NetworkManager.isUnreachable { (_) in
                Alert.shared.internetoffline(vc: self)
            }
            NetworkManager.sharedInstance.reachability.whenReachable = { _ in
                self.register(parameter: without_patient_id)
            }
            NetworkManager.sharedInstance.reachability.whenUnreachable = { _ in
                DispatchQueue.main.async {
                    Utilities.shared.RemoveLoaderView()
                }
            }
            
        }
        
    }
    
    func register(parameter: String){
        Utilities.shared.ShowLoaderView(view: self.view, Message: "Please Wait...")
        ApiServices.shared.FetchPostDataFromUrlWithoutToken(vc: self, Url: ApiServices.shared.baseUrl + "patientregister", parameter:  parameter, onSuccessCompletion: {
            do {
                let json = try JSONSerialization.jsonObject(with: ApiServices.shared.data, options: .mutableContainers) as! NSDictionary
                print(json)
                if let msg = json.value(forKey: "msg") as? String{
                    if msg == "success" {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                            Utilities.shared.RemoveLoaderView()
                            Utilities.shared.showToast(text: "Family Member Added Successfully", duration: 3.0)
                            
                            if let data = json.value(forKey: "data") as? NSDictionary {
                                let patient_id = data.value(forKey: "patient_id") as! String
                                self.callback!()
                            }
                            self.navigationController?.popViewControllerWithFlipAnimation(Self: self)
                            //self.dismiss(animated: true, completion: nil)
                        }
                    }
                    if msg == "fail" {
                        if let reason = json.value(forKey: "reason") as? String{
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                                Utilities.shared.RemoveLoaderView()
                                Utilities.shared.showToast(text: "Reason: \(reason)", duration: 3.0)
                            }
                        }
                    }
                }
            } catch {
                print("catch")
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                    Utilities.shared.RemoveLoaderView()
                    Utilities.shared.showToast(text: "Something Went Wrong", duration: 3.0)
                }
            }
        })
    }
    @objc func closeAction(){
        // self.dismiss(animated: true, completion: nil)
        navigationController?.popViewControllerWithFlipAnimation(Self: self)
    }
    @objc func setdate(datePicker: UIDatePicker){
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        if DateOfBirthTF.isFirstResponder {
            DateOfBirthTF.text = df.string(from: datePicker.date)
            let calendar : NSCalendar = NSCalendar.current as NSCalendar
            let ageComponents = calendar.components(.month, from: dateview.date, to: Date() as Date, options: []).month
            let years = ageComponents! / 12
            let months = ageComponents! % 12
            let age = "Age: \(years) Y / \(months) M"
        }
    }
    func selectrelationshipAlert(title: String?,msg: String?){
        let alertController = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        for relation in relations {
            let alert = UIAlertAction(title: relation, style: .default) { (action) in
                print(action.title!)
                self.relationship = action.title!
                self.RelationshipBtn.setTitle(self.relationship, for: .normal)
            }
            alertController.addAction(alert)
        }
        present(alertController, animated: true, completion: nil)
    }
    @IBAction func ChangeGender(sender: SKRadioButton){
        self.GenderRadio.forEach { (button) in
            button.isSelected = false
        }
        sender.isSelected = true
        if self.GenderRadio[0].isSelected == true{
            self.selectedGender = 1
        }
        else if self.GenderRadio[1].isSelected == true{
            self.selectedGender = 2
        }
        else if self.GenderRadio[2].isSelected == true{
            self.selectedGender = 3
        }
    }
}
extension AddFamilyMemberVC: UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return relations.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return relations[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.relationship = relations[row]
        self.RelationshipTF.text = self.relationship
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
        label.text = relations[row]
        
        return label
    }
}
