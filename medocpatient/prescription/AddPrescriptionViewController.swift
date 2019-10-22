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
import Alamofire
import PDFKit

class AddPrescriptionViewController: UIViewController {
    
    let bearertoken = UserDefaults.standard.string(forKey: "bearertoken")

    @IBOutlet var close : UIButton!

    @IBOutlet var tf_doctorname: UITextField!
    @IBOutlet var tf_doctortype: UITextField!
    @IBOutlet var tf_patientproblem: UITextField!
    
    @IBOutlet var btn_clickPrescriptionImages : UIButton!
    @IBOutlet var btn_selectMedicine : UIButton!
    @IBOutlet var btn_Done : UIButton!
    
    @IBOutlet var collectionview: UICollectionView!
    @IBOutlet var tableview: UITableView!
    @IBOutlet var height_of_collectionview: NSLayoutConstraint!
    @IBOutlet var height_of_tableview: NSLayoutConstraint!

    var doctortypelist = [[String:String]]()
    var filter_doctortypelist = [[String:String]]()
    let dropdown_doctortype = DropDown()
    let dropdown_doctorname = DropDown()
    var pdfurl = URL(string: "NF")!
    var APC = DBAttachmentPickerController()
    var doctorlist = NSArray()
    var filter_doctorlist = NSArray()
    var images = [[String:Any]]()
    var allmedicine = [NSDictionary]()
    var doctorid = "0"

    override func viewDidLoad() {
        super.viewDidLoad()
        height_of_collectionview.constant = 0
        height_of_tableview.constant = 0
        
        Utilities.shared.cornerRadius(objects: [btn_clickPrescriptionImages,btn_selectMedicine,btn_Done], number: 10.0)
        close.addTarget(self, action: #selector(closeAction), for: .touchUpInside)
     //   tf_doctorname.addTarget(self, action: #selector(handle_tf_doctorname), for: .editingChanged)
     //   tf_doctortype.addTarget(self, action: #selector(handle_tf_doctortype), for: .editingChanged)
        btn_clickPrescriptionImages.addTarget(self, action: #selector(Action_btn_clickPrescriptionImages), for: .touchUpInside)
        btn_selectMedicine.addTarget(self, action: #selector(Action_btn_selectMedicine), for: .touchUpInside)
        btn_Done.addTarget(self, action: #selector(Action_btn_Done), for: .touchUpInside)

     //   dropdown_doctorname.anchorView = tf_doctorname
        
//        dropdown_doctorname.direction = .bottom
//        dropdown_doctorname.bottomOffset = CGPoint(x: 0, y:(dropdown_doctorname.anchorView?.plainView.bounds.height)!)
//
//        dropdown_doctorname.width = self.tf_doctorname.frame.width
//
//        dropdown_doctorname.selectionAction = { [unowned self] (index: Int, item: String) in
//            self.tf_doctorname.text = item
//            let d = self.filter_doctorlist.object(at: index) as? NSDictionary
//            self.doctorid = "\(d?.value(forKey: "doctorId") as! Int)"
//            print("Selected item: \(item) at index: \(index)")
//        }
        
       // dropdown_doctortype.anchorView = tf_doctortype
        
//        dropdown_doctortype.direction = .bottom
//        dropdown_doctortype.bottomOffset = CGPoint(x: 0, y:(dropdown_doctortype.anchorView?.plainView.bounds.height)!)
//
//        dropdown_doctortype.width = self.tf_doctortype.frame.width
//
//        dropdown_doctortype.selectionAction = { [unowned self] (index: Int, item: String) in
//            self.tf_doctortype.text = item
//            print("Selected item: \(item) at index: \(index)")
//        }
//        DropDown.appearance().textFont = UIFont.boldSystemFont(ofSize: 15)

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
                        for (index,attachment) in attachmentArray.enumerated() {
                            attachment.loadOriginalImage(completion: { (image) in
                                let timestamp = Date().toMillis()
                                image?.accessibilityIdentifier = String(describing: timestamp)
                                let imagename = "\(String(describing: timestamp!)).jpg"
                                self.images.append(["name": imagename,"image" : image])
                            })
                        }
                        DispatchQueue.main.async {
                            self.height_of_collectionview.constant = attachmentArray.count > 0 ? 150 : 0
                            self.collectionview.reloadData()
                        }
                        self.pdfurl = URL(string: "NF")!
                    }, cancel: nil)
                    self.APC.mediaType = [.image]
                    self.APC.allowsMultipleSelection = true
                    self.APC.allowsSelectionFromOtherApps = false
                    
                    DispatchQueue.main.async {
                        self.APC.present(on: self)
                    }
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
        let addMedicineVC = self.storyboard?.instantiateViewController(withIdentifier: "AddMedicineViewController") as! AddMedicineViewController
     //   addMedicineVC.routeFromOtherVC = true
        addMedicineVC.getSelectedMedicine = { data in
            DispatchQueue.main.async {
                self.allmedicine = data
                self.height_of_tableview.constant = data.count > 0 ? 300 : 0
                self.tableview.reloadData()
            }
        }
        navigationController?.pushViewController(addMedicineVC, animated: true)
    }
    @objc func Action_btn_Done(){
        //        if (self.tf_doctorname.text?.isEmpty)! {
        //            Utilities.shared.showToast(text: "Write Doctor Name", duration: 3.0)
        //        }
        //        else if (self.tf_doctortype.text?.isEmpty)! {
        //            Utilities.shared.showToast(text: "Write Doctor Type", duration: 3.0)
        //        }
        if (self.tf_patientproblem.text?.isEmpty)! {
            Utilities.shared.showToast(text: "Write Patient Problem", duration: 3.0)
        }
        else if self.images.count == 0 {
            Utilities.shared.showToast(text: (self.btn_clickPrescriptionImages.titleLabel?.text!)!, duration: 3.0)
        }
        else {
            self.uploadprescription()
        }
    }
    func json(from object:Any) -> String? {
        guard let data = try? JSONSerialization.data(withJSONObject:  object, options: []) else
        {
            return nil
        }
        
        return String(data: data, encoding: String.Encoding.utf8)
    }
    func uploadprescription(){
        Utilities.shared.ShowLoaderView(view: self.view, Message: "Please Wait Adding Prescription")
        let uploadUrl = ApiServices.shared.baseUrl + "add-prescription-file"
        let header = ["Authorization": "Bearer \(bearertoken!)",
            "Content-Type": "application/json",
            "Accept": "application/json"]
        
        var Param = [String:Any]()
        //if self.tf_doctorname.text?.isEmpty == false {
        Param["doctorName"] = self.tf_doctorname.text!
        // Param["doctor_id"] = self.doctorid
        // }
        //if self.tf_doctortype.text?.isEmpty == false {
        Param["doctorType"] = self.tf_doctortype.text!
        // }
        //  if self.tf_patientproblem.text?.isEmpty == false {
        Param["patient_problem"] = self.tf_patientproblem.text!
        //  }
        //        if self.allmedicine.count > 0 {
        //            Param["medicines"] = (json(from: self.allmedicine)!)
        //        }
        
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                var imageindex = 0
                var mimetype = ""
                var data = Data()
                var image = UIImage()
                
                for item in self.images{
                    if self.pdfurl.absoluteString != "NF"{
                        data = try! Data(contentsOf: self.pdfurl)
                        mimetype = "application/pdf"
                    } else {
                        if let img = item["image"] as? UIImage{
                            data = img.jpegData(compressionQuality: 0.0)!
                            mimetype = "image/jpg"
                            image = img
                        }
                    }
                    
                    multipartFormData.append(data, withName: "p_added_by_patient[]", fileName: item["name"] as! String, mimeType: mimetype)
                    imageindex = imageindex + 1
                    
                    for (key, value) in Param {
                        multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key)
                    }
                }
        }, usingThreshold : SessionManager.multipartFormDataEncodingMemoryThreshold,
           to : uploadUrl,
           method: .post,
           headers: header)
        { (result) in
            switch result{
            case .success(let upload, _, _):
                upload.uploadProgress(closure: { (Progress) in
                    print("Upload Progress: \(Progress.fractionCompleted)")
                })
                upload.responseJSON { resp in
                    if let JSON = resp.result.value as? [String: Any] {
                        print("Response : ",JSON)
                        if let msg = JSON["msg"] as? String {
                            if msg == "success"{
                                if let pres = JSON["prescription"] as? [String:Any] {
                                    if let id = pres["id"] as? Int {
                                        if self.allmedicine.count > 0 {
                                            self.uploadmedicineby(prescription_id: id)
                                        } else {
                                            DispatchQueue.main.async {
                                                Utilities.shared.RemoveLoaderView()
                                                NotificationCenter.default.post(name: NSNotification.Name("reloaddata"), object: nil)
                                                Utilities.shared.showToast(text: "Prescription Added Successfully", duration: 3.0)
                                                self.navigationController?.popViewControllerWithFlipAnimation(Self: self)
                                            }
                                        }
                                    }
                                }
                            } else {
                                Utilities.shared.RemoveLoaderView()
                                Utilities.shared.showToast(text: msg, duration: 3.0)
                            }
                        } else {
                            Utilities.shared.RemoveLoaderView()
                            Utilities.shared.showToast(text: "Something Went Wrong", duration: 3.0)
                        }
                    }
                }
            case .failure(let encodingError):
                DispatchQueue.main.async {
                    Utilities.shared.RemoveLoaderView()
                    Utilities.shared.showToast(text: "Something Went Wrong", duration: 3.0)
                }
                print(encodingError)
            }
        }
    }
    func uploadmedicineby(prescription_id: Int){
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
                            Utilities.shared.showToast(text: "Prescription & Medicines Added Successfully", duration: 3.0)
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
                DispatchQueue.main.async {
                    Utilities.shared.RemoveLoaderView()
                    Utilities.shared.showToast(text: "Something Went Wrong", duration: 3.0)
                }
                print("catch medicine")
            }
        }) { () -> (Dictionary<String, Any>) in
            param
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
        if #available(iOS 13.0, *) {
            UIApplication.shared.statusBarStyle = .darkContent
        } else {
            // Fallback on earlier versions
            UIApplication.shared.statusBarStyle = .default
        }
     //   UIApplication.shared.statusBarStyle = .default
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
            dropdown_doctortype.hide()
            filter_doctortypelist = self.doctortypelist
            self.dropdown_doctortype.dataSource = self.filter_doctortypelist.map { $0["name"]! }
            print(self.dropdown_doctortype.dataSource.count)
            self.dropdown_doctortype.reloadAllComponents()
        } else {
            dropdown_doctortype.show()
            filter_doctortypelist = self.doctortypelist.filter { $0["name"]!
                                        .hasPrefixCheck(prefix: self.tf_doctortype.text!,
                                         isCaseSensitive: false) }.map { $0 }
            dropdown_doctortype.dataSource = self.filter_doctortypelist.map { $0["name"]! }
            print(self.dropdown_doctortype.dataSource.count)
            self.dropdown_doctortype.reloadAllComponents()
        }
    }
    @objc func handle_tf_doctorname(){
        if (self.tf_doctorname.text?.isEmpty)! {
            dropdown_doctorname.hide()
            filter_doctorlist = self.doctorlist
            self.dropdown_doctorname.dataSource = self.filter_doctorlist.map { ($0 as! NSDictionary).value(forKey: "doctorName") as! String}
            print(self.dropdown_doctorname.dataSource.count)
            self.dropdown_doctorname.reloadAllComponents()
        } else {
            dropdown_doctorname.show()
            filter_doctorlist = self.doctorlist.filter { (($0 as! NSDictionary).value(forKey: "doctorName") as! String).hasPrefixCheck(prefix: self.tf_doctorname.text!,
                isCaseSensitive: false) }.map { $0 } as NSArray
            dropdown_doctorname.dataSource = self.filter_doctorlist.map { ($0 as! NSDictionary).value(forKey: "doctorName") as! String }
            print(self.dropdown_doctorname.dataSource.count)
            self.dropdown_doctorname.reloadAllComponents()
        }
    }
}
extension AddPrescriptionViewController: UIDocumentPickerDelegate,UINavigationControllerDelegate{
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        let myURL = url as URL
        pdfurl = myURL
        let name = myURL.lastPathComponent
        DispatchQueue.main.async {
            var pdfimage = UIImage(named: "pdf")!
            if self.pdfThumbnail(url: myURL) != nil {
                pdfimage = self.pdfThumbnail(url: myURL)!
            }
            let data = ["name": name,"image" : pdfimage] as [String : Any]
            self.images.append(data)
            self.height_of_collectionview.constant = self.images.count > 0 ? 150 : 0
            self.collectionview.reloadData()
        }
        print("import result : \(myURL)")
    }
    func pdfThumbnail(url: URL, width: CGFloat = 120) -> UIImage? {
      guard let data = try? Data(contentsOf: url),
      let page = PDFDocument(data: data)?.page(at: 0) else {
        return nil
      }

      let pageSize = page.bounds(for: .mediaBox)
      let pdfScale = width / pageSize.width

      // Apply if you're displaying the thumbnail on screen
      let scale = UIScreen.main.scale * pdfScale
      let screenSize = CGSize(width: pageSize.width * scale,
                              height: pageSize.height * scale)

      return page.thumbnail(of: screenSize, for: .mediaBox)
    }
}
extension AddPrescriptionViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imagecollection", for: indexPath) as! imagecollection
        cell.images.image = self.images[indexPath.row]["image"] as? UIImage
        return cell
    }
    
}
extension AddPrescriptionViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.allmedicine.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "addmedicinecell") as! addmedicinecell
        cell.SetCellData(d: allmedicine[indexPath.row], indexPath: indexPath)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
class imagecollection: UICollectionViewCell {
    @IBOutlet var images: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        images.layer.cornerRadius = 5.0
        images.clipsToBounds = true
        images.layer.borderColor = UIColor.black.cgColor
        images.layer.borderWidth = 0.5
    }
}
