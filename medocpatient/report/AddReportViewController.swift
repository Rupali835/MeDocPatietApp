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

class AddReportViewController: UIViewController,DBAssetPickerControllerDelegate {
    
    let bearertoken = UserDefaults.standard.string(forKey: "bearertoken")

    @IBOutlet var close : UIButton!
    
    @IBOutlet var Done: UIButton!
    @IBOutlet var selectPrescription: UIButton!
    
    @IBOutlet var textfield: UITextField!
    @IBOutlet var addAttachment: UIButton!
    var images: NSArray! = []
    
    @IBOutlet var imagesPicView: UIImageView!

    let dropdown = DropDown()
    var prescriptionObject = [NSManagedObject]()
    
    var attachmentArray : NSMutableArray = []
    var APC = DBAttachmentPickerController()
    var idarray = [String]()
    var problemArray = [String]()
    
    var selectedPrescription = "0"
    var pdfurl = URL(string: "NF")!
    var imagename = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addAttachment.addTarget(self, action: #selector(addAttachmentAction), for: .touchUpInside)
        close.addTarget(self, action: #selector(closeAction), for: .touchUpInside)
        
        selectPrescription.addTarget(self, action: #selector(addPrescription), for: .touchUpInside)
        self.attachmentArray = NSMutableArray.init(capacity: 10)
        Done.addTarget(self, action: #selector(doneAction), for: .touchUpInside)
        dropdown.anchorView = selectPrescription
        dropdown.bottomOffset = CGPoint(x: 0, y:(dropdown.anchorView?.plainView.bounds.height)!)
        DropDown.appearance().textFont = UIFont.boldSystemFont(ofSize: 18)
        Utilities.shared.cornerRadius(objects: [Done,selectPrescription,addAttachment,imagesPicView], number: 10)
        
        dropdown.dataSource = problemArray
        dropdown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.selectPrescription.setTitle(item, for: .normal)
            print("Selected item: \(item) at index: \(index)")
            self.selectedPrescription = self.idarray[index]
        }
        // Do any additional setup after loading the view.
    }
    func addReport(){
        Utilities.shared.ShowLoaderView(view: self.view, Message: "Adding Report")
        self.uploadimage()
        ApiServices.shared.FetchformPostDataFromUrl(vc: self, withOutBaseUrl: "reportstore", bearertoken: bearertoken!, parameter: "prescription_id=\(self.selectedPrescription)&image_name=[{ \"dataName\": \"\(imagename)\",\"dataTag\": \"\(self.textfield.text!)\" }]", onSuccessCompletion: {
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
        }, HttpBodyCompletion: { () -> (Dictionary<String, Any>) in
            [:]
        })
    }
    func uploadimage(){
        print("prescription_id: \(self.selectedPrescription)")
        print("dataName:\(imagename)")
        print("dataTag:\(self.textfield.text!)")
        ApiServices.shared.FetchMultiformDataWithImageFromUrl(vc: self, withOutBaseUrl: "add_files", parameter: nil, bearertoken: bearertoken!, image: self.imagesPicView.image!, filename: imagename, filePathKey: "images[]", pdfurl: pdfurl, onSuccessCompletion: {
            do {
                let json = try JSONSerialization.jsonObject(with: ApiServices.shared.data, options: .mutableContainers) as! NSDictionary
                if let msg = json.value(forKey: "msg") as? String{
                    if msg == "success" {
                        self.dismiss(animated: true, completion: {
                            NotificationCenter.default.post(name: NSNotification.Name("reloaddata"), object: nil)
                            self.view.showToast("Report Added Successfully", position: .bottom, popTime: 1, dismissOnTap: true)
                        })
                    }
                }
                print("image:\(json)")
            } catch {
                print("image catch")
            }
        }) { () -> (Dictionary<String, Any>) in
            [:]
        }
    }
    @objc func doneAction(){
        if imagesPicView.image == nil{
            view.showToast("Not Selected Image", position: .bottom, popTime: 3, dismissOnTap: true)
        }
        else if (textfield.text?.isEmpty)! {
            view.showToast("Write Report Name", position: .bottom, popTime: 3, dismissOnTap: true)
        }
        else {
            Utilities.shared.alertview(title: "Are You Sure", msg: "You Want To Add Reports?", dismisstitle: "No", mutlipleButtonAdd: { (alert) in
                alert.addButton("Yes", font: UIFont.boldSystemFont(ofSize: 20), color: UIColor.orange, titleColor: UIColor.white) { (action) in
                    self.addReport()
                    alert.dismissAlertView()
                }
            }, dismissAction: { })
        }
    }
    
    @objc func addPrescription(){
        self.textfield.endEditing(true)
        dropdown.show()
    }
    @objc func addAttachmentAction(){
        self.textfield.endEditing(true)
        Alert.shared.choose(vc: self, ActionCompletion: {
            print("image")
            PHPhotoLibrary.requestAuthorization { (status) in
                if status == PHAuthorizationStatus.notDetermined {
                    self.addAttachmentAction()
                } else {
                    self.APC = DBAttachmentPickerController(finishPicking: { (attachmentArray) in
                        attachmentArray[0].loadOriginalImage(completion: { (image) in
                            let timestamp = Date().toMillis()
                            image?.accessibilityIdentifier = String(describing: timestamp)
                            self.imagename = "\(String(describing: timestamp!)).jpg"
                            self.imagesPicView.image = image
                            self.pdfurl = URL(string: "NF")!
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
    @objc func closeAction(){
        self.dismiss(animated: true, completion: nil)
    }
}
extension AddReportViewController: UIDocumentPickerDelegate,UINavigationControllerDelegate{
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        let myURL = url as URL
        pdfurl = myURL
        self.imagename = myURL.lastPathComponent
        self.imagesPicView.image = #imageLiteral(resourceName: "placeholder--pdf.png")
        print("import result : \(myURL)")
    }
}
