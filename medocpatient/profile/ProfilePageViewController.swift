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

class ProfilePageViewController: UIViewController, UITextFieldDelegate , FSCalendarDataSource , FSCalendarDelegate, DBAssetPickerControllerDelegate {
    //user
    @IBOutlet var BasicView: UIView!
    @IBOutlet var imagesPicView: UIImageView!
    @IBOutlet var addProfileImage: UIButton!
    @IBOutlet var NameTF: UITextField!
    @IBOutlet var DateOfBirthTF: UITextField!
    @IBOutlet var age: UILabel!
    @IBOutlet var GenderSegment: UISegmentedControl!
    @IBOutlet var BloodGroupTF: UITextField!
    @IBOutlet var HeightTF: UITextField!
    @IBOutlet var WeightTF: UITextField!
    @IBOutlet var BloodPressureTF: UITextField!
    @IBOutlet var TempretureTF: UITextField!
    
    @IBOutlet var MobileAddressView: UIView!
    @IBOutlet var MobileNumberTF: UITextField!
    @IBOutlet var Address1TF: UITextField!
    @IBOutlet var Address2TF: UITextField!
    @IBOutlet var SubCityTF: UITextField!
    @IBOutlet var CityTF: UITextField!
    //guardian
    @IBOutlet var GuardianView: UIView!
    @IBOutlet var GuardianNameTF: UITextField!
    @IBOutlet var GuardianMobileNumberTF: UITextField!
    @IBOutlet var GuardianAddress1TF: UITextField!
    @IBOutlet var GuardianAddress2TF: UITextField!
    @IBOutlet var GuardianSubCityTF: UITextField!
    @IBOutlet var GuardianCityTF: UITextField!
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
    @IBOutlet var AllergySegment: UISegmentedControl!
    //Textfield inside medical information
    @IBOutlet var FoodAllergyTF: UITextField!
    @IBOutlet var MedicinesAllergiesTF: UITextField!
    @IBOutlet var PlantsTF: UITextField!
    @IBOutlet var InsectsTF: UITextField!
    //medical condition
    @IBOutlet var BPTF: UITextField!
    @IBOutlet var DiebetesTF: UITextField!
    @IBOutlet var CancerTF: UITextField!
    @IBOutlet var HeartDiseaseTF: UITextField!
    @IBOutlet var LeukemiaTF: UITextField!
    @IBOutlet var otherAllergyTF: UITextField!
    @IBOutlet var RestrictionTF: UITextField!
    //
    //YES AND NO
    @IBOutlet var FoodRadio: [SKRadioButton]!
    @IBOutlet var MedicinesRadio: [SKRadioButton]!
    @IBOutlet var PlantsRadio: [SKRadioButton]!
    @IBOutlet var InsectsRadio: [SKRadioButton]!
    
    @IBOutlet var BPRadio: [SKRadioButton]!
    @IBOutlet var DiebetesRadio: [SKRadioButton]!
    @IBOutlet var CancerRadio: [SKRadioButton]!
    @IBOutlet var HeartDiseaseRadio: [SKRadioButton]!
    @IBOutlet var LeukemiaRadio: [SKRadioButton]!
    @IBOutlet var otherAllergyRadio: [SKRadioButton]!
    @IBOutlet var RestrictionRadio: [SKRadioButton]!
    //
    //Heights of textfield
    @IBOutlet var HeightOfFoodTF: NSLayoutConstraint!
    @IBOutlet var HeightOfMedicinesTF: NSLayoutConstraint!
    @IBOutlet var HeightOfPlantsTF: NSLayoutConstraint!
    @IBOutlet var HeightOfInsectsTF: NSLayoutConstraint!
    
    @IBOutlet var HeightOfBPTF: NSLayoutConstraint!
    @IBOutlet var HeightOfDiebetesTF: NSLayoutConstraint!
    @IBOutlet var HeightOfCancerTF: NSLayoutConstraint!
    @IBOutlet var HeightOfHeartDiseaseTF: NSLayoutConstraint!
    @IBOutlet var HeightOfLeukemiaTF: NSLayoutConstraint!
    @IBOutlet var HeightOfotherAllergyTF: NSLayoutConstraint!
    @IBOutlet var HeightOfRestrictionTF: NSLayoutConstraint!
    @IBOutlet var bottomContraint: NSLayoutConstraint!
    //
    @IBOutlet var allergyView: UIView!
    @IBOutlet var HeightOFallergyView: NSLayoutConstraint!
    @IBOutlet var ExplanationTF: UITextField!//recent medical condition
    
    @IBOutlet var LastDoneView: UIView!
    @IBOutlet var tetanusSelectedDate: UILabel!
    @IBOutlet var polioSelectedDate: UILabel!
    @IBOutlet var diphtheriaSelectedDate: UILabel!
    @IBOutlet var mumpsSelectedDate: UILabel!
    @IBOutlet var cv: UIView!

    @IBOutlet var Declare: UIButton!
    @IBOutlet var Save: UIButton!
    var checked = Bool(true)
    var selectedGender = Int()
    var HaveAllergy = 1
    var selectedfood = 1
    var selectedmedicine = 1
    var selectedplants = 1
    var selectedinsects = 1
    var selectedother = 1
    var selectedbp = 1
    var selecteddiebetes = 1
    var selectedcancer = 1
    var selectedheartdisease = 1
    var selectedleukemia = 1
    var selectedrestriction = 1
    var declare = 0
    
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
    var selected = ""
    var datestr1 = ""
    var datestr2 = ""
    var datestr3 = ""
    var datestr4 = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Utilized()
        SetupInterface()
        Save.addTarget(self, action: #selector(SaveAction), for: .touchUpInside)
        GenderSegment.addTarget(self, action: #selector(ChangeGender), for: .valueChanged)
        
        fscalendar.delegate = self
        fscalendar.dataSource = self
        cancel.addTarget(self, action: #selector(cancelAction), for: .touchUpInside)
        fscalendar.backgroundColor = UIColor.groupTableViewBackground
        addProfileImage.addTarget(self, action: #selector(addAttachmentAction), for: .touchUpInside)
       // Do any additional setup after loading the view.
    }
    @objc func addAttachmentAction(){
        PHPhotoLibrary.requestAuthorization { (status) in
            if status == PHAuthorizationStatus.notDetermined {
                self.addAttachmentAction()
            } else {
                self.APC = DBAttachmentPickerController(finishPicking: { (attachmentArray) in
                    
                    attachmentArray[0].loadOriginalImage(completion: { (image) in
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
    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.async {
            self.retrivedata()
            self.yesORnoActionInsideAllergyView()
        }
        NotificationCenter.default.addObserver(self, selector: #selector(reload), name: NSNotification.Name("reload"), object: nil)
    }
    @objc func reload(){
        UIView.animate(withDuration: 0.1) {
            self.cv.isHidden = true
            self.cv.alpha = 0.0
        }
       // retrivedata()
    }
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        SwiftLoader.show(title: "Date Set..", animated: true)
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        let datestr = formatter.string(from: date)
        
        if selected == "1"{
            self.datestr1 = datestr
            self.tetanusSelectedDate.text = self.datestr1
            //  profile.setValue(self.datestr1, forKey: lastVaccinationDone.lselecteddate1)
        }
        else if selected == "2"{
            self.datestr2 = datestr
            self.polioSelectedDate.text = self.datestr2
            //  profile.setValue(self.datestr2, forKey: lastVaccinationDone.lselecteddate2)
        }
        else if selected == "3"{
            self.datestr3 = datestr
            self.diphtheriaSelectedDate.text = self.datestr3
            // profile.setValue(self.datestr3, forKey: lastVaccinationDone.lselecteddate3)
        }
        else if selected == "4"{
            self.datestr4 = datestr
            self.mumpsSelectedDate.text = self.datestr4
            //  profile.setValue(self.datestr4, forKey: lastVaccinationDone.lselecteddate4)
        }
        
        SwiftLoader.hide()
        NotificationCenter.default.post(name: NSNotification.Name("reload"), object: self)
        //  self.dismiss(animated: true, completion: nil)
    }
    func maximumDate(for calendar: FSCalendar) -> Date {
        return Date()
    }
    @objc func cancelAction(){
        NotificationCenter.default.post(name: NSNotification.Name("reload"), object: self)
        //self.dismiss(animated: true, completion: nil)
    }
    override func viewDidAppear(_ animated: Bool) {
        DateOfBirthTF.delegate = self
        DateOfBirthTF.inputView = dateview
        dateview.datePickerMode = .date
        dateview.maximumDate = Date()
        dateview.backgroundColor = UIColor.white
        dateview.setValue(UIColor.black, forKeyPath: "textColor")
        dateview.setDate(Date(), animated: true)
        dateview.addTarget(self, action: #selector(setdate), for: .valueChanged)
    }
    @objc func setdate(datePicker: UIDatePicker){
        let df = DateFormatter()
        df.dateFormat = "dd/MM/yyyy"
        if DateOfBirthTF.isFirstResponder {
            DateOfBirthTF.text = df.string(from: datePicker.date)
            let calendar : NSCalendar = NSCalendar.current as NSCalendar
            let ageComponents = calendar.components(.year, from: dateview.date, to: Date() as Date, options: [])
            let age = ageComponents.year!
            self.age.text = "Age: \(age)"
        }
    }
    override func viewWillLayoutSubviews() {
        
    }
    @objc func SaveAction(){
        savedata()
    }
    @objc func ChangeGender(){
        if GenderSegment.selectedSegmentIndex == 0{
            selectedGender = 0
        }
        else if GenderSegment.selectedSegmentIndex == 1{
            selectedGender = 1
        }
        else if GenderSegment.selectedSegmentIndex == 2{
            selectedGender = 2
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
}
extension ProfilePageViewController {//setupinterface
    
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
            profile.setValue(self.WeightTF.text!, forKey: user.weight)
            profile.setValue(self.HeightTF.text!, forKey: user.height)
            profile.setValue(self.BloodPressureTF.text!, forKey: user.bloodPressure)
            profile.setValue(self.TempretureTF.text!, forKey: user.temperature)
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
            
            profile.setValue(self.selectedbp, forKey: medical.mbp)
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
            profile.setValue(self.ExplanationTF.text!, forKey: medical.mrecentMC)
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
                selectedGender = data.value(forKey: user.gender) as? Int ?? 0
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
                HaveAllergy = data.value(forKey: medical.allergy) as! Int
                
                selectedfood = data.value(forKey: medical.afood) as! Int
                self.FoodAllergyTF.text = data.value(forKey: medical.aexplainFood) as? String
                
                selectedmedicine = data.value(forKey: medical.amedicine) as! Int
                self.MedicinesAllergiesTF.text = data.value(forKey: medical.aexplainMedicine) as? String
                
                selectedplants = data.value(forKey: medical.aplants) as! Int
                self.PlantsTF.text = data.value(forKey: medical.aexplainPlants) as? String
                
                selectedinsects = data.value(forKey: medical.ainsects) as! Int
                self.InsectsTF.text = data.value(forKey: medical.aexplainInsects) as? String
                
                selectedother = data.value(forKey: medical.aother) as! Int
                self.otherAllergyTF.text = data.value(forKey: medical.aexplainOther) as? String
                //medical
                selectedbp = data.value(forKey: medical.mbp) as! Int
                self.BPTF.text = data.value(forKey: medical.mexplainBp) as? String
                
                selecteddiebetes = data.value(forKey: medical.mdiebetes) as! Int
                self.DiebetesTF.text = data.value(forKey: medical.mexplainDiebetes) as? String
                
                selectedcancer = data.value(forKey: medical.mcancer) as! Int
                self.CancerTF.text = data.value(forKey: medical.mexplainCancer) as? String
                
                selectedheartdisease = data.value(forKey: medical.mheartdisease) as! Int
                self.HeartDiseaseTF.text = data.value(forKey: medical.mexplainHeartDisease) as? String
                
                selectedleukemia = data.value(forKey: medical.mleukemia) as! Int
                self.LeukemiaTF.text = data.value(forKey: medical.mexplainLeukemia) as? String
                
                selectedrestriction = data.value(forKey: medical.mrestrict) as! Int
                self.RestrictionTF.text = data.value(forKey: medical.mexplainRestrict) as? String
                
                self.ExplanationTF.text = data.value(forKey: medical.mrecentMC) as? String
                //last vaccination done
                let data1 = data.value(forKey: lastVaccinationDone.lselecteddate1) as? String
                self.tetanusSelectedDate.text = data1
                
                let data2 = data.value(forKey: lastVaccinationDone.lselecteddate2) as? String
                self.polioSelectedDate.text = data2
                
                let data3 = data.value(forKey: lastVaccinationDone.lselecteddate3) as? String
                self.diphtheriaSelectedDate.text = data3
                
                let data4 = data.value(forKey: lastVaccinationDone.lselecteddate4) as? String
                self.mumpsSelectedDate.text = data4
                self.declare = data.value(forKey: lastVaccinationDone.declare) as! Int
                SwiftLoader.hide()
            }
        } catch {
            SwiftLoader.hide()
            print("failed")
        }
    }
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
        Utilities.shared.cornerRadius(objects: [allergyView,Save], number: 10.0)
        Utilities.shared.cornerRadius(objects: [imagesPicView], number: imagesPicView.frame.width / 2)
        Utilities.shared.borderRadius(objects: [Save], color: UIColor.white)
        
    }
    @IBAction func ClicktoSelectDate(sender: UIButton){
       // savedata()
      //  let vc = self.storyboard?.instantiateViewController(withIdentifier: "CalendarViewController") as! CalendarViewController
        UIView.animate(withDuration: 0.1) {
            self.cv.isHidden = false
            self.cv.alpha = 1.0
        }
       // self.present(vc, animated: true, completion: nil)
//        datestr1 = self.tetanusSelectedDate.text!
//        datestr2 = self.polioSelectedDate.text!
//        datestr3 = self.diphtheriaSelectedDate.text!
//        datestr4 = self.mumpsSelectedDate.text!
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
        Declare.isMultipleTouchEnabled = true

        DispatchQueue.main.async {
            self.GenderSegment.selectedSegmentIndex = self.selectedGender
            self.AllergySegment.selectedSegmentIndex = self.HaveAllergy
            self.HeightOFallergyView.constant = 0
            self.bottomContraint.isActive = false
            self.allergyView.isHidden = true
        }
        
        GenderSegment.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.darkGray, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 15)], for: .normal)
        GenderSegment.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor(hexString: "4CAF50"), NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20)], for: .selected)
        GenderSegment.tintColor = UIColor.clear
        GenderSegment.backgroundColor = UIColor.clear
        
        AllergySegment.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.darkGray, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 15)], for: .normal)
        AllergySegment.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor(hexString: "4CAF50"), NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20)], for: .selected)
        AllergySegment.tintColor = UIColor.clear
        AllergySegment.backgroundColor = UIColor.clear
        
        AllergySegment.addTarget(self, action: #selector(AllergySegmentValue), for: .valueChanged)
        Declare.addTarget(self, action: #selector(DeclareAction), for: .touchUpInside)
        minimize()
    }
    func minimize(){
        minimizeHeight(objects: [FoodAllergyTF,MedicinesAllergiesTF,PlantsTF,InsectsTF,BPTF,DiebetesTF,CancerTF,HeartDiseaseTF,LeukemiaTF,otherAllergyTF,RestrictionTF],heightContantOutlet:  [HeightOfFoodTF,HeightOfMedicinesTF,HeightOfPlantsTF,HeightOfInsectsTF,HeightOfBPTF,HeightOfDiebetesTF,HeightOfCancerTF,HeightOfHeartDiseaseTF,HeightOfLeukemiaTF,HeightOfotherAllergyTF,HeightOfRestrictionTF])
    }
    @objc func AllergySegmentValue(){
        if AllergySegment.selectedSegmentIndex == 0{//yes
            showAllergy()
        }
        else if AllergySegment.selectedSegmentIndex == 1{//no
            hideAllergy()
        }
    }
    func showAllergy(){
        HaveAllergy = 0
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
        HaveAllergy = 1
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
    @objc func DeclareAction(){
        if Declare.currentImage == #imageLiteral(resourceName: "square") {
            self.checked = false
            self.declare = 1
            print(self.declare)
            Declare.setImage(#imageLiteral(resourceName: "check-square"), for: .normal)
        }else{
            self.checked = true
            self.declare = 0
            print(self.declare)
            Declare.setImage(#imageLiteral(resourceName: "square"), for: .normal)
        }
    }
    func yesORnoActionInsideAllergyView(){
        self.AllergySegment.selectedSegmentIndex = HaveAllergy
        if HaveAllergy == 0{
            showAllergy()
        }
        else if HaveAllergy == 1{
            hideAllergy()
        }
        if self.declare == 0{
            Declare.setImage(#imageLiteral(resourceName: "square"), for: .normal)
        } else {
            Declare.setImage(#imageLiteral(resourceName: "check-square"), for: .normal)
        }
        
        FoodRadio[selectedfood].isSelected = true
        if selectedfood == 0{
            FoodRadio[1].isSelected = false
            maximizeHeight(objects: [FoodAllergyTF], heightContantOutlet: [HeightOfFoodTF])
        } else if selectedfood == 1{
            FoodRadio[0].isSelected = false
            minimizeHeight(objects: [FoodAllergyTF], heightContantOutlet: [HeightOfFoodTF])
        }
        
        MedicinesRadio[selectedmedicine].isSelected = true
        if selectedmedicine == 0{
            MedicinesRadio[1].isSelected = false
            maximizeHeight(objects: [MedicinesAllergiesTF], heightContantOutlet: [HeightOfMedicinesTF])
        } else if selectedmedicine == 1{
            MedicinesRadio[0].isSelected = false
            minimizeHeight(objects: [MedicinesAllergiesTF], heightContantOutlet: [HeightOfMedicinesTF])
        }
        
        PlantsRadio[selectedplants].isSelected = true
        if selectedplants == 0{
            PlantsRadio[1].isSelected = false
            maximizeHeight(objects: [PlantsTF], heightContantOutlet: [HeightOfPlantsTF])
        } else if selectedplants == 1{
            PlantsRadio[0].isSelected = false
            minimizeHeight(objects: [PlantsTF], heightContantOutlet: [HeightOfPlantsTF])
        }
        
        InsectsRadio[selectedinsects].isSelected = true
        if selectedinsects == 0{
            InsectsRadio[1].isSelected = false
            maximizeHeight(objects: [InsectsTF], heightContantOutlet: [HeightOfInsectsTF])
        } else if selectedinsects == 1{
            InsectsRadio[0].isSelected = false
            minimizeHeight(objects: [InsectsTF], heightContantOutlet: [HeightOfInsectsTF])
        }
        
        otherAllergyRadio[selectedother].isSelected = true
        if selectedother == 0{
            otherAllergyRadio[1].isSelected = false
            maximizeHeight(objects: [otherAllergyTF], heightContantOutlet: [HeightOfotherAllergyTF])
        } else if selectedother == 1{
            otherAllergyRadio[0].isSelected = false
            minimizeHeight(objects: [otherAllergyTF], heightContantOutlet: [HeightOfotherAllergyTF])
        }
        
        BPRadio[selectedbp].isSelected = true
        if selectedbp == 0{
            BPRadio[1].isSelected = false
            maximizeHeight(objects: [BPTF], heightContantOutlet: [HeightOfBPTF])
        } else if selectedbp == 1{
            BPRadio[0].isSelected = false
            minimizeHeight(objects: [BPTF], heightContantOutlet: [HeightOfBPTF])
        }
        
        DiebetesRadio[selecteddiebetes].isSelected = true
        if selecteddiebetes == 0{
            DiebetesRadio[1].isSelected = false
            maximizeHeight(objects: [DiebetesTF], heightContantOutlet: [HeightOfDiebetesTF])
        } else if selecteddiebetes == 1{
            DiebetesRadio[0].isSelected = false
            minimizeHeight(objects: [DiebetesTF], heightContantOutlet: [HeightOfDiebetesTF])
        }
        
        CancerRadio[selectedcancer].isSelected = true
        if selectedcancer == 0{
            CancerRadio[1].isSelected = false
            maximizeHeight(objects: [CancerTF], heightContantOutlet: [HeightOfCancerTF])
        } else if selectedcancer == 1{
            CancerRadio[0].isSelected = false
            minimizeHeight(objects: [CancerTF], heightContantOutlet: [HeightOfCancerTF])
        }
        
        HeartDiseaseRadio[selectedheartdisease].isSelected = true
        if selectedheartdisease == 0{
            HeartDiseaseRadio[1].isSelected = false
            maximizeHeight(objects: [HeartDiseaseTF], heightContantOutlet: [HeightOfHeartDiseaseTF])
        } else if selectedheartdisease == 1{
            HeartDiseaseRadio[0].isSelected = false
            minimizeHeight(objects: [HeartDiseaseTF], heightContantOutlet: [HeightOfHeartDiseaseTF])
        }
        
        LeukemiaRadio[selectedleukemia].isSelected = true
        if selectedleukemia == 0{
            LeukemiaRadio[1].isSelected = false
            maximizeHeight(objects: [LeukemiaTF], heightContantOutlet: [HeightOfLeukemiaTF])
        } else if selectedleukemia == 1{
            LeukemiaRadio[0].isSelected = false
            minimizeHeight(objects: [LeukemiaTF], heightContantOutlet: [HeightOfLeukemiaTF])
        }
        
        RestrictionRadio[selectedrestriction].isSelected = true
        if selectedrestriction == 0{
            RestrictionRadio[1].isSelected = false
            maximizeHeight(objects: [RestrictionTF], heightContantOutlet: [HeightOfRestrictionTF])
        } else if selectedrestriction == 1{
            RestrictionRadio[0].isSelected = false
            minimizeHeight(objects: [RestrictionTF], heightContantOutlet: [HeightOfRestrictionTF])
        }
    }
    @IBAction func FoodYesOrNo(sender: SKRadioButton){
        self.FoodRadio.forEach { (button) in
            button.isSelected = false
        }
        sender.isSelected = true
        if sender.tag == 11 {
            self.selectedfood = 0
            maximizeHeight(objects: [FoodAllergyTF], heightContantOutlet: [HeightOfFoodTF])
        }
        else if sender.tag == 12 {
            self.selectedfood = 1
            minimizeHeight(objects: [FoodAllergyTF], heightContantOutlet: [HeightOfFoodTF])
        }
    }
    @IBAction func MedicineYesOrNo(sender: SKRadioButton){
        self.MedicinesRadio.forEach { (button) in
            button.isSelected = false
        }
        sender.isSelected = true
        if sender.tag == 13 {
            self.selectedmedicine = 0
            maximizeHeight(objects: [MedicinesAllergiesTF], heightContantOutlet: [HeightOfMedicinesTF])
        }
        else if sender.tag == 14 {
            self.selectedmedicine = 1
            minimizeHeight(objects: [MedicinesAllergiesTF], heightContantOutlet: [HeightOfMedicinesTF])
        }
    }
    @IBAction func PlantsYesOrNo(sender: SKRadioButton){
        self.PlantsRadio.forEach { (button) in
            button.isSelected = false
        }
        sender.isSelected = true
        if sender.tag == 15 {
            self.selectedplants = 0
            maximizeHeight(objects: [PlantsTF], heightContantOutlet: [HeightOfPlantsTF])
        }
        else if sender.tag == 16 {
            self.selectedplants = 1
            minimizeHeight(objects: [PlantsTF], heightContantOutlet: [HeightOfPlantsTF])
        }
    }
    @IBAction func InsectsYesOrNo(sender: SKRadioButton){
        self.InsectsRadio.forEach { (button) in
            button.isSelected = false
        }
        sender.isSelected = true
        if sender.tag == 17 {
            self.selectedinsects = 0
            maximizeHeight(objects: [InsectsTF], heightContantOutlet: [HeightOfInsectsTF])
        }
        else if sender.tag == 18 {
            self.selectedinsects = 1
            minimizeHeight(objects: [InsectsTF], heightContantOutlet: [HeightOfInsectsTF])
        }
    }
    @IBAction func BPYesOrNo(sender: SKRadioButton){
        self.BPRadio.forEach { (button) in
            button.isSelected = false
        }
        sender.isSelected = true
        if sender.tag == 19 {
            self.selectedbp = 0
            maximizeHeight(objects: [BPTF], heightContantOutlet: [HeightOfBPTF])
        }
        else if sender.tag == 20 {
            self.selectedbp = 1
            minimizeHeight(objects: [BPTF], heightContantOutlet: [HeightOfBPTF])
        }
    }
    @IBAction func DiebetesYesOrNo(sender: SKRadioButton){
        self.DiebetesRadio.forEach { (button) in
            button.isSelected = false
        }
        sender.isSelected = true
        if sender.tag == 21 {
            self.selecteddiebetes = 0
            maximizeHeight(objects: [DiebetesTF], heightContantOutlet: [HeightOfDiebetesTF])
        }
        else if sender.tag == 22 {
            self.selecteddiebetes = 1
            minimizeHeight(objects: [DiebetesTF], heightContantOutlet: [HeightOfDiebetesTF])
        }
    }
    @IBAction func CancerYesOrNo(sender: SKRadioButton){
        self.CancerRadio.forEach { (button) in
            button.isSelected = false
        }
        sender.isSelected = true
        if sender.tag == 23 {
            self.selectedcancer = 0
            maximizeHeight(objects: [CancerTF], heightContantOutlet: [HeightOfCancerTF])
        }
        else if sender.tag == 24 {
            self.selectedcancer = 1
            minimizeHeight(objects: [CancerTF], heightContantOutlet: [HeightOfCancerTF])
        }
    }
    @IBAction func HeartDiseaseYesOrNo(sender: SKRadioButton){
        self.HeartDiseaseRadio.forEach { (button) in
            button.isSelected = false
        }
        sender.isSelected = true
        if sender.tag == 25 {
            self.selectedheartdisease = 0
            maximizeHeight(objects: [HeartDiseaseTF], heightContantOutlet: [HeightOfHeartDiseaseTF])
        }
        else if sender.tag == 26 {
            self.selectedheartdisease = 1
            minimizeHeight(objects: [HeartDiseaseTF], heightContantOutlet: [HeightOfHeartDiseaseTF])
        }
    }
    @IBAction func LeukemiaYesOrNo(sender: SKRadioButton){
        self.LeukemiaRadio.forEach { (button) in
            button.isSelected = false
        }
        sender.isSelected = true
        if sender.tag == 27 {
            self.selectedleukemia = 0
            maximizeHeight(objects: [LeukemiaTF], heightContantOutlet: [HeightOfLeukemiaTF])
        }
        else if sender.tag == 28 {
            self.selectedleukemia = 1
            minimizeHeight(objects: [LeukemiaTF], heightContantOutlet: [HeightOfLeukemiaTF])
        }
    }
    @IBAction func otherAllergyYesOrNo(sender: SKRadioButton){
        self.otherAllergyRadio.forEach { (button) in
            button.isSelected = false
        }
        sender.isSelected = true
        if sender.tag == 29 {
            self.selectedother = 0
            maximizeHeight(objects: [otherAllergyTF], heightContantOutlet: [HeightOfotherAllergyTF])
        }
        else if sender.tag == 30 {
            self.selectedother = 1
            minimizeHeight(objects: [otherAllergyTF], heightContantOutlet: [HeightOfotherAllergyTF])
        }
    }
    @IBAction func RestrictionYesOrNo(sender: SKRadioButton){
        self.RestrictionRadio.forEach { (button) in
            button.isSelected = false
        }
        sender.isSelected = true
        if sender.tag == 31 {
            self.selectedrestriction = 0
            maximizeHeight(objects: [RestrictionTF], heightContantOutlet: [HeightOfRestrictionTF])
        }
        else if sender.tag == 32 {
            self.selectedrestriction = 1
            minimizeHeight(objects: [RestrictionTF], heightContantOutlet: [HeightOfRestrictionTF])
        }
    }
}
