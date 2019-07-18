//
//  AddPrescriptionViewController.swift
//  medocpatient
//
//  Created by Nishikant Ashok UMBARKAR on 15/7/19.
//  Copyright © 2019 kspl. All rights reserved.
//

import UIKit
import DropDown
import DBAttachmentPickerController
import MobileCoreServices

class AddPrescriptionViewController: UIViewController {

    @IBOutlet var close : UIButton!

    @IBOutlet var tf_doctorname: UITextField!
    @IBOutlet var tf_doctortype: UITextField!
    @IBOutlet var tf_patientproblem: UITextField!
    
    @IBOutlet var img_Prescription: UIImageView!
    @IBOutlet var constant_height_of_img_Prescription: NSLayoutConstraint!
    
    @IBOutlet var btn_clickPrescriptionImages : UIButton!
    @IBOutlet var btn_selectMedicine : UIButton!
    @IBOutlet var btn_Done : UIButton!
    
    var doctortypelist = [[String:String]]()
    var filter_doctortypelist = [[String:String]]()
    let dropdown = DropDown()
    var selectedmedicineid = 0
    var pdfurl = URL(string: "NF")!
    var imagename = ""
    var APC = DBAttachmentPickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Utilities.shared.cornerRadius(objects: [btn_clickPrescriptionImages,btn_selectMedicine,btn_Done,img_Prescription], number: 10.0)
        close.addTarget(self, action: #selector(closeAction), for: .touchUpInside)
        tf_doctortype.addTarget(self, action: #selector(handle_tf_doctortype), for: .editingChanged)
        btn_clickPrescriptionImages.addTarget(self, action: #selector(Action_btn_clickPrescriptionImages), for: .touchUpInside)
        btn_selectMedicine.addTarget(self, action: #selector(Action_btn_selectMedicine), for: .touchUpInside)
        btn_Done.addTarget(self, action: #selector(Action_btn_Done), for: .touchUpInside)

        dropdown.anchorView = tf_doctortype
        
        dropdown.direction = .bottom
        dropdown.bottomOffset = CGPoint(x: 0, y:(dropdown.anchorView?.plainView.bounds.height)!)
        
        DropDown.appearance().textFont = UIFont.boldSystemFont(ofSize: 15)
        dropdown.width = self.tf_doctortype.frame.width
        
        dropdown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.tf_doctortype.text = item
            print("Selected item: \(item) at index: \(index)")
        }
        
        NetworkManager.isReachable { _ in
            self.fetchDoctorType()
        }
        NetworkManager.sharedInstance.reachability.whenReachable = { _ in
            self.fetchDoctorType()
        }
        NetworkManager.isUnreachable { _ in
            Utilities.shared.showToast(text: "No Internet Connection", duration: 3.0)
        }
        
        // Do any additional setup after loading the view.
    }
    @objc func Action_btn_clickPrescriptionImages(){
        self.tf_patientproblem.endEditing(true)
        self.tf_doctorname.endEditing(true)
        self.tf_doctortype.endEditing(true)
        Alert.shared.choose(sender: btn_clickPrescriptionImages, vc: self, ActionCompletion: {
            print("image")
            PHPhotoLibrary.requestAuthorization { (status) in
                if status == PHAuthorizationStatus.notDetermined {
                    self.Action_btn_clickPrescriptionImages()
                } else {
                    self.APC = DBAttachmentPickerController(finishPicking: { (attachmentArray) in
                        attachmentArray[0].loadOriginalImage(completion: { (image) in
                            let timestamp = Date().toMillis()
                            image?.accessibilityIdentifier = String(describing: timestamp)
                            self.imagename = "\(String(describing: timestamp!)).jpg"
                            self.img_Prescription.image = image
                            self.pdfurl = URL(string: "NF")!
                            self.constant_height_of_img_Prescription.constant = 150
                        })
                        
                    }, cancel: nil)
                    self.APC.mediaType = [.image]
                    self.APC.allowsMultipleSelection = false
                    self.APC.allowsSelectionFromOtherApps = false
                    self.APC.present(on: self)
                    
                }
                
            }
        }) {
            print("pdf")
            
            let documentPicker = UIDocumentPickerViewController(documentTypes: [String(kUTTypePDF)], in: .import)
            documentPicker.delegate = self
            documentPicker.allowsMultipleSelection = false
            documentPicker.modalPresentationStyle = .formSheet
            self.present(documentPicker, animated: true, completion: nil)
        }
        
    }
    @objc func Action_btn_selectMedicine(){
        let addMedicineVC = self.storyboard?.instantiateViewController(withIdentifier: "MedicineViewController") as! MedicineViewController
        addMedicineVC.routeFromOtherVC = true
        addMedicineVC.getSelectedMedicine = { data in
            let id = data.value(forKey: "id") as? Int ?? 0
            let patient_problem = data.value(forKey: "medicine_name") as? String ?? self.btn_selectMedicine.titleLabel?.text
            self.selectedmedicineid = id
            self.btn_selectMedicine.setTitle(patient_problem, for: .normal)
            print(data)
        }
        navigationController?.pushViewController(addMedicineVC, animated: true)
    }
    @objc func Action_btn_Done(){
        if (self.tf_doctorname.text?.isEmpty)! {
            Utilities.shared.showToast(text: "Write Doctor Name", duration: 3.0)
        }
        else if (self.tf_doctortype.text?.isEmpty)! {
            Utilities.shared.showToast(text: "Write Doctor Type Name", duration: 3.0)
        }
        else if (self.tf_patientproblem.text?.isEmpty)! {
            Utilities.shared.showToast(text: "Write Patient Problem", duration: 3.0)
        }
        else if self.img_Prescription.image == nil{
            Utilities.shared.showToast(text: "Click One Image", duration: 3.0)
        }
        else if self.selectedmedicineid == 0{
            Utilities.shared.showToast(text: "Select Medicine", duration: 3.0)
        }
        else {
            Utilities.shared.showToast(text: "Done", duration: 3.0)
        }
    }
    func fetchDoctorType(){
        ApiServices.shared.FetchGetDataFromUrl(vc: self, Url: ApiServices.shared.medocDoctorUrl + "type_of_doctors", bearertoken: "") {
            do {
                let json = try JSONSerialization.jsonObject(with: ApiServices.shared.data, options: .mutableContainers) as! NSDictionary
                let msg = json.value(forKey: "msg") as? String
                if msg == "success" {
                    if let data = json.value(forKey: "data") as? [[String:String]] {
                        self.doctortypelist = data
                        self.filter_doctortypelist = self.doctortypelist
                        print(data.count)
                    }
                }
            } catch {
                print("catch")
            }
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
    @objc func handle_tf_doctortype(){
        if (self.tf_doctortype.text?.isEmpty)! {
            dropdown.hide()
            filter_doctortypelist = self.doctortypelist
            self.dropdown.dataSource = self.filter_doctortypelist.map { $0["name"]! }
            print(self.dropdown.dataSource.count)
            self.dropdown.reloadAllComponents()
        } else {
            dropdown.show()
            filter_doctortypelist = self.doctortypelist.filter { $0["name"]!
                                        .hasPrefixCheck(prefix: self.tf_doctortype.text!,
                                         isCaseSensitive: false) }.map { $0 }
            dropdown.dataSource = self.filter_doctortypelist.map { $0["name"]! }
            print(self.dropdown.dataSource.count)
            self.dropdown.reloadAllComponents()
        }
    }
}
extension AddPrescriptionViewController: UIDocumentPickerDelegate,UINavigationControllerDelegate{
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        let myURL = url as URL
        pdfurl = myURL
        self.imagename = myURL.lastPathComponent
        self.img_Prescription.image = #imageLiteral(resourceName: "placeholder--pdf.png")
        self.constant_height_of_img_Prescription.constant = 150
        print("import result : \(myURL)")
    }
}
