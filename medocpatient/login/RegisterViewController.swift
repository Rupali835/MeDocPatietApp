//
//  RegisterViewController.swift
//  MedocPatient
//
//  Created by Prem Sahni on 12/12/18.
//  Copyright © 2018 Kanishka. All rights reserved.
//
//

import UIKit
import SkyFloatingLabelTextField

class RegisterViewController: UIViewController{

    @IBOutlet var Close: UIButton!
    @IBOutlet var FullNameTF: UITextField!
    @IBOutlet var EmailTF: UITextField!
    @IBOutlet var NumberTF: UITextField!
    @IBOutlet var PasswordTF: UITextField!
    @IBOutlet var ConfirmPasswordTF: UITextField!
    @IBOutlet var DateOfBirthTF: UITextField!
    @IBOutlet var RelationshipBtn: UIButton!
    @IBOutlet var width_RelationshipBtn: NSLayoutConstraint!
    @IBOutlet var GenderRadio: [SKRadioButton]!
    @IBOutlet var Signup: UIButton!
    @IBOutlet var Gview: UIView!

    @IBOutlet var PatientIDRadio: SKRadioButton!
    @IBOutlet var PatientIDTF: UITextField!
    @IBOutlet var Done : UIButton!
    @IBOutlet var patientidView: UIView!
    @IBOutlet var signupView: UIView!
    
    var HavePatientID = false
    var selectedGender = 0
    var patientidget = ""
    var relationship = "Self"
    var name_relationship = ""
    var dateview = UIDatePicker()
    let relations = ["Grandfather","Grandmother","Father","Mother","Son","Daughter","Brother","Sister","Husband","Wife"]
    var multipleuserdata = NSArray()
    
    @IBOutlet var HeightofPatientIDview: NSLayoutConstraint!
    @IBOutlet var HeightofSignupview: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.width_RelationshipBtn.constant = 0

        PatientIDTF.delegate = self
        FullNameTF.delegate = self
        EmailTF.delegate = self
        NumberTF.delegate = self
        PasswordTF.delegate = self
        ConfirmPasswordTF.delegate = self
        
        DispatchQueue.main.async {
            self.PatientIDRadio.isSelected = false
            self.minimizeHeight(objects: [self.PatientIDTF,self.Done], heightContantOutlet: [self.HeightofPatientIDview], constant: 0)
        }
        
        Utilities.shared.borderRadius(objects: [Signup], color: UIColor(hexString: "673AB7"))
        Utilities.shared.cornerRadius(objects: [Signup], number: 5.0)
        
        Done.addTarget(self, action: #selector(DoneAction), for: .touchUpInside)
        Close.addTarget(self, action: #selector(CloseAction), for: .touchUpInside)
        
        let button = UIButton(type: .system)
        button.setTitle("Show", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        button.frame = CGRect(x: CGFloat(PasswordTF.frame.size.width - 10), y: CGFloat(0), width: CGFloat(80), height: CGFloat(40))
        button.tintColor = #colorLiteral(red: 0.2117647059, green: 0.09411764706, blue: 0.3294117647, alpha: 1)
        button.addTarget(self, action: #selector(self.showpassword), for: .touchUpInside)
        PasswordTF.rightView = button
        PasswordTF.rightViewMode = .always
        
        PasswordTF.addTarget(self, action: #selector(updatePassword), for: .editingChanged)
        ConfirmPasswordTF.addTarget(self, action: #selector(updateConfirmPassword), for: .editingChanged)
        EmailTF.addTarget(self, action: #selector(updateEmail), for: .editingChanged)

        Signup.addTarget(self, action: #selector(SignupAction), for: .touchUpInside)
        
        DateOfBirthTF.delegate = self
        DateOfBirthTF.inputView = dateview
        
        dateview.datePickerMode = .date
        dateview.maximumDate = Date()
        dateview.backgroundColor = UIColor.white
        dateview.setValue(UIColor.black, forKeyPath: "textColor")
        dateview.setDate(Date(), animated: true)
        dateview.addTarget(self, action: #selector(setdate), for: .valueChanged)
        
        RelationshipBtn.addTarget(self, action: #selector(Actionselectrelation), for: .touchUpInside)
        PatientIDTF.addTarget(self, action: #selector(updatePatient), for: .editingChanged)

        // Do any additional setup after loading the view.
    }
    @objc func Actionselectrelation(){
        self.selectrelationshipAlert(title: "Select Relationship With \(self.name_relationship)", msg: "User/s is/are already registered with this number")
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
        for relation in self.relations {
            let alert = UIAlertAction(title: relation, style: .default) { (action) in
                print(action.title!)
                self.relationship = action.title!
                self.RelationshipBtn.setTitle(self.relationship, for: .normal)
            }
            alertController.addAction(alert)
        }
        present(alertController, animated: true, completion: nil)
    }
    @objc func updateEmail(){
        if EmailTF.isFirstResponder {
            if let text = EmailTF.text {
                if let floatingLabelTextField = EmailTF as? SkyFloatingLabelTextField {
                    if text.isEmpty {
                        floatingLabelTextField.errorMessage = ""
                    }
                    else if text.count > 0 && text.contains(find: "@"){
                        if text.isValidEmail() {
                            floatingLabelTextField.errorMessage = ""
                        } else {
                            floatingLabelTextField.errorMessage = "Invalid email"
                        }
                    }
                }
            }
        }
    }
    @objc func updateConfirmPassword(){
        
        //check confirm password == password
        if let text = ConfirmPasswordTF.text {
            if let floatingLabelTextField = ConfirmPasswordTF as? SkyFloatingLabelTextField {
                if text.count >= 0{
                    if text == PasswordTF.text! && text.isValidPassword() {
                        floatingLabelTextField.errorMessage = ""
                    }
                    else if text.isEmpty == true{
                        floatingLabelTextField.errorMessage = ""
                    }
                    else {
                        floatingLabelTextField.errorMessage = "Not Matched With Password"
                    }
                }
            }
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
    @objc func showpassword(sender: UIButton){
        if sender.titleLabel?.text == "Show"{
            PasswordTF.isSecureTextEntry = false
            ConfirmPasswordTF.isSecureTextEntry = false
            sender.setTitle("Secure", for: .normal)
        } else {
            sender.setTitle("Show", for: .normal)
            PasswordTF.isSecureTextEntry = true
            ConfirmPasswordTF.isSecureTextEntry = true
        }
    }
    @objc func DoneAction(){
        if (PatientIDTF.text?.isEmpty)! {
            Utilities.shared.showToast(text: "Enter \(self.PatientIDTF.placeholder!)", duration: 3.0)
        } else {
            fetchDetailByPatientID()
        }
    }
    @objc func CloseAction(){
        self.dismiss(animated: true, completion: nil)
    }
    @objc func SignupAction(){
        //check empty textfield
        if (self.FullNameTF.text?.isEmpty)! {
            Utilities.shared.showToast(text: "Enter \(self.FullNameTF.placeholder!)", duration: 3.0)
        }
//        else if (self.EmailTF.text?.isEmpty)! {
//            Utilities.shared.showToast(text: "Enter \(self.EmailTF.placeholder!)", duration: 3.0)
//        }
        else if self.EmailTF.text != "" && self.EmailTF.text?.isValidEmail() == false{
            Utilities.shared.showToast(text: "Invalid Email", duration: 3.0)
        }
        else if (self.NumberTF.text?.isEmpty)! {
            Utilities.shared.showToast(text: "Enter \(self.NumberTF.placeholder!)", duration: 3.0)
        }
        else if self.DateOfBirthTF.text?.isEmpty == true {
            Utilities.shared.showToast(text: "Select Date Of Birth", duration: 3.0)
        }
        else if (self.PasswordTF.text?.isEmpty)! {
            Utilities.shared.showToast(text: "Enter \(self.PasswordTF.placeholder!)", duration: 3.0)
        }
        else if (self.ConfirmPasswordTF.text?.isEmpty)! {
            Utilities.shared.showToast(text: "Enter \(self.ConfirmPasswordTF.placeholder!)", duration: 3.0)
        }
//        else if self.NumberTF.text?.isValidIndianContact == false{
  //      Utilities.shared.showToast(text: "Invalid Mobile Number", duration: 3.0)
//        }
        else if self.NumberTF.text?.count != 10{
            Utilities.shared.showToast(text: "Invalid Mobile Number", duration: 3.0)
        }
        else if self.NumberTF.text != "" && self.NumberTF.text?.first == "0"{
            Utilities.shared.showToast(text: "Mobile Number Should Not Start With 0", duration: 3.0)
        }
        else if self.PasswordTF.text?.isValidPassword() == false{
            Utilities.shared.showToast(text: "Invalid Password", duration: 3.0)
        }
        else if self.ConfirmPasswordTF.text != self.PasswordTF.text {
            Utilities.shared.showToast(text: "Not Matched With Password", duration: 3.0)
        }
        else if self.selectedGender == 0{
            Utilities.shared.showToast(text: "Select Gender", duration: 3.0)
        }
        //check all validation
        else {
            if HavePatientID == true{
                //with patient id
                if (self.PatientIDTF.text?.isEmpty)! {
                    
                } else {
                    print("0")
                    let with_patient_id = "name=\(self.FullNameTF.text!)&contact_no=\(self.NumberTF.text!)&gender=\(self.selectedGender)&email=\(self.EmailTF.text!)&password=\(self.PasswordTF.text!)&c_password=\(self.ConfirmPasswordTF.text!)&patient_id=\(self.patientidget)&relationship=\(relationship)&dob=\(self.DateOfBirthTF.text!)"
                    
                    NetworkManager.isReachable { _ in
                        self.register(parameter: with_patient_id)
                    }
                    NetworkManager.isUnreachable { (_) in
                        Alert.shared.internetoffline(vc: self)
                    }
                    NetworkManager.sharedInstance.reachability.whenReachable = { _ in
                        self.register(parameter: with_patient_id)
                    }
                    NetworkManager.sharedInstance.reachability.whenUnreachable = { _ in
                        DispatchQueue.main.async {
                            Utilities.shared.RemoveLoaderView()
                        }
                    }
                }
            }
            else if HavePatientID == false{
                print("1")
                //without patient id
                let without_patient_id = "name=\(self.FullNameTF.text!)&contact_no=\(self.NumberTF.text!)&gender=\(self.selectedGender)&email=\(self.EmailTF.text!)&password=\(self.PasswordTF.text!)&c_password=\(self.ConfirmPasswordTF.text!)&relationship=\(relationship)&dob=\(self.DateOfBirthTF.text!)"
                
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
    }//7218845446 & Amit@123
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
                            Utilities.shared.showToast(text: "Signup Successfully", duration: 3.0)
                            
                            if let data = json.value(forKey: "data") as? NSDictionary {
                                let patient_id = data.value(forKey: "patient_id") as! String
                                NotificationCenter.default.post(name: NSNotification.Name("loginupdate"), object: nil, userInfo:["email":patient_id,"password":self.PasswordTF.text!])
                            }
                            self.dismiss(animated: true, completion: nil)
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
    func fetchDetailByPatientID(){
        Utilities.shared.ShowLoaderView(view: self.view, Message: "Fetching Details...")
        PatientIDTF.endEditing(true)
        ApiServices.shared.FetchPostDataFromUrlWithoutToken(vc: self, Url: ApiServices.shared.baseUrl + "patientregisterusingid", parameter: "login_id=\(PatientIDTF.text!)", onSuccessCompletion: {
            do {
                let json = try JSONSerialization.jsonObject(with: ApiServices.shared.data, options: .mutableContainers) as! NSDictionary
                print(json)
                let msg = json.value(forKey: "msg") as? String
                
                if msg == "success"{
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                        Utilities.shared.RemoveLoaderView()
                        
                        if let data = json.value(forKey: "data") as? NSDictionary {
                            
                            let name = data.value(forKey: "name") as? String ?? ""
                            let contact_no = data.value(forKey: "contact_no") as? String ?? ""
                            let email = data.value(forKey: "email") as? String ?? ""
                            let gender = "\(data.value(forKey: "gender") as! Int)"
                            let patient_id = "\(data.value(forKey: "patient_id") as! String)"
                            let dob = data.value(forKey: "dob") as? String ?? ""
                            let relationship = data.value(forKey: "relationship") as? String ?? ""
                            
                            self.FullNameTF.text = ""
                            self.EmailTF.text = ""
                            self.NumberTF.text = ""
                            self.selectedGender = 0
                            self.patientidget = ""
                            self.GenderRadio[0].isSelected = false
                            self.GenderRadio[1].isSelected = false
                            self.GenderRadio[2].isSelected = false
                            self.PasswordTF.text = ""
                            self.ConfirmPasswordTF.text = ""
                            
                            if name != ""{
                                self.FullNameTF.isUserInteractionEnabled = false
                            }
                            if contact_no != ""{
                                self.NumberTF.isUserInteractionEnabled = false
                            }
                            
                            if dob != ""{
                                self.DateOfBirthTF.isUserInteractionEnabled = false
                            }
                            
                            if email != "" {
                                self.EmailTF.isUserInteractionEnabled = false
                            }
                            
                            self.FullNameTF.text = name
                            self.EmailTF.text = email
                            self.NumberTF.text = contact_no
                            self.selectedGender = Int(gender)!
                            self.patientidget = patient_id
                            self.DateOfBirthTF.text = dob
                            self.relationship = relationship
                            
                            if gender == "1"{
                                self.GenderRadio[0].isSelected = true
                            }
                            else if gender == "2"{
                                self.GenderRadio[1].isSelected = true
                            }
                            else if gender == "3"{
                                self.GenderRadio[2].isSelected = true
                            }
                            
                            self.GenderRadio[0].isUserInteractionEnabled = false
                            self.GenderRadio[1].isUserInteractionEnabled = false
                            self.GenderRadio[2].isUserInteractionEnabled = false

                            self.maximizeHeight(objects: [self.signupView], heightContantOutlet: [self.HeightofSignupview],constant: 400)
                        }
                    }
                }
                else if msg == "fail"{
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                        Utilities.shared.RemoveLoaderView()
                        if let reason = json.value(forKey: "reason") as? String{
                            Utilities.shared.showToast(text: "Reason: \(reason)", duration: 3.0)
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
    func fetch_register_relative_check(completion: @escaping ()->()){
        ApiServices.shared.FetchPostDataFromUrlWithoutToken(vc: self, Url: ApiServices.shared.baseUrl + "register-relative-check", parameter: "login_id=\(self.NumberTF.text!)") {
            do {
                let json = try JSONSerialization.jsonObject(with: ApiServices.shared.data, options: .mutableContainers) as! NSDictionary
                let msg = json.value(forKey: "msg") as! String
                print("register-relative-check \(json)")
                if msg == "success" {
                    let data = json.value(forKey: "data") as! String
                    DispatchQueue.main.async {
                        if data == "No User" {
                            
                        }
                        else if data == "User/s is/are already registered with this number"{
                            if let extra = json.value(forKey: "extra") as? NSArray {
                                print("extra \(extra)")
                                if extra.count == 0{
                                    
                                } else {
                                    self.relationship = ""
                                    self.width_RelationshipBtn.constant = 120
                                    for (index,_) in extra.enumerated() {
                                        let dic = extra.object(at: index) as? NSDictionary
                                        self.name_relationship = dic?.value(forKey: "name") as! String
                                        let checkrelation = dic?.value(forKey: "relationship") as? String ?? ""
                                        if checkrelation == "Self"{
                                            self.selectrelationshipAlert(title: "Select Relationship With \(self.name_relationship)", msg: "User/s is/are already registered with this number")
                                            break;
                                        }
                                        else {
                                            self.selectrelationshipAlert(title: "Select Relationship With \(self.name_relationship)", msg: "User/s is/are already registered with this number")
                                        }
                                    }
                                }
                            }
                        }
                        else {
                            Utilities.shared.showToast(text: data, duration: 3.0)
                        }
                    }
                }
            } catch {
                print("catch register-relative-check")
            }
        }
    }
    @IBAction func PatientIDYesOrNo(sender: SKRadioButton){
        
        if sender.isSelected == false {
            sender.isSelected = true
            HavePatientID = true
            maximizeHeight(objects: [PatientIDTF,Done], heightContantOutlet: [HeightofPatientIDview],constant: 50)
            minimizeHeight(objects: [signupView], heightContantOutlet: [HeightofSignupview], constant: 0)
        }
        else if sender.isSelected == true {
            sender.isSelected = false
            HavePatientID = false
            self.FullNameTF.text = ""
            self.EmailTF.text = ""
            self.NumberTF.text = ""
            self.selectedGender = 0
            self.patientidget = ""
            self.GenderRadio[0].isSelected = false
            self.GenderRadio[1].isSelected = false
            self.GenderRadio[2].isSelected = false
            self.PasswordTF.text = ""
            self.ConfirmPasswordTF.text = ""
            
            self.FullNameTF.isUserInteractionEnabled = true
            self.NumberTF.isUserInteractionEnabled = true
            self.DateOfBirthTF.isUserInteractionEnabled = true
            self.GenderRadio[0].isUserInteractionEnabled = true
            self.GenderRadio[1].isUserInteractionEnabled = true
            self.GenderRadio[2].isUserInteractionEnabled = true
            self.EmailTF.isUserInteractionEnabled = true
            
            minimizeHeight(objects: [PatientIDTF,Done], heightContantOutlet: [HeightofPatientIDview], constant: 0)
            maximizeHeight(objects: [signupView], heightContantOutlet: [HeightofSignupview],constant: 400)
        }
        
    }
    func minimizeHeight(objects: [UIView],heightContantOutlet: [NSLayoutConstraint],constant: CGFloat){
        for obj in objects{
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                obj.isHidden = true
            }
        }
        for obj in heightContantOutlet{
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                obj.constant = constant
            }
        }
    }
    func maximizeHeight(objects: [UIView],heightContantOutlet: [NSLayoutConstraint],constant: CGFloat){
        for obj in objects{
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                obj.isHidden = false
            }
        }
        for obj in heightContantOutlet{
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                obj.constant = constant
            }
        }
    }
    func datePicker(sender: UIView,done_complation: @escaping ()->()){
        let vc = UIViewController()
        
        let editRadiusAlert = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        
        var width: CGFloat = 240
        if UIDevice.current.userInterfaceIdiom == .pad {
            width = editRadiusAlert.view.frame.width / 2
        } else {
            width = editRadiusAlert.view.frame.width
        }
        vc.preferredContentSize = CGSize(width: width,height: 240)
        dateview = UIDatePicker(frame: CGRect(x: 0, y: 0, width: width, height: 240))
        dateview.datePickerMode = .date
        dateview.maximumDate = Date()
        vc.view.addSubview(dateview)
        
        editRadiusAlert.setValue(vc, forKey: "contentViewController")
        editRadiusAlert.addAction(UIAlertAction(title: "Done", style: .default, handler: { (action) in
            done_complation()
        }))
        editRadiusAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        editRadiusAlert.popoverPresentationController?.sourceView = sender
        editRadiusAlert.popoverPresentationController?.sourceRect = sender.bounds
        editRadiusAlert.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.down;
        
        self.present(editRadiusAlert, animated: true)
    }
    func fetch_login_by_relative_check(){
        ApiServices.shared.FetchPostDataFromUrlWithoutToken(vc: self, Url: ApiServices.shared.baseUrl + "login-by-relative-check", parameter: "login_id=\(self.PatientIDTF.text!)") {
            do {
                let json = try JSONSerialization.jsonObject(with: ApiServices.shared.data, options: .mutableContainers) as! NSDictionary
                print("login-by-relative-check json: \(json)")
                let msg = json.value(forKey: "msg") as! String
                if msg == "success" {
                    DispatchQueue.main.async {
                        if let data = json.value(forKey: "data") as? NSArray {
                            print("data: \(data)")
                            if data.count == 0{
                                
                            } else {
                                self.multipleuserdata = data
                                self.tableview_Alert(title: "Number Register With Multiple User", msg: "Select Your Name To Get Details")
                            }
                        }
                        else if let data = json.value(forKey: "data") as? String {
                            print("data in String: \(data)")
                            if data == "Single or No User"{
                                
                            }
                        }
                    }
                }
            } catch {
                print("catch login-by-relative-check")
            }
        }
    }
    func tableview_Alert(title: String?,msg: String?){
        let vc = UIViewController()
        vc.preferredContentSize = CGSize(width: 250,height: 250)
        let tableview = UITableView(frame: CGRect(x: 0, y: 0, width: 250, height: 240))
        tableview.delegate = self
        tableview.dataSource = self
        vc.view.addSubview(tableview)
        let editRadiusAlert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertController.Style.alert)
        editRadiusAlert.setValue(vc, forKey: "contentViewController")
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {(alert: UIAlertAction!) in print("cancel")})
        
        editRadiusAlert.addAction(cancelAction)
        self.present(editRadiusAlert, animated: true, completion:{})
    }
    @objc func updatePatient(){
        if PatientIDTF.isFirstResponder {
            if let text = PatientIDTF.text {
                if let floatingLabelTextField = PatientIDTF as? SkyFloatingLabelTextField {
                    if text.isEmpty {
                        floatingLabelTextField.errorMessage = ""
                    }
//                    else if text.count > 3 && text.contains(find: "@"){
//                        if text.isValidEmail() {
//                            floatingLabelTextField.errorMessage = ""
//                            self.fetch_login_by_relative_check()
//                        } else {
//                            floatingLabelTextField.errorMessage = "Invalid email"
//                        }
//                    }
                    else if text.count < 3{
                        floatingLabelTextField.errorMessage = ""
                    }
                    else if text.count == 10 && text.containsNumbers() == true{
                        self.fetch_login_by_relative_check()
                    }
                }
            }
        }
    }
}
extension RegisterViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if FullNameTF.isFirstResponder {
            if let text = FullNameTF.text {
                if let floatingLabelTextField = FullNameTF as? SkyFloatingLabelTextField {
                    if text.isEmpty {
                        floatingLabelTextField.errorMessage = ""
                    }
                    else if text.count >= 0{
                        floatingLabelTextField.errorMessage = ""
                    }
                }
            }
        }
        if NumberTF.isFirstResponder {
            if let text = NumberTF.text {
                if let floatingLabelTextField = NumberTF as? SkyFloatingLabelTextField {
                    if text.isEmpty {
                        floatingLabelTextField.errorMessage = ""
                    }
                    else if text.count >= 0{
                        if text.isValidIndianContact {
                            floatingLabelTextField.errorMessage = ""
                        } else {
                            floatingLabelTextField.errorMessage = "Invalid Mobile Number"
                        }
                    }
                }
                
                let limitLength = 10
                let newLength = text.count + string.count - range.length
                
                if newLength == limitLength {
                    if string.containsNumbers() == true{
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                            self.fetch_register_relative_check(completion: {})
                        }
                    }
                }
                
                return newLength <= limitLength
            }
        }
        return true
    }
}
extension RegisterViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.multipleuserdata.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
        let data = self.multipleuserdata.object(at: indexPath.row) as! NSDictionary
        let patient_id = data.value(forKey: "patient_id") as? String
        let name = data.value(forKey: "name") as? String
        let relationship = data.value(forKey: "relationship") as? String ?? ""
        cell.textLabel?.text = name!
        cell.detailTextLabel?.text = patient_id
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell!.accessoryType = .checkmark
        self.PatientIDTF.text = cell?.detailTextLabel?.text
        self.dismiss(animated: true, completion: nil)
        fetchDetailByPatientID()
    }
}
