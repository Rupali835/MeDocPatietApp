//
//  ProfilePageViewController.swift
//  MedocPatient
//
//  Created by Prem Sahni on 08/12/18.
//  Copyright © 2018 Kanishka. All rights reserved.
//

import UIKit
import FSCalendar
import CoreData
import DBAttachmentPickerController
import SkyFloatingLabelTextField
import DropDown
import ZAlertView

class ProfilePageViewController: UIViewController, UITextFieldDelegate , FSCalendarDataSource , FSCalendarDelegate, DBAssetPickerControllerDelegate {
    //user
    @IBOutlet var BasicView: UIView!
    @IBOutlet var imagesPicView: UIImageView!
    @IBOutlet var addProfileImage: UIButton!
    @IBOutlet var NameTF: UITextField!
    @IBOutlet var DateOfBirthTF: UITextField!
    @IBOutlet var age: UILabel!
    @IBOutlet var BloodGroupTF: UITextField!
    @IBOutlet var emailTF: UITextField!
    @IBOutlet var PatientTF: UITextField!
    @IBOutlet var GenderRadio: [SKRadioButton]!
    
    @IBOutlet var MobileAddressView: UIView!
    @IBOutlet var MobileNumberTF: UITextField!
    @IBOutlet var Address1TF: UITextField!
    @IBOutlet var Address2TF: UITextField!
    @IBOutlet var SubCityTF: UITextField!
    @IBOutlet var CityTF: UITextField!
    @IBOutlet var pincodeTF: UITextField!
    //guardian
    @IBOutlet var GuardianView: UIView!
    @IBOutlet var GuardianNameTF: UITextField!
    @IBOutlet var GuardianMobileNumberTF: UITextField!
    @IBOutlet var GuardianAddress1TF: UITextField!
    @IBOutlet var GuardianAddress2TF: UITextField!
    @IBOutlet var GuardianSubCityTF: UITextField!
    @IBOutlet var GuardianCityTF: UITextField!
    @IBOutlet var GuardianPincodeTF: UITextField!
    //emergency contact
    @IBOutlet var ECView: UIView!
    @IBOutlet var FirstEC_NameTF: UITextField! //EC: Emergency Contact
    @IBOutlet var FirstEC_RelationshipTF: UITextField!
    @IBOutlet var FirstEC_NumberTF: UITextField!

    @IBOutlet var SecondEC_NameTF: UITextField! //EC: Emergency Contact
    @IBOutlet var SecondEC_RelationshipTF: UITextField!
    @IBOutlet var SecondEC_NumberTF: UITextField!
    //personal physician

    @IBOutlet var MIPView: UIView!
    @IBOutlet var PP_NameTF: UITextField! //PP: Personal Physician
    @IBOutlet var PP_NumberTF: UITextField!
    @IBOutlet var PP_PolicyTF: UITextField!
    @IBOutlet var PP_PolicyNumberTF: UITextField!
    //allergy
    @IBOutlet var AllergyRadio : [SKRadioButton]!
    //Textfield inside medical information
    @IBOutlet var FoodAllergyTF: UITextField!
    @IBOutlet var MedicinesAllergiesTF: UITextField!
    @IBOutlet var PlantsTF: UITextField!
    @IBOutlet var InsectsTF: UITextField!
    //medical condition
    @IBOutlet var DiebetesTF: UITextField!
    @IBOutlet var CancerTF: UITextField!
    @IBOutlet var HeartDiseaseTF: UITextField!
    @IBOutlet var LeukemiaTF: UITextField!
    @IBOutlet var otherAllergyTF: UITextField!
    @IBOutlet var RestrictionTF: UITextField!
    @IBOutlet var RecentMedicalConditionTF: UITextField!//recent medical condition
    //
    //YES AND NO
    @IBOutlet var FoodRadio: [SKRadioButton]!
    @IBOutlet var MedicinesRadio: [SKRadioButton]!
    @IBOutlet var PlantsRadio: [SKRadioButton]!
    @IBOutlet var InsectsRadio: [SKRadioButton]!
    
    @IBOutlet var DiebetesRadio: [SKRadioButton]!
    @IBOutlet var CancerRadio: [SKRadioButton]!
    @IBOutlet var HeartDiseaseRadio: [SKRadioButton]!
    @IBOutlet var LeukemiaRadio: [SKRadioButton]!
    @IBOutlet var otherAllergyRadio: [SKRadioButton]!
    @IBOutlet var RestrictionRadio: [SKRadioButton]!
    @IBOutlet var RecentMedicalConditionRadio: [SKRadioButton]!
    //
    //Heights of textfield
    @IBOutlet var HeightOfFoodTF: NSLayoutConstraint!
    @IBOutlet var HeightOfMedicinesTF: NSLayoutConstraint!
    @IBOutlet var HeightOfPlantsTF: NSLayoutConstraint!
    @IBOutlet var HeightOfInsectsTF: NSLayoutConstraint!
    
    @IBOutlet var HeightOfDiebetesTF: NSLayoutConstraint!
    @IBOutlet var HeightOfCancerTF: NSLayoutConstraint!
    @IBOutlet var HeightOfHeartDiseaseTF: NSLayoutConstraint!
    @IBOutlet var HeightOfLeukemiaTF: NSLayoutConstraint!
    @IBOutlet var HeightOfotherAllergyTF: NSLayoutConstraint!
    @IBOutlet var HeightOfRestrictionTF: NSLayoutConstraint!
    @IBOutlet var HeightOfRecentMedicalConditionTF: NSLayoutConstraint!
    @IBOutlet var bottomContraint: NSLayoutConstraint!
    //
    @IBOutlet var allergyView: UIView!
    @IBOutlet var HeightOFallergyView: NSLayoutConstraint!
    
    @IBOutlet var LastDoneView: UIView!
    @IBOutlet var selectdateRadio: [UIButton]!
    @IBOutlet var cv: UIView!

    @IBOutlet var Save: UIButton!
    
    var edit = Bool(false)
    var selectedGender = "1"
    var HaveAllergy = "0"
    var selectedfood = "0"
    var selectedmedicine = "0"
    var selectedplants = "0"
    var selectedinsects = "0"
    var selectedother = "0"
    var selectedbp = "0"
    var selecteddiebetes = "0"
    var selectedcancer = "0"
    var selectedheartdisease = "0"
    var selectedleukemia = "0"
    var selectedrestriction = "0"
    var selectedcondition = "0"
    
    var base64image = ""
    let user = User()
    let guardian = Guardian()
    let emergencyContact = EmergencyContact()
    let medical = Medical()
    let lastVaccinationDone = LastVaccinationDone()
    let dateview = UIDatePicker()
    let appdel = UIApplication.shared.delegate as! AppDelegate
    
    var attachmentArray : NSMutableArray = []
    var APC = DBAttachmentPickerController()
    
    @IBOutlet var cancel: UIButton!
    @IBOutlet var fscalendar: FSCalendar!
    var back = true
    
    var selected = ""
    var datestr1 = ""
    var datestr2 = ""
    var datestr3 = ""
    var datestr4 = ""
    var dict = NSDictionary()
    let bearertoken = UserDefaults.standard.string(forKey: "bearertoken")
    var urlpath = ""
    var imagename = ""
    var pdfurl = URL(string: "NF")!
    var editbutton = UIBarButtonItem()
    let pickerview = UIPickerView()
    let bloodtypes = ["A+","A-","B-","B+","AB+","AB-","O+","O-"]
   
}
extension ProfilePageViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        Utilized()
        Save.addTarget(self, action: #selector(SaveAction), for: .touchUpInside)
        
        fscalendar.delegate = self
        fscalendar.dataSource = self
        
        MobileNumberTF.delegate = self
        GuardianMobileNumberTF.delegate = self
        PP_NumberTF.delegate = self
        FirstEC_NumberTF.delegate = self
        SecondEC_NumberTF.delegate = self
        
        pincodeTF.delegate = self
        GuardianPincodeTF.delegate = self

        cancel.addTarget(self, action: #selector(cancelAction), for: .touchUpInside)
        fscalendar.backgroundColor = UIColor.groupTableViewBackground
        addProfileImage.addTarget(self, action: #selector(addAttachmentAction), for: .touchUpInside)
        editbutton = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(EditableandNonEditable))
        self.navigationItem.rightBarButtonItem = editbutton
        self.alltextfield(bool: false)
        self.navigationItem.hidesBackButton = true
        let back = UIBarButtonItem(image: #imageLiteral(resourceName: "left-arrow.png"), style: .plain, target: self, action: #selector(handleBack))
        back.imageInsets = UIEdgeInsets(top: 3, left: -20, bottom: -7, right: -10)
        self.navigationItem.leftBarButtonItem = back
        // Do any additional setup after loading the view.
    }
    @objc func handleBack(){
        if back == true {
            self.navigationController?.popViewController(animated: true)
        } else {
            Utilities.shared.alertview(title: "Alert", msg: "Do you want to go back,Your data will be lost", dismisstitle: "Back", mutlipleButtonAdd: { (alert) in
                alert.addButton("Update", font: UIFont.boldSystemFont(ofSize: 20), color: UIColor.orange, titleColor: UIColor.white) { (action) in
                    if self.validateProfile() == false{
                        
                    }
                    else {
                        self.sendData()
                    }
                    alert.dismissAlertView()
                }
            }, dismissAction: {
                self.navigationController?.popViewController(animated: true)
            })
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        NetworkManager.isReachable { _ in
            self.fetchProfileDatail()
        }
        NetworkManager.sharedInstance.reachability.whenReachable = { _ in
            self.fetchProfileDatail()
        }
        NetworkManager.isUnreachable { _ in
            self.SetupInterface()
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(reload), name: NSNotification.Name("reload"), object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
       customizePickerViewandDateView()
    }
}
extension ProfilePageViewController {//validation
    func toast(msg: String){
        self.view.showToast(msg, position: .bottom, popTime: 3, dismissOnTap: true)
    }
    @objc func SaveAction(){
        if validateProfile() == false{
            
        }
        else {
            sendData()
        }
    }
    func validateProfile()->Bool{
        if self.MobileNumberTF.text != "" && self.MobileNumberTF.text?.count != 10 {
            self.toast(msg: "Enter Valid Mobile Number")
            return false
        }
        else if self.emailTF.text != "" && self.emailTF.text?.isValidEmail() == false {
            self.toast(msg: "Enter Valid Email Address")
            return false
        }
        else if self.GuardianMobileNumberTF.text != "" && self.GuardianMobileNumberTF.text?.count != 10 {
            self.toast(msg: "Enter Valid Guardian Mobile Number")
            return false
        }
        else if self.GuardianMobileNumberTF.text != "" && self.GuardianMobileNumberTF.text?.first == "0" {
            self.toast(msg: "Guardian Mobile Number Should Not Start With 0")
            return false
        }
        else if self.PP_NumberTF.text != "" && self.PP_NumberTF.text?.count != 10 {
            self.toast(msg: "Enter Valid Personal Physician Mobile Number")
            return false
        }
        else if self.PP_NumberTF.text != "" && self.PP_NumberTF.text?.first == "0" {
            self.toast(msg: "Personal Physician Mobile Number Should Not Start With 0")
            return false
        }
        else if self.FirstEC_NumberTF.text != "" && self.FirstEC_NumberTF.text?.count != 10 {
            self.toast(msg: "Enter Valid Primary Emergency Mobile Number")
            return false
        }
        else if self.FirstEC_NumberTF.text != "" && self.FirstEC_NumberTF.text?.first == "0" {
            self.toast(msg: "Primary Emergency Mobile Number Should Not Start With 0")
            return false
        }
        else if self.SecondEC_NumberTF.text != "" && self.SecondEC_NumberTF.text?.count != 10 {
            self.toast(msg: "Enter Valid Secondary Emergency Mobile Number")
            return false
        }
        else if self.SecondEC_NumberTF.text != "" && self.SecondEC_NumberTF.text?.first == "0" {
            self.toast(msg: "Secondary Emergency Mobile Number Should Not Start With 0")
            return false
        }
        else if self.pincodeTF.text != "" && (self.pincodeTF.text?.count)! > 6 {
            self.toast(msg: "Enter Valid Pincode")
            return false
        }
        else if self.GuardianPincodeTF.text != "" && (self.GuardianPincodeTF.text?.count)! > 6 {
            self.toast(msg: "Enter Valid Guardian Pincode")
            return false
        }
        else {
            return true
        }
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let limitLength = 10
        let pincodelimit = 6

        if MobileNumberTF.isFirstResponder {
            if let text = MobileNumberTF.text{
                let newLength = text.count + string.count - range.length
                return newLength <= limitLength
            }
        }
        else if GuardianMobileNumberTF.isFirstResponder {
            if let text = GuardianMobileNumberTF.text{
                let newLength = text.count + string.count - range.length
                return newLength <= limitLength
            }
        }
        else if PP_NumberTF.isFirstResponder {
            if let text = PP_NumberTF.text{
                let newLength = text.count + string.count - range.length
                return newLength <= limitLength
            }
        }
        else if FirstEC_NumberTF.isFirstResponder {
            if let text = FirstEC_NumberTF.text{
                let newLength = text.count + string.count - range.length
                return newLength <= limitLength
            }
        }
        else if SecondEC_NumberTF.isFirstResponder {
            if let text = SecondEC_NumberTF.text{
                let newLength = text.count + string.count - range.length
                return newLength <= limitLength
            }
        }
        else if pincodeTF.isFirstResponder {
            if let text = pincodeTF.text{
                let newLength = text.count + string.count - range.length
                return newLength <= pincodelimit
            }
        }
        else if GuardianPincodeTF.isFirstResponder {
            if let text = GuardianPincodeTF.text{
                let newLength = text.count + string.count - range.length
                return newLength <= pincodelimit
            }
        }
        else if GuardianPincodeTF.isFirstResponder {
            if let text = GuardianPincodeTF.text{
                let newLength = text.count + string.count - range.length
                return newLength <= pincodelimit
            }
        }
        return true
    }
}
extension ProfilePageViewController {
    
    func customizePickerViewandDateView(){
        self.pickerview.reloadAllComponents()
        self.pickerview.reloadInputViews()
        self.pickerview.dataSource = self
        self.pickerview.delegate = self
        self.pickerview.backgroundColor = UIColor.lightText
        
        BloodGroupTF.delegate = self
        BloodGroupTF.inputView = pickerview
        pickerview.backgroundColor = UIColor.white
        
        DateOfBirthTF.delegate = self
        DateOfBirthTF.inputView = dateview
        dateview.datePickerMode = .date
        dateview.maximumDate = Date()
        dateview.backgroundColor = UIColor.white
        dateview.setValue(UIColor.black, forKeyPath: "textColor")
        dateview.setDate(Date(), animated: true)
        dateview.addTarget(self, action: #selector(setdate), for: .valueChanged)
    }
    @objc func EditableandNonEditable(){
        NetworkManager.isReachable { _ in
            self.alltextfield(bool: true)

            if self.edit == false{
                self.edit = true
                self.editbutton.title = ""
                self.alltextfield(bool: true)
                self.Save.alpha = 1.0
                self.back = false
            } else {
                self.edit = false
                self.editbutton.title = "Edit"
               // self.alltextfield(bool: false)
            }
        }
        NetworkManager.isUnreachable { _ in
            Alert.shared.basicalert(vc: self, title: "You Cannot Edit Detail Without Internet Connection", msg: "Go to Setting and Turn on Mobile Data or Wifi Connection")
        }
    }
    func editAllTextfield(bool: Bool,objects: [SkyFloatingLabelTextField]){
        DispatchQueue.main.async {
            for object in objects{
                object.isUserInteractionEnabled = bool
            }
        }
    }
    func alltextfield(bool: Bool){
        let alltf = [NameTF,DateOfBirthTF,BloodGroupTF,emailTF,Address1TF,Address2TF,SubCityTF,CityTF,pincodeTF,GuardianNameTF,GuardianMobileNumberTF,GuardianAddress1TF,GuardianAddress2TF,GuardianSubCityTF,GuardianCityTF,GuardianPincodeTF,FirstEC_NameTF,FirstEC_RelationshipTF,FirstEC_NumberTF,SecondEC_NameTF,SecondEC_RelationshipTF,SecondEC_NumberTF,PP_NameTF,PP_NumberTF,PP_PolicyTF,PP_PolicyNumberTF,FoodAllergyTF,MedicinesAllergiesTF,PlantsTF,InsectsTF,otherAllergyTF,DiebetesTF,CancerTF,HeartDiseaseTF,LeukemiaTF,RestrictionTF,RecentMedicalConditionTF]
        self.PatientTF.isUserInteractionEnabled = false
        self.MobileNumberTF.isUserInteractionEnabled = false

        self.addProfileImage.isUserInteractionEnabled = bool
        
        self.GenderRadio[0].isUserInteractionEnabled = bool
        self.GenderRadio[1].isUserInteractionEnabled = bool
        self.GenderRadio[2].isUserInteractionEnabled = bool
        
        self.AllergyRadio[0].isUserInteractionEnabled = bool
        self.AllergyRadio[1].isUserInteractionEnabled = bool
        
        self.FoodRadio[0].isUserInteractionEnabled = bool
        self.FoodRadio[1].isUserInteractionEnabled = bool
        
        self.MedicinesRadio[0].isUserInteractionEnabled = bool
        self.MedicinesRadio[1].isUserInteractionEnabled = bool
        
        self.PlantsRadio[0].isUserInteractionEnabled = bool
        self.PlantsRadio[1].isUserInteractionEnabled = bool
        
        self.InsectsRadio[0].isUserInteractionEnabled = bool
        self.InsectsRadio[1].isUserInteractionEnabled = bool
        
        self.otherAllergyRadio[0].isUserInteractionEnabled = bool
        self.otherAllergyRadio[1].isUserInteractionEnabled = bool
        
        self.DiebetesRadio[0].isUserInteractionEnabled = bool
        self.DiebetesRadio[1].isUserInteractionEnabled = bool
        
        self.CancerRadio[0].isUserInteractionEnabled = bool
        self.CancerRadio[1].isUserInteractionEnabled = bool
        
        self.HeartDiseaseRadio[0].isUserInteractionEnabled = bool
        self.HeartDiseaseRadio[1].isUserInteractionEnabled = bool
        
        self.LeukemiaRadio[0].isUserInteractionEnabled = bool
        self.LeukemiaRadio[1].isUserInteractionEnabled = bool
        
        self.RestrictionRadio[0].isUserInteractionEnabled = bool
        self.RestrictionRadio[1].isUserInteractionEnabled = bool
        
        self.RecentMedicalConditionRadio[0].isUserInteractionEnabled = bool
        self.RecentMedicalConditionRadio[1].isUserInteractionEnabled = bool
        
        self.selectdateRadio[0].isUserInteractionEnabled = bool
        self.selectdateRadio[1].isUserInteractionEnabled = bool
        self.selectdateRadio[2].isUserInteractionEnabled = bool
        self.selectdateRadio[3].isUserInteractionEnabled = bool
        
        self.Save.isUserInteractionEnabled = bool
        self.Save.alpha = 0.5
        self.editAllTextfield(bool: bool, objects: alltf as! [SkyFloatingLabelTextField])
    }
    @objc func addAttachmentAction(){
        PHPhotoLibrary.requestAuthorization { (status) in
            if status == PHAuthorizationStatus.notDetermined {
                self.addAttachmentAction()
            } else {
                self.APC = DBAttachmentPickerController(finishPicking: { (attachmentArray) in
                    attachmentArray[0].loadOriginalImage(completion: { (image) in
                        let timestamp = Date().toMillis()
                        image?.accessibilityIdentifier = String(describing: timestamp)
                        self.imagename = "\(String(describing: timestamp!)).jpg"
                        print(self.imagename)
                        
                        self.imagesPicView.image = image
                    })
                    
                }, cancel: nil)
                
                self.APC.mediaType = [.image]
                self.APC.allowsMultipleSelection = false
                self.APC.allowsSelectionFromOtherApps = false
                self.APC.present(on: self)
            }
        }
    }
    
    @objc func reload(){
        UIView.animate(withDuration: 0.1) {
            self.cv.isHidden = true
            self.cv.alpha = 0.0
        }
    }
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let datestr = formatter.string(from: date)
        
        if selected == "1"{
            self.datestr1 = datestr
            self.selectdateRadio[0].setTitle(self.datestr1, for: .normal)
        }
        else if selected == "2"{
            self.datestr2 = datestr
            self.selectdateRadio[1].setTitle(self.datestr2, for: .normal)
        }
        else if selected == "3"{
            self.datestr3 = datestr
            self.selectdateRadio[2].setTitle(self.datestr3, for: .normal)
        }
        else if selected == "4"{
            self.datestr4 = datestr
            self.selectdateRadio[3].setTitle(self.datestr4, for: .normal)
        }
        NotificationCenter.default.post(name: NSNotification.Name("reload"), object: self)
    }
    func maximumDate(for calendar: FSCalendar) -> Date {
        return Date()
    }
    @objc func cancelAction(){
        NotificationCenter.default.post(name: NSNotification.Name("reload"), object: self)
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
            self.age.text = "Age: \(years) Y / \(months) M"
        }
    }

    func fetchProfileDatail(){
        Utilities.shared.ShowLoaderView(view: self.view, Message: "Please Wait...")
        ApiServices.shared.FetchGetDataFromUrl(vc: self, withOutBaseUrl: "patientprofile", parameter: "", bearertoken: bearertoken!, onSuccessCompletion: {
            do {
                print(ApiServices.shared.data)
                self.dict = try JSONSerialization.jsonObject(with: ApiServices.shared.data, options: .mutableContainers) as! NSDictionary
                let msg = self.dict.value(forKey: "msg") as? String ?? ""
                if msg == "success" {
                    if let data = self.dict.value(forKey: "data") as? NSDictionary {
                        print(data)
                        DispatchQueue.main.async {
                            let pp = data.value(forKey: "profile_picture") as? String ?? ""
                            if pp != ""{
                                let url = URL(string: "http://www.otgmart.com/medoc/medoc_doctor_api/uploads/\(pp)")!
                                print(url)
                                self.imagesPicView.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "man.png"), options: .continueInBackground, completed: nil)
                            }
                            else {
                                self.imagesPicView.image = #imageLiteral(resourceName: "man.png")
                            }
                            let name = data.value(forKey: "name") as? String ?? ""
                            self.NameTF.text = name
                            self.DateOfBirthTF.text = data.value(forKey: "dob") as? String ?? ""
                            UserDefaults.standard.set(pp, forKey: "profile_image")
                            UserDefaults.standard.set(name, forKey: "name")
                            UserDefaults.standard.synchronize()
                            if self.DateOfBirthTF.text == ""{
                                self.age.text = "Age"
                            } else {
                                let df = DateFormatter()
                                df.dateFormat = "yyyy-MM-dd"
                                let date = df.date(from: self.DateOfBirthTF.text!)
                                let calendar : NSCalendar = NSCalendar.current as NSCalendar
                                let ageComponents = calendar.components(.month, from: date!, to: Date() as Date, options: []).month
                                let years = ageComponents! / 12
                                let months = ageComponents! % 12
                                self.age.text = "Age: \(years) Y / \(months) M"
                            }
                            self.selectedGender = data.value(forKey: "gender") as? String ?? "1"
                            self.BloodGroupTF.text = data.value(forKey: "blood_group") as? String ?? ""
                            let email = data.value(forKey: "email") as? String ?? ""
                            self.emailTF.text = email
                            self.PatientTF.text = data.value(forKey: "patient_id") as? String ?? ""
                            
                            self.MobileNumberTF.text = data.value(forKey: "contact_no") as? String ?? ""
                            self.Address1TF.text = data.value(forKey: "address1") as? String ?? ""
                            self.Address2TF.text = data.value(forKey: "address2") as? String ?? ""
                            self.SubCityTF.text = data.value(forKey: "sub_city") as? String ?? ""
                            self.CityTF.text = data.value(forKey: "city") as? String ?? ""
                            self.pincodeTF.text = data.value(forKey: "pincode") as? String ?? ""
                            //guardian
                            self.GuardianNameTF.text = data.value(forKey: "gaurdian_name") as? String ?? ""
                            self.GuardianMobileNumberTF.text = data.value(forKey: "gaurdian_contact") as? String ?? ""
                            self.GuardianAddress1TF.text = data.value(forKey: "gaurdian_address1") as? String ?? ""
                            self.GuardianAddress2TF.text = data.value(forKey: "gaurdian_address2") as? String ?? ""
                            self.GuardianSubCityTF.text = data.value(forKey: "gaurdian_subcity") as? String ?? ""
                            self.GuardianCityTF.text = data.value(forKey: "gaurdian_city") as? String ?? ""
                            self.GuardianPincodeTF.text = data.value(forKey: "gaurdian_pincode") as? String ?? ""
                            //ec1
                            self.FirstEC_NameTF.text = data.value(forKey: "emergency_contact_name1") as? String ?? ""
                            self.FirstEC_RelationshipTF.text = data.value(forKey: "emergency_contact_relation1") as? String ?? ""
                            self.FirstEC_NumberTF.text = data.value(forKey: "emergency_contact_number1") as? String ?? ""
                            //ec2
                            self.SecondEC_NameTF.text = data.value(forKey: "emergency_contact_name2") as? String ?? ""
                            self.SecondEC_RelationshipTF.text = data.value(forKey: "emergency_contact_relation2") as? String ?? ""
                            self.SecondEC_NumberTF.text = data.value(forKey: "emergency_contact_number2") as? String ?? ""
                            //pp
                            self.PP_NameTF.text = data.value(forKey: "personal_physician_name") as? String ?? ""
                            self.PP_NumberTF.text = data.value(forKey: "personal_physician_contact") as? String ?? ""
                            let p_policy = data.value(forKey: "p_policy") as? String ?? ""
                            if p_policy == "NF"{
                                self.PP_PolicyTF.text = ""
                            }
                            else {
                                self.PP_PolicyTF.text = p_policy
                            }
                            let p_policy_Number = data.value(forKey: "p_policy_number") as? String ?? ""
                            if p_policy_Number == "0"{
                                self.PP_PolicyNumberTF.text = ""
                            }
                            else {
                                self.PP_PolicyNumberTF.text = p_policy_Number
                            }
                            //allergy
                            self.HaveAllergy = data.value(forKey: "allergy") as? String ?? "0"
                            
                            self.selectedfood = data.value(forKey: "food_alergy") as? String ?? "0"
                            let food_allergy_details = data.value(forKey: "food_allergy_details") as? String ?? ""
                            if food_allergy_details == "NF"{
                                self.FoodAllergyTF.text = ""
                            } else {
                                self.FoodAllergyTF.text = food_allergy_details
                            }
                            
                            self.selectedmedicine = data.value(forKey: "medicine_alergy") as? String ?? "0"
                            let medicine_allergy_details = data.value(forKey: "medicine_allergy_details") as? String ?? ""
                            if medicine_allergy_details == "NF"{
                                self.MedicinesAllergiesTF.text = ""
                            } else {
                                self.MedicinesAllergiesTF.text = medicine_allergy_details
                            }
                            
                            self.selectedplants = data.value(forKey: "plants_allergy") as? String ?? "0"
                            let plants_allergy_details = data.value(forKey: "plants_allergy_details") as? String ?? ""
                            if plants_allergy_details == "NF"{
                                self.PlantsTF.text = ""
                            } else {
                                self.PlantsTF.text = plants_allergy_details
                            }
                            
                            self.selectedinsects = data.value(forKey: "insects_allergy") as? String ?? "0"
                            let insects_allergy_details = data.value(forKey: "insects_allergy_details") as? String ?? ""
                            if insects_allergy_details == "NF"{
                                self.InsectsTF.text = ""
                            } else {
                                self.InsectsTF.text = insects_allergy_details
                            }
                            
                            self.selectedother = data.value(forKey: "other_allergy") as? String ?? "0"
                            let other_allergy_details = data.value(forKey: "other_allergy_details") as? String ?? ""
                            if other_allergy_details == "NF"{
                                self.otherAllergyTF.text = ""
                            } else {
                                self.otherAllergyTF.text = other_allergy_details
                            }
                            //medical
                            self.selectedbp = data.value(forKey: "diabetes") as? String ?? "0"
                            
                            self.selecteddiebetes = data.value(forKey: "diabetes") as? String ?? "0"
                            let diabetes_details = data.value(forKey: "diabetes_details") as? String ?? ""
                            if diabetes_details == "NF"{
                                self.DiebetesTF.text = ""
                            } else {
                                self.DiebetesTF.text = diabetes_details
                            }
                            
                            self.selectedcancer = data.value(forKey: "cancer") as? String ?? "0"
                            let cancer = data.value(forKey: "diabetes_details") as? String ?? ""
                            if cancer == "NF"{
                                self.CancerTF.text = ""
                            } else {
                                self.CancerTF.text = cancer
                            }
                            
                            self.selectedheartdisease = data.value(forKey: "heart_desease") as? String ?? "0"
                            let heart_desease = data.value(forKey: "diabetes_details") as? String ?? ""
                            if heart_desease == "NF"{
                                self.HeartDiseaseTF.text = ""
                            } else {
                                self.HeartDiseaseTF.text = heart_desease
                            }
                            
                            self.selectedleukemia = data.value(forKey: "lukemia") as? String ?? "0"
                            let lukemia = data.value(forKey: "diabetes_details") as? String ?? ""
                            if lukemia == "NF"{
                                self.LeukemiaTF.text = ""
                            } else {
                                self.LeukemiaTF.text = lukemia
                            }
                            
                            self.selectedrestriction = data.value(forKey: "physical_activity_restriction") as? String ?? "0"
                            let physical_activity_restriction_details = data.value(forKey: "physical_activity_restriction_details") as? String ?? ""
                            if physical_activity_restriction_details == "NF"{
                                self.RestrictionTF.text = ""
                            } else {
                                self.RestrictionTF.text = physical_activity_restriction_details
                            }
                            self.selectedcondition = data.value(forKey: "recent_medical_condition") as? String ?? "0"

                            let recent_medical_condition_details = data.value(forKey: "recent_medical_condition_details") as? String ?? ""
                            if recent_medical_condition_details == "NF"{
                                self.RecentMedicalConditionTF.text = ""
                            } else {
                                self.RecentMedicalConditionTF.text = recent_medical_condition_details
                            }
                            //last vaccination done
                            let placeholder = "Click to select date"
                            let data1 = data.value(forKey: "last_tetanus_date") as? String ?? placeholder
                            self.selectdateRadio[0].setTitle(data1, for: .normal)
                            
                            let data2 = data.value(forKey: "last_polio_date") as? String ?? placeholder
                            self.selectdateRadio[1].setTitle(data2, for: .normal)

                            let data3 = data.value(forKey: "last_diptheria_date") as? String ?? placeholder
                            self.selectdateRadio[2].setTitle(data3, for: .normal)

                            let data4 = data.value(forKey: "last_mumps_date") as? String ?? placeholder
                            self.selectdateRadio[3].setTitle(data4, for: .normal)
                            DispatchQueue.main.async {
                                // self.retrivedata()
                                self.SetupInterface()
                            }
                        }
                    }
                }
            } catch {
                print("catch")
            }
        }) { () -> (Dictionary<String, Any>) in
            [:]
        }
        Utilities.shared.RemoveLoaderView()
    }
    func sendData()
    {
        self.back = true
        var param : [String: Any]
        param =
            [
                "name": self.NameTF.text!,
                "email": self.emailTF.text!,
                "profile_picture":self.imagename,
                "contact_no": self.MobileNumberTF.text!,
                "alt_contact_no": "",
                "gender": self.selectedGender,
                "dob": self.DateOfBirthTF.text!,
                "blood_group": self.BloodGroupTF.text!,
                "height": "",
                "address1": self.Address1TF.text!,
                "address2": self.Address2TF.text!,
                "city": self.CityTF.text!,
                "sub_city": self.SubCityTF.text!,
                "pincode": self.pincodeTF.text!,
                "gaurdian_name": self.GuardianNameTF.text!,
                "gaurdian_contact": self.GuardianMobileNumberTF.text!,
                "gaurdian_address1": self.GuardianAddress1TF.text!,
                "gaurdian_address2": self.GuardianAddress2TF.text!,
                "gaurdian_city": self.GuardianCityTF.text!,
                "gaurdian_subcity": self.GuardianSubCityTF.text!,
                "gaurdian_pincode": self.GuardianPincodeTF.text!,
                "emergency_contact_name1": self.FirstEC_NameTF.text!,
                "emergency_contact_relation1": self.FirstEC_RelationshipTF.text!,
                "emergency_contact_number1": self.FirstEC_NumberTF.text!,
                "emergency_contact_name2": self.SecondEC_NameTF.text!,
                "emergency_contact_relation2": self.SecondEC_RelationshipTF.text!,
                "emergency_contact_number2": self.SecondEC_NumberTF.text!,
                "personal_physician_name": self.PP_NameTF.text!,
                "personal_physician_contact": self.PP_NumberTF.text!,
                "p_policy": self.PP_PolicyTF.text!,
                "p_policy_number": self.PP_PolicyNumberTF.text!,
                "allergy": self.HaveAllergy,
                "food_alergy": self.selectedfood,
                "food_allergy_details": self.FoodAllergyTF.text!,
                "medicine_alergy": self.selectedmedicine,
                "medicine_allergy_details": self.MedicinesAllergiesTF.text!,
                "plants_allergy": self.selectedplants,
                "plants_allergy_details": self.PlantsTF.text!,
                "insects_allergy": self.selectedinsects,
                "insects_allergy_details": self.InsectsTF.text!,
                "other_allergy": self.selectedother,
                "other_allergy_details": self.otherAllergyTF.text!,
                "blood_pressure": self.selectedbp,
                "diabetes": self.selecteddiebetes,
                "diabetes_details": self.DiebetesTF.text!,
                "cancer": self.selectedcancer,
                "heart_desease": self.selectedheartdisease,
                "lukemia": self.selectedleukemia,
                "physical_activity_restriction": self.selectedrestriction,
                "physical_activity_restriction_details": self.RestrictionTF.text!,
                "recent_medical_condition": self.selectedcondition,
                "recent_medical_condition_details": self.RecentMedicalConditionTF.text!
        ]
        let pl = "Click to select date"
        if self.selectdateRadio[0].titleLabel?.text != pl{
            param["last_tetanus_date"] = self.selectdateRadio[0].titleLabel?.text!
        }
        if self.selectdateRadio[1].titleLabel?.text! != pl{
            param["last_polio_date"] = self.selectdateRadio[1].titleLabel?.text!
        }
        if self.selectdateRadio[2].titleLabel?.text != pl{
            param["last_diptheria_date"] = self.selectdateRadio[2].titleLabel?.text!
        }
        if self.selectdateRadio[3].titleLabel?.text != pl{
            param["last_mumps_date"] = self.selectdateRadio[3].titleLabel?.text!
        }
        print("param: \(param)")
        Utilities.shared.ShowLoaderView(view: self.view, Message: "Updating data")
        
        ApiServices.shared.FetchPostDataFromUrl(vc: self, withOutBaseUrl: "patienteditprofile", bearertoken: bearertoken!, parameter: "", onSuccessCompletion: {
            do {
                let json = try JSONSerialization.jsonObject(with: ApiServices.shared.data, options: .mutableContainers) as! NSDictionary
                if let msg = json.value(forKey: "msg") as? String {
                    DispatchQueue.main.async {
                        if msg == "success"{
                            if self.imagename != "" {
                                UserDefaults.standard.set(self.imagename, forKey: "profile_image")
                            }
                            UserDefaults.standard.set(self.NameTF.text!, forKey: "name")
                            UserDefaults.standard.synchronize()
                            self.uploadimage()
                            self.view.showToast("Update Profile Details Successfully", position: .bottom, popTime: 3.0, dismissOnTap: true)
                            self.navigationController?.popViewController(animated: true)
                        }
                    }
                }
                if let error = json.value(forKey: "error") as? NSDictionary{
                    DispatchQueue.main.async {
                        if let email = error.value(forKey: "email") as? [String]{
                            self.view.showToast(email.joined(), position: .bottom, popTime: 5, dismissOnTap: true)
                        }
                        else if let contact_no = error.value(forKey: "contact_no") as? [String]{
                            self.view.showToast(contact_no.joined(), position: .bottom, popTime: 5, dismissOnTap: true)
                        }
                        else if let name = error.value(forKey: "name") as? [String]{
                            self.view.showToast(name.joined(), position: .bottom, popTime: 5, dismissOnTap: true)
                        }
                    }
                }
                
                print("json-\(json)")
            } catch {
                print("catch")
            }
        }) { () -> (Dictionary<String, Any>) in
            param
        }
        Utilities.shared.RemoveLoaderView()
    }
    func uploadimage(){
        ApiServices.shared.FetchMultiformDataWithImageFromUrl(vc: self, withOutBaseUrl: "add_files", parameter: nil, bearertoken: bearertoken!, image: self.imagesPicView.image!, filename: self.imagename, filePathKey: "images[]", pdfurl: pdfurl, onSuccessCompletion: {
            do {
                let json = try JSONSerialization.jsonObject(with: ApiServices.shared.data, options: .mutableContainers) as! NSDictionary
                
                print("image-\(json)")
            } catch {
                print("image catch")
            }
        }) { () -> (Dictionary<String, Any>) in
            [:]
        }
    }
    
}

extension ProfilePageViewController {//setupinterface
    
    func minimizeHeight(objects: [UIView],heightContantOutlet: [NSLayoutConstraint]){
        for obj in objects{
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                obj.isHidden = true
            }
        }
        for obj in heightContantOutlet{
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                obj.constant = 0
            }
        }
    }
    func maximizeHeight(objects: [UIView],heightContantOutlet: [NSLayoutConstraint]){
        for obj in objects{
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                obj.isHidden = false
            }
        }
        for obj in heightContantOutlet{
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                obj.constant = 40
            }
        }
    }
    func Utilized(){
        Utilities.shared.cornerRadius(objects: [imagesPicView], number: imagesPicView.frame.width / 2)
        Utilities.shared.cornerRadius(objects: [Save], number: 10.0)
        Utilities.shared.borderRadius(objects: [Save], color: UIColor.white)
        
    }
    @IBAction func ClicktoSelectDate(sender: UIButton){
        UIView.animate(withDuration: 0.1) {
            self.cv.isHidden = false
            self.cv.alpha = 1.0
        }
        if sender.tag == 1{
            selected = "1"
        }
        else if sender.tag == 2{
            selected = "2"
        }
        else if sender.tag == 3{
            selected = "3"
        }
        else if sender.tag == 4{
            selected = "4"
        }
    }
    func SetupInterface(){

        DispatchQueue.main.async {
            self.GenderRadio[Int(self.selectedGender)! - 1].isSelected = true
            
            if self.HaveAllergy == "0"{
                self.AllergyRadio[1].isSelected = true
                self.hideAllergy()
            } else if self.HaveAllergy == "1" {
                self.showAllergy()
                self.AllergyRadio[0].isSelected = true
            }
            self.HeightOFallergyView.constant = 0
            self.bottomContraint.isActive = false
            self.allergyView.isHidden = true
        }
        //4CAF50
        minimize()
        
        yesORnoActionInsideAllergyView()
    }
    func minimize(){
        minimizeHeight(objects: [FoodAllergyTF,MedicinesAllergiesTF,PlantsTF,InsectsTF,DiebetesTF,CancerTF,HeartDiseaseTF,LeukemiaTF,otherAllergyTF,RestrictionTF],heightContantOutlet:  [HeightOfFoodTF,HeightOfMedicinesTF,HeightOfPlantsTF,HeightOfInsectsTF,HeightOfDiebetesTF,HeightOfCancerTF,HeightOfHeartDiseaseTF,HeightOfLeukemiaTF,HeightOfotherAllergyTF,HeightOfRestrictionTF])
    }
    @IBAction func AllergyRadioAction(sender: SKRadioButton){
        self.AllergyRadio.forEach { (button) in
            button.isSelected = false
        }
        sender.isSelected = true
        if sender.tag == 3{//yes
            showAllergy()
        }
        else if sender.tag == 4{//no
            hideAllergy()
        }
    }
    func showAllergy(){
        HaveAllergy = "1"
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.1, animations: {
                self.allergyView.isHidden = false
                self.HeightOFallergyView.constant = 227
                self.allergyView.alpha = 1
                self.bottomContraint.isActive = true
                self.view.layoutIfNeeded()
            })
        }
    }
    func hideAllergy(){
        HaveAllergy = "0"
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.1, animations: {
                self.allergyView.isHidden = true
                self.HeightOFallergyView.constant = 0
                self.allergyView.alpha = 0
                self.bottomContraint.isActive = false
                self.view.layoutIfNeeded()
            })
        }
    }
    func yesORnoActionInsideAllergyView(){
        if HaveAllergy == "0"{
            hideAllergy()
        }
        else if HaveAllergy == "1"{
            showAllergy()
        }
        
        FoodRadio[Int(selectedfood)!].isSelected = true
        if selectedfood == "1"{
            FoodRadio[0].isSelected = false
            maximizeHeight(objects: [FoodAllergyTF], heightContantOutlet: [HeightOfFoodTF])
        } else if selectedfood == "0"{
            FoodRadio[1].isSelected = false
            minimizeHeight(objects: [FoodAllergyTF], heightContantOutlet: [HeightOfFoodTF])
        }
        
        MedicinesRadio[Int(selectedmedicine)!].isSelected = true
        if selectedmedicine == "1"{
            MedicinesRadio[0].isSelected = false
            maximizeHeight(objects: [MedicinesAllergiesTF], heightContantOutlet: [HeightOfMedicinesTF])
        } else if selectedmedicine == "0"{
            MedicinesRadio[1].isSelected = false
            minimizeHeight(objects: [MedicinesAllergiesTF], heightContantOutlet: [HeightOfMedicinesTF])
        }
        
        PlantsRadio[Int(selectedplants)!].isSelected = true
        if selectedplants == "1"{
            PlantsRadio[0].isSelected = false
            maximizeHeight(objects: [PlantsTF], heightContantOutlet: [HeightOfPlantsTF])
        } else if selectedplants == "0"{
            PlantsRadio[1].isSelected = false
            minimizeHeight(objects: [PlantsTF], heightContantOutlet: [HeightOfPlantsTF])
        }
        
        InsectsRadio[Int(selectedinsects)!].isSelected = true
        if selectedinsects == "1"{
            InsectsRadio[0].isSelected = false
            maximizeHeight(objects: [InsectsTF], heightContantOutlet: [HeightOfInsectsTF])
        } else if selectedinsects == "0"{
            InsectsRadio[1].isSelected = false
            minimizeHeight(objects: [InsectsTF], heightContantOutlet: [HeightOfInsectsTF])
        }
        
        otherAllergyRadio[Int(selectedother)!].isSelected = true
        if selectedother == "1"{
            otherAllergyRadio[0].isSelected = false
            maximizeHeight(objects: [otherAllergyTF], heightContantOutlet: [HeightOfotherAllergyTF])
        } else if selectedother == "0"{
            otherAllergyRadio[1].isSelected = false
            minimizeHeight(objects: [otherAllergyTF], heightContantOutlet: [HeightOfotherAllergyTF])
        }
        DiebetesRadio[Int(selecteddiebetes)!].isSelected = true
        if selecteddiebetes == "1"{
            DiebetesRadio[0].isSelected = false
            maximizeHeight(objects: [DiebetesTF], heightContantOutlet: [HeightOfDiebetesTF])
        } else if selecteddiebetes == "0"{
            DiebetesRadio[1].isSelected = false
            minimizeHeight(objects: [DiebetesTF], heightContantOutlet: [HeightOfDiebetesTF])
        }
        
        CancerRadio[Int(selectedcancer)!].isSelected = true
        if selectedcancer == "1"{
            CancerRadio[0].isSelected = false
          //  maximizeHeight(objects: [CancerTF], heightContantOutlet: [HeightOfCancerTF])
        } else if selectedcancer == "0"{
            CancerRadio[1].isSelected = false
          //  minimizeHeight(objects: [CancerTF], heightContantOutlet: [HeightOfCancerTF])
        }
        
        HeartDiseaseRadio[Int(selectedheartdisease)!].isSelected = true
        if selectedheartdisease == "1"{
            HeartDiseaseRadio[0].isSelected = false
           // maximizeHeight(objects: [HeartDiseaseTF], heightContantOutlet: [HeightOfHeartDiseaseTF])
        } else if selectedheartdisease == "0"{
            HeartDiseaseRadio[1].isSelected = false
           // minimizeHeight(objects: [HeartDiseaseTF], heightContantOutlet: [HeightOfHeartDiseaseTF])
        }
        
        LeukemiaRadio[Int(selectedleukemia)!].isSelected = true
        if selectedleukemia == "1"{
            LeukemiaRadio[0].isSelected = false
         //   maximizeHeight(objects: [LeukemiaTF], heightContantOutlet: [HeightOfLeukemiaTF])
        } else if selectedleukemia == "0"{
            LeukemiaRadio[1].isSelected = false
           // minimizeHeight(objects: [LeukemiaTF], heightContantOutlet: [HeightOfLeukemiaTF])
        }
        
        RestrictionRadio[Int(selectedrestriction)!].isSelected = true
        if selectedrestriction == "1"{
            RestrictionRadio[0].isSelected = false
            maximizeHeight(objects: [RestrictionTF], heightContantOutlet: [HeightOfRestrictionTF])
        } else if selectedrestriction == "0"{
            RestrictionRadio[1].isSelected = false
            minimizeHeight(objects: [RestrictionTF], heightContantOutlet: [HeightOfRestrictionTF])
        }
        
        if self.selectedcondition == "0"{
            RecentMedicalConditionRadio[1].isSelected = true
            minimizeHeight(objects: [RecentMedicalConditionTF], heightContantOutlet: [HeightOfRecentMedicalConditionTF])
        } else if self.selectedcondition == "1" {
            RecentMedicalConditionRadio[0].isSelected = true
            maximizeHeight(objects: [RecentMedicalConditionTF], heightContantOutlet: [HeightOfRecentMedicalConditionTF])
        }
    }
   
}
extension ProfilePageViewController { //button action
    @IBAction func GenderRadioAction(sender: SKRadioButton){
        self.GenderRadio.forEach { (button) in
            button.isSelected = false
        }
        sender.isSelected = true
        if sender.tag == 5{
            selectedGender = "1"
        }
        else if sender.tag == 6{
            selectedGender = "2"
        }
        else if sender.tag == 7{
            selectedGender = "3"
        }
    }
    @IBAction func FoodYesOrNo(sender: SKRadioButton){
        self.FoodRadio.forEach { (button) in
            button.isSelected = false
        }
        sender.isSelected = true
        if sender.tag == 11 {
            self.selectedfood = String(1)
            maximizeHeight(objects: [FoodAllergyTF], heightContantOutlet: [HeightOfFoodTF])
        }
        else if sender.tag == 12 {
            self.selectedfood = String(0)
            minimizeHeight(objects: [FoodAllergyTF], heightContantOutlet: [HeightOfFoodTF])
        }
    }
    @IBAction func MedicineYesOrNo(sender: SKRadioButton){
        self.MedicinesRadio.forEach { (button) in
            button.isSelected = false
        }
        sender.isSelected = true
        if sender.tag == 13 {
            self.selectedmedicine = String(1)
            maximizeHeight(objects: [MedicinesAllergiesTF], heightContantOutlet: [HeightOfMedicinesTF])
        }
        else if sender.tag == 14 {
            self.selectedmedicine = String(0)
            minimizeHeight(objects: [MedicinesAllergiesTF], heightContantOutlet: [HeightOfMedicinesTF])
        }
    }
    @IBAction func PlantsYesOrNo(sender: SKRadioButton){
        self.PlantsRadio.forEach { (button) in
            button.isSelected = false
        }
        sender.isSelected = true
        if sender.tag == 15 {
            self.selectedplants = String(1)
            maximizeHeight(objects: [PlantsTF], heightContantOutlet: [HeightOfPlantsTF])
        }
        else if sender.tag == 16 {
            self.selectedplants = String(0)
            minimizeHeight(objects: [PlantsTF], heightContantOutlet: [HeightOfPlantsTF])
        }
    }
    @IBAction func InsectsYesOrNo(sender: SKRadioButton){
        self.InsectsRadio.forEach { (button) in
            button.isSelected = false
        }
        sender.isSelected = true
        if sender.tag == 17 {
            self.selectedinsects = String(1)
            maximizeHeight(objects: [InsectsTF], heightContantOutlet: [HeightOfInsectsTF])
        }
        else if sender.tag == 18 {
            self.selectedinsects = String(0)
            minimizeHeight(objects: [InsectsTF], heightContantOutlet: [HeightOfInsectsTF])
        }
    }
    @IBAction func DiebetesYesOrNo(sender: SKRadioButton){
        self.DiebetesRadio.forEach { (button) in
            button.isSelected = false
        }
        sender.isSelected = true
        if sender.tag == 21 {
            self.selecteddiebetes = String(1)
            maximizeHeight(objects: [DiebetesTF], heightContantOutlet: [HeightOfDiebetesTF])
        }
        else if sender.tag == 22 {
            self.selecteddiebetes = String(0)
            minimizeHeight(objects: [DiebetesTF], heightContantOutlet: [HeightOfDiebetesTF])
        }
    }
    @IBAction func CancerYesOrNo(sender: SKRadioButton){
        self.CancerRadio.forEach { (button) in
            button.isSelected = false
        }
        sender.isSelected = true
        if sender.tag == 23 {
            self.selectedcancer = String(1)
           // maximizeHeight(objects: [CancerTF], heightContantOutlet: [HeightOfCancerTF])
        }
        else if sender.tag == 24 {
            self.selectedcancer = String(0)
          //  minimizeHeight(objects: [CancerTF], heightContantOutlet: [HeightOfCancerTF])
        }
    }
    @IBAction func HeartDiseaseYesOrNo(sender: SKRadioButton){
        self.HeartDiseaseRadio.forEach { (button) in
            button.isSelected = false
        }
        sender.isSelected = true
        if sender.tag == 25 {
            self.selectedheartdisease = String(1)
         //   maximizeHeight(objects: [HeartDiseaseTF], heightContantOutlet: [HeightOfHeartDiseaseTF])
        }
        else if sender.tag == 26 {
            self.selectedheartdisease = String(0)
          //  minimizeHeight(objects: [HeartDiseaseTF], heightContantOutlet: [HeightOfHeartDiseaseTF])
        }
    }
    @IBAction func LeukemiaYesOrNo(sender: SKRadioButton){
        self.LeukemiaRadio.forEach { (button) in
            button.isSelected = false
        }
        sender.isSelected = true
        if sender.tag == 27 {
            self.selectedleukemia = String(1)
         //   maximizeHeight(objects: [LeukemiaTF], heightContantOutlet: [HeightOfLeukemiaTF])
        }
        else if sender.tag == 28 {
            self.selectedleukemia = String(0)
          //  minimizeHeight(objects: [LeukemiaTF], heightContantOutlet: [HeightOfLeukemiaTF])
        }
    }
    @IBAction func otherAllergyYesOrNo(sender: SKRadioButton){
        self.otherAllergyRadio.forEach { (button) in
            button.isSelected = false
        }
        sender.isSelected = true
        if sender.tag == 29 {
            self.selectedother = String(1)
            maximizeHeight(objects: [otherAllergyTF], heightContantOutlet: [HeightOfotherAllergyTF])
        }
        else if sender.tag == 30 {
            self.selectedother = String(0)
            minimizeHeight(objects: [otherAllergyTF], heightContantOutlet: [HeightOfotherAllergyTF])
        }
    }
    @IBAction func RestrictionYesOrNo(sender: SKRadioButton){
        self.RestrictionRadio.forEach { (button) in
            button.isSelected = false
        }
        sender.isSelected = true
        if sender.tag == 31 {
            self.selectedrestriction = String(1)
            maximizeHeight(objects: [RestrictionTF], heightContantOutlet: [HeightOfRestrictionTF])
        }
        else if sender.tag == 32 {
            self.selectedrestriction = String(0)
            minimizeHeight(objects: [RestrictionTF], heightContantOutlet: [HeightOfRestrictionTF])
        }
    }
    @IBAction func RecentMedicalConditionAction(sender: SKRadioButton){
        self.RecentMedicalConditionRadio.forEach { (button) in
            button.isSelected = false
        }
        sender.isSelected = true
        if sender.tag == 8 {
            self.selectedcondition = String(1)
            maximizeHeight(objects: [RecentMedicalConditionTF], heightContantOutlet: [HeightOfRecentMedicalConditionTF])
        }
        else if sender.tag == 9 {
            self.selectedcondition = String(0)
            minimizeHeight(objects: [RecentMedicalConditionTF], heightContantOutlet: [HeightOfRecentMedicalConditionTF])
        }
    }
}
extension ProfilePageViewController: UIPickerViewDelegate,UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.bloodtypes.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.bloodtypes[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if self.bloodtypes.count == 0{
            
        } else {
            self.BloodGroupTF.text = self.bloodtypes[row]
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
        label.text = self.bloodtypes[row]
        
        return label
    }
}

/*
extension ProfilePageViewController { //coredata save and retrive
    
    func savedata(){
        let managedobject = self.appdel.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Profile", in: managedobject)
        
        do {
            SwiftLoader.show(title: "Loading..", animated: true)
            let profile = NSManagedObject(entity: entity!, insertInto: managedobject)
            //user
            let imgdata: Data = (imagesPicView.image?.pngData())!
            profile.setValue(imgdata, forKey: user.image)
            profile.setValue(self.NameTF.text!, forKey: user.name)
            profile.setValue(self.selectedGender, forKey: user.gender)
            profile.setValue(self.DateOfBirthTF.text!, forKey: user.dateofbirth)
            profile.setValue(self.age.text!, forKey: user.age)
            profile.setValue(self.BloodGroupTF.text!, forKey: user.bloodGroup)
            profile.setValue(self.emailTF.text!, forKey: user.email)
            profile.setValue(self.PatientTF.text, forKey: user.patientid)
          //  profile.setValue(self.WeightTF.text!, forKey: user.weight)
          //  profile.setValue(self.HeightTF.text!, forKey: user.height)
          //  profile.setValue(self.BloodPressureTF.text!, forKey: user.bloodPressure)
          //  profile.setValue(self.TempretureTF.text!, forKey: user.temperature)
            profile.setValue(self.MobileNumberTF.text!, forKey: user.mobileNumber)
            profile.setValue(self.Address1TF.text!, forKey: user.address1)
            profile.setValue(self.Address2TF.text!, forKey: user.address2)
            profile.setValue(self.SubCityTF.text!, forKey: user.subcity)
            profile.setValue(self.CityTF.text!, forKey: user.city)
            //guardian
            profile.setValue(self.GuardianNameTF.text!, forKey: guardian.gName)
            profile.setValue(self.GuardianMobileNumberTF.text!, forKey: guardian.gMobileNumber)
            profile.setValue(self.GuardianAddress1TF.text!, forKey: guardian.gAddress1)
            profile.setValue(self.GuardianAddress2TF.text!, forKey: guardian.gAddress2)
            profile.setValue(self.GuardianSubCityTF.text!, forKey: guardian.gSubcity)
            profile.setValue(self.GuardianCityTF.text!, forKey: guardian.gCity)
            //ec1
            profile.setValue(self.FirstEC_NameTF.text!, forKey: emergencyContact.ec1name)
            profile.setValue(self.FirstEC_RelationshipTF.text!, forKey: emergencyContact.ec1relationship)
            profile.setValue(self.FirstEC_NumberTF.text!, forKey: emergencyContact.ec1number)
            //ec2
            profile.setValue(self.SecondEC_NameTF.text!, forKey: emergencyContact.ec2name)
            profile.setValue(self.SecondEC_RelationshipTF.text!, forKey: emergencyContact.ec2relationship)
            profile.setValue(self.SecondEC_NumberTF.text!, forKey: emergencyContact.ec2number)
            //pp
            profile.setValue(self.PP_NameTF.text!, forKey: emergencyContact.ppname)
            profile.setValue(self.PP_NumberTF.text!, forKey: emergencyContact.ppnumber)
            profile.setValue(self.PP_PolicyTF.text!, forKey: emergencyContact.pppolicy)
            profile.setValue(self.PP_PolicyNumberTF.text!, forKey: emergencyContact.pppolicynumber)
            //allergy
            profile.setValue(self.HaveAllergy, forKey: medical.allergy)
            
            profile.setValue(self.selectedfood, forKey: medical.afood)
            profile.setValue(self.FoodAllergyTF.text!, forKey: medical.aexplainFood)
            
            profile.setValue(self.selectedmedicine, forKey: medical.amedicine)
            profile.setValue(self.MedicinesAllergiesTF.text!, forKey: medical.aexplainMedicine)
            
            profile.setValue(self.selectedplants, forKey: medical.aplants)
            profile.setValue(self.PlantsTF.text!, forKey: medical.aexplainPlants)
            
            profile.setValue(self.selectedinsects, forKey: medical.ainsects)
            profile.setValue(self.InsectsTF.text!, forKey: medical.aexplainInsects)
            
            profile.setValue(self.selectedother, forKey: medical.aother)
            profile.setValue(self.otherAllergyTF.text!, forKey: medical.aexplainOther)
            
          //  profile.setValue(self.selectedbp, forKey: medical.mbp)
            profile.setValue(self.BPTF.text!, forKey: medical.mexplainBp)
            
            profile.setValue(self.selecteddiebetes, forKey: medical.mdiebetes)
            profile.setValue(self.DiebetesTF.text!, forKey: medical.mexplainDiebetes)
            
            profile.setValue(self.selectedcancer, forKey: medical.mcancer)
            profile.setValue(self.CancerTF.text!, forKey: medical.mexplainCancer)
            
            profile.setValue(self.selectedheartdisease, forKey: medical.mheartdisease)
            profile.setValue(self.HeartDiseaseTF.text!, forKey: medical.mexplainHeartDisease)
            
            profile.setValue(self.selectedleukemia, forKey: medical.mleukemia)
            profile.setValue(self.LeukemiaTF.text!, forKey: medical.mexplainLeukemia)
            
            profile.setValue(self.selectedrestriction, forKey: medical.mrestrict)
            profile.setValue(self.RestrictionTF.text!, forKey: medical.mexplainRestrict)
            profile.setValue(self.RecentMedicalConditionTF.text!, forKey: medical.mrecentMC)
            //last vaccination done
            profile.setValue(self.tetanusSelectedDate.text!, forKey: lastVaccinationDone.lselecteddate1)
            profile.setValue(self.polioSelectedDate.text!, forKey: lastVaccinationDone.lselecteddate2)
            profile.setValue(self.diphtheriaSelectedDate.text!, forKey: lastVaccinationDone.lselecteddate3)
            profile.setValue(self.mumpsSelectedDate.text!, forKey: lastVaccinationDone.lselecteddate4)
            profile.setValue(self.declare, forKey: lastVaccinationDone.declare)
            try managedobject.save()
            SwiftLoader.hide()
        } catch {
            SwiftLoader.hide()
            print("catch")
        }
    }
    func retrivedata(){
        let managedobject = self.appdel.persistentContainer.viewContext
        let fetchReq = NSFetchRequest<NSFetchRequestResult>(entityName: "Profile")
        do {
            let result = try managedobject.fetch(fetchReq)
            for data in result as! [NSManagedObject]{
                //user
                SwiftLoader.show(title: "Loading..", animated: true)
                let imgdata = data.value(forKey: user.image) as? Data
                if imgdata != nil{
                    self.imagesPicView.image = UIImage(data: imgdata!)
                }
                else {
                    self.imagesPicView.image = #imageLiteral(resourceName: "man.png")
                }
                self.NameTF.text = data.value(forKey: user.name) as? String
                self.DateOfBirthTF.text = data.value(forKey: user.dateofbirth) as? String
                self.age.text = data.value(forKey: user.age) as? String
                self.selectedGender = data.value(forKey: user.gender) as? String ?? "0"
                self.BloodGroupTF.text = data.value(forKey: user.bloodGroup) as? String
                self.WeightTF.text = data.value(forKey: user.weight) as? String
                self.HeightTF.text = data.value(forKey: user.height) as? String
                self.BloodPressureTF.text = data.value(forKey: user.bloodPressure) as? String
                self.TempretureTF.text = data.value(forKey: user.temperature) as? String
                
                self.MobileNumberTF.text = data.value(forKey: user.mobileNumber) as? String
                self.Address1TF.text = data.value(forKey: user.address1) as? String
                self.Address2TF.text = data.value(forKey: user.address2) as? String
                self.SubCityTF.text = data.value(forKey: user.subcity) as? String
                self.CityTF.text = data.value(forKey: user.city) as? String
                //guardian
                self.GuardianNameTF.text = data.value(forKey: guardian.gName) as? String
                self.GuardianAddress1TF.text = data.value(forKey: guardian.gAddress1) as? String
                self.GuardianAddress2TF.text = data.value(forKey: guardian.gAddress2) as? String
                self.GuardianSubCityTF.text = data.value(forKey: guardian.gSubcity) as? String
                self.GuardianCityTF.text = data.value(forKey: guardian.gCity) as? String
                //ec1
                self.FirstEC_NameTF.text = data.value(forKey: emergencyContact.ec1name) as? String
                self.FirstEC_RelationshipTF.text = data.value(forKey: emergencyContact.ec1relationship) as? String
                self.FirstEC_NumberTF.text = data.value(forKey: emergencyContact.ec1number) as? String
                //ec2
                self.SecondEC_NameTF.text = data.value(forKey: emergencyContact.ec2name) as? String
                self.SecondEC_RelationshipTF.text = data.value(forKey: emergencyContact.ec2relationship) as? String
                self.SecondEC_NumberTF.text = data.value(forKey: emergencyContact.ec2number) as? String
                //pp
                self.PP_NameTF.text = data.value(forKey: emergencyContact.ppname) as? String
                self.PP_NumberTF.text = data.value(forKey: emergencyContact.ppnumber) as? String
                self.PP_PolicyTF.text = data.value(forKey: emergencyContact.pppolicy) as? String
                self.PP_PolicyNumberTF.text = data.value(forKey: emergencyContact.pppolicynumber) as? String
                //allergy
                HaveAllergy = data.value(forKey: medical.allergy) as! String
                
                selectedfood = data.value(forKey: medical.afood) as! String
                self.FoodAllergyTF.text = data.value(forKey: medical.aexplainFood) as? String
                
                selectedmedicine = data.value(forKey: medical.amedicine) as! String
                self.MedicinesAllergiesTF.text = data.value(forKey: medical.aexplainMedicine) as? String
                
                selectedplants = data.value(forKey: medical.aplants) as! String
                self.PlantsTF.text = data.value(forKey: medical.aexplainPlants) as? String
                
                selectedinsects = data.value(forKey: medical.ainsects) as! String
                self.InsectsTF.text = data.value(forKey: medical.aexplainInsects) as? String
                
                selectedother = data.value(forKey: medical.aother) as! String
                self.otherAllergyTF.text = data.value(forKey: medical.aexplainOther) as? String
                //medical
              //  selectedbp = data.value(forKey: medical.mbp) as! String
                self.BPTF.text = data.value(forKey: medical.mexplainBp) as? String
                
                selecteddiebetes = data.value(forKey: medical.mdiebetes) as! String
                self.DiebetesTF.text = data.value(forKey: medical.mexplainDiebetes) as? String
                
                selectedcancer = data.value(forKey: medical.mcancer) as! String
                self.CancerTF.text = data.value(forKey: medical.mexplainCancer) as? String
                
                selectedheartdisease = data.value(forKey: medical.mheartdisease) as! String
                self.HeartDiseaseTF.text = data.value(forKey: medical.mexplainHeartDisease) as? String
                
                selectedleukemia = data.value(forKey: medical.mleukemia) as! String
                self.LeukemiaTF.text = data.value(forKey: medical.mexplainLeukemia) as? String
                
                selectedrestriction = data.value(forKey: medical.mrestrict) as! String
                self.RestrictionTF.text = data.value(forKey: medical.mexplainRestrict) as? String
                
                self.RecentMedicalConditionTF.text = data.value(forKey: medical.mrecentMC) as? String
                //last vaccination done
                let data1 = data.value(forKey: lastVaccinationDone.lselecteddate1) as? String
                self.tetanusSelectedDate.text = data1
                
                let data2 = data.value(forKey: lastVaccinationDone.lselecteddate2) as? String
                self.polioSelectedDate.text = data2
                
                let data3 = data.value(forKey: lastVaccinationDone.lselecteddate3) as? String
                self.diphtheriaSelectedDate.text = data3
                
                let data4 = data.value(forKey: lastVaccinationDone.lselecteddate4) as? String
                self.mumpsSelectedDate.text = data4
                self.declare = data.value(forKey: lastVaccinationDone.declare) as! String
                SwiftLoader.hide()
            }
        } catch {
            SwiftLoader.hide()
            print("failed")
        }
    }
}*/
