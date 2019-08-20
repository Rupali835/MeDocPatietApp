//
//  AddReportViewController.swift
//  MedocPatient
//
//  Created by Prem Sahni on 12/12/18.
//  Copyright © 2018 Kanishka. All rights reserved.
//

import UIKit
import DBAttachmentPickerController
import CoreData
import DropDown
import MobileCoreServices
import Alamofire

class AddReportViewController: UIViewController,DBAssetPickerControllerDelegate {
    
    let bearertoken = UserDefaults.standard.string(forKey: "bearertoken")

    @IBOutlet var close : UIButton!
    
    @IBOutlet var Done: UIButton!
    @IBOutlet var selectPrescription: UIButton!
    
    @IBOutlet var tf_reportname: UITextField!
    @IBOutlet var addAttachment: UIButton!
    
    @IBOutlet var collectionview: UICollectionView!
    @IBOutlet var height_of_collectionview: NSLayoutConstraint!
    
    let dropdown = DropDown()
    var prescriptionObject = [NSManagedObject]()
    
    var attachmentArray : NSMutableArray = []
    var APC = DBAttachmentPickerController()
    var idarray = [String]()
    var problemArray = [String]()
    
    var selectedPrescription = "0"
    var pdfurl = URL(string: "NF")!
    var images = [[String:Any]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        height_of_collectionview.constant = 0

        self.selectPrescription.setTitle("Select Prescription", for: .normal)
        addAttachment.addTarget(self, action: #selector(addAttachmentAction), for: .touchUpInside)
        close.addTarget(self, action: #selector(closeAction), for: .touchUpInside)
        
        selectPrescription.addTarget(self, action: #selector(addPrescription), for: .touchUpInside)
        self.attachmentArray = NSMutableArray.init(capacity: 10)
        Done.addTarget(self, action: #selector(doneAction), for: .touchUpInside)
        dropdown.anchorView = selectPrescription
        dropdown.bottomOffset = CGPoint(x: 0, y:(dropdown.anchorView?.plainView.bounds.height)!)
        DropDown.appearance().textFont = UIFont.boldSystemFont(ofSize: 18)
        Utilities.shared.cornerRadius(objects: [Done,selectPrescription,addAttachment], number: 10)
        
        dropdown.dataSource = problemArray
        dropdown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.selectPrescription.setTitle(item, for: .normal)
            print("Selected item: \(item) at index: \(index)")
            self.selectedPrescription = self.idarray[index]
        }
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        UIApplication.shared.statusBarStyle = .default
    }
    override func viewWillDisappear(_ animated: Bool) {
        UIApplication.shared.statusBarStyle = .lightContent
    }
    func json(from object:Any) -> String? {
        guard let data = try? JSONSerialization.data(withJSONObject:  object, options: []) else
        {
            return nil
        }
        
        return String(data: data, encoding: String.Encoding.utf8)
    }
    func addReport(){
        Utilities.shared.ShowLoaderView(view: self.view, Message: "Adding Report")
        var array = [[String: Any]]()
        for (index,data) in self.images.enumerated() {
            let newdata = ["dataName": data["dataName"]!,"dataTag": data["dataTag"]!]
            array.append(newdata)
        }
        let stringarr = json(from: array)!
        print(stringarr)
        uploadfiles()
        ApiServices.shared.FetchformPostDataFromUrl(vc: self, Url: ApiServices.shared.baseUrl + "reportstore", bearertoken: bearertoken!, parameter: "prescription_id=\(self.selectedPrescription)&image_name=\(stringarr)", onSuccessCompletion: {
            do {
                let json = try JSONSerialization.jsonObject(with: ApiServices.shared.data, options: .mutableContainers) as! NSDictionary
                if let msg = json.value(forKey: "msg") as? String{
                    if msg == "success" {
                        DispatchQueue.main.async {
                            Utilities.shared.RemoveLoaderView()
                        }
                    }
                }
                print("data:\(json)")
            } catch {
                print("catch")
            }
        })
    }
    func uploadfiles(){
        let uploadUrl = ApiServices.shared.medocDoctorUrl + "add_files"
        let header = ["Authorization": "Bearer \(bearertoken!)"]
        
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
                    
                    let data = image.jpegData(compressionQuality: 0.0)
                    print("images" + String(format:"%d",imageindex))
                    
                    multipartFormData.append(data!, withName: "images[]", fileName: item["dataName"] as! String, mimeType: mimetype)
                    imageindex = imageindex + 1
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
                        let msg = JSON["msg"] as? String
                        if msg == "success"{
                            NotificationCenter.default.post(name: NSNotification.Name("reloaddata"), object: nil)
                            Utilities.shared.showToast(text: "Report Added Successfully", duration: 3.0)
                            self.navigationController?.popViewControllerWithFlipAnimation(Self: self)
                        } else {
                            print(msg)
                        }
                    }
                }
            case .failure(let encodingError):
                print(encodingError)
            }
        }
    }
  
    @objc func doneAction(){
        if self.selectedPrescription == "0"{
            Utilities.shared.showToast(text: "Select Prescription", duration: 3.0)
        }
        else if self.images.count == 0{
            Utilities.shared.showToast(text: (self.addAttachment.titleLabel?.text!)!, duration: 3.0)
        }
        else if (tf_reportname.text?.isEmpty)! {
            Utilities.shared.showToast(text: "Write Report Name", duration: 3.0)
        }
        else {
            Utilities.shared.alertview(title: "Are You Sure", msg: "You Want To Add Reports?", dismisstitle: "No", mutlipleButtonAdd: { (alert) in
                alert.addButton("Yes", font: UIFont.boldSystemFont(ofSize: 20), color: UIColor.orange, titleColor: UIColor.white) { (action) in
                    self.images[0]["dataTag"] = self.tf_reportname.text!
                    self.addReport()
                    alert.dismissAlertView()
                }
            }, dismissAction: { })
        }
    }
    
    @objc func addPrescription(){
        self.tf_reportname.endEditing(true)
        if self.idarray.count == 0{
            Utilities.shared.alertview(title: "Alert", msg: "You Can't Add Report Because No Prescription Suggested For You", dismisstitle: "Back", mutlipleButtonAdd: { (alert) in
                alert.addButton("Ok", font: UIFont.boldSystemFont(ofSize: 20), color: UIColor.orange, titleColor: UIColor.white) { (action) in
                    alert.dismissAlertView()
                    self.navigationController?.popViewControllerWithFlipAnimation(Self: self)
                   // self.dismiss(animated: true, completion: nil)
                }
            }, dismissAction: {
                self.navigationController?.popViewControllerWithFlipAnimation(Self: self)
               // self.dismiss(animated: true, completion: nil)
            })
        } else {
            dropdown.show()
        }
    }
    @objc func addAttachmentAction(){
        self.tf_reportname.endEditing(true)
        Alert.shared.choose(sender: addAttachment, vc: self, ActionCompletion: {
            print("image")
            PHPhotoLibrary.requestAuthorization { (status) in
                if status == PHAuthorizationStatus.notDetermined {
                    self.addAttachmentAction()
                } else {
                    self.APC = DBAttachmentPickerController(finishPicking: { (attachmentArray) in
                        for (index,attachment) in attachmentArray.enumerated() {
                            attachment.loadOriginalImage(completion: { (image) in
                                let timestamp = Date().toMillis()
                                image?.accessibilityIdentifier = String(describing: timestamp)
                                let imagename = "\(String(describing: timestamp!)).jpg"
                                self.images.append(["dataName": imagename,"dataTag": self.tf_reportname.text!,"image" : image])
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
    @objc func closeAction(){
       // self.dismiss(animated: true, completion: nil)
        navigationController?.popViewControllerWithFlipAnimation(Self: self)
    }
}
extension AddReportViewController: UIDocumentPickerDelegate,UINavigationControllerDelegate{
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        let myURL = url as URL
        pdfurl = myURL
        let name = myURL.lastPathComponent
        self.images.append(["dataName": name,"dataTag": self.tf_reportname.text!,"image" : #imageLiteral(resourceName: "placeholder--pdf.png")])
        DispatchQueue.main.async {
            self.collectionview.reloadData()
        }
    }
}
extension AddReportViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imagecollection", for: indexPath) as! imagecollection
        cell.images.image = self.images[indexPath.row]["image"] as? UIImage
        return cell
    }
    
}
