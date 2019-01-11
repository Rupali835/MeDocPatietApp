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
    @IBOutlet weak var imageCollectionView: UICollectionView!
    var images: NSArray! = []
    
    @IBOutlet var imagesPicView: UIImageView!
    @IBOutlet var deleteButton: UIButton!
    @IBOutlet var Filetitle: UILabel!
    let dropdown = DropDown()
    var prescriptionObject = [NSManagedObject]()
    
    var attachmentArray : NSMutableArray = []
    var APC = DBAttachmentPickerController()
    var idarray = [String]()
    var problemArray = [String]()
    var prescriptionsgeneral = [PrescriptionsGeneral]()
    var prescriptionsgeneraldata = [PrescriptionsGeneralData]()
    
    var selectedPrescription = ""
    var pdfurl = URL(string: "NF")!
    var path = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        addAttachment.addTarget(self, action: #selector(addAttachmentAction), for: .touchUpInside)
        close.addTarget(self, action: #selector(closeAction), for: .touchUpInside)
        NotificationCenter.default.addObserver(self, selector: #selector(Reload), name: NSNotification.Name("Reload"), object: nil)
//        imageCollectionView.reloadData()
//        self.imageCollectionView!.dataSource = self
//        self.imageCollectionView!.delegate = self
        selectPrescription.addTarget(self, action: #selector(addPrescription), for: .touchUpInside)
        self.attachmentArray = NSMutableArray.init(capacity: 10)
        Done.addTarget(self, action: #selector(doneAction), for: .touchUpInside)
        dropdown.arrowIndicationX = selectPrescription.frame.width / 2
        dropdown.anchorView = selectPrescription
        dropdown.bottomOffset = CGPoint(x: 0, y:(dropdown.anchorView?.plainView.bounds.height)!)
        DropDown.appearance().textFont = UIFont.boldSystemFont(ofSize: 18)
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(change), name: NSNotification.Name("change"), object: nil)
        fetchPrescription()
    }
    func addReport(){
        print("prescription_id: \(self.selectedPrescription)")
        print("image_name:\(self.Filetitle.text!)")
        print("tag:\(self.textfield.text!)")
        print("report_file:\(self.path)")
        let param = [
            "prescription_id": self.selectedPrescription,
            "image_name":self.Filetitle.text!,
            "tag":self.textfield.text!,
        ]
        ApiServices.shared.FetchMultiformDataWithImageFromUrl(vc: self, withOutBaseUrl: "reportstore", parameter: param, bearertoken: bearertoken!, image: self.imagesPicView, filename: self.Filetitle.text!, filePathKey: "report_file", pdfurl: pdfurl, onSuccessCompletion: {
            do {
                let json = try JSONSerialization.jsonObject(with: ApiServices.shared.data, options: .mutableContainers) as! NSDictionary
                DispatchQueue.main.async {
                    SwiftLoader.hide()
                }
                print(json)
            } catch {
                DispatchQueue.main.async {
                    SwiftLoader.hide()
                }
                print("catch")
            }
        }) { () -> (Dictionary<String, Any>) in
            [:]
        }
    }
    @objc func doneAction(){
        if (selectPrescription.titleLabel?.text)! == "Select Prescription Of Report"{
            view.showToast("not selected Prescription", position: .bottom, popTime: 3, dismissOnTap: true)
        }
        else if Filetitle.text == ""{
            view.showToast("not selected images", position: .bottom, popTime: 3, dismissOnTap: true)
        }
        else if (textfield.text?.isEmpty)! {
            view.showToast("Write Remark", position: .bottom, popTime: 3, dismissOnTap: true)
        }
        else {
            addReport()
           /* let appdel = UIApplication.shared.delegate as! AppDelegate
            let conttxt = appdel.persistentContainer.viewContext
            let singleitem = Reports(context: conttxt)
            singleitem.aboutReport = textfield.text
            let imgdata: Data = (imagesPicView.image?.pngData())!
            singleitem.reportimage = imgdata
            singleitem.selectedPrescription = selectPrescription.titleLabel?.text
            let fmt = DateFormatter()
            fmt.dateFormat = "dd/MM/yyyy"
            singleitem.date = fmt.string(from: Date())
            //pretitle  attachReport
            
            appdel.saveContext()
            NotificationCenter.default.post(name: NSNotification.Name("reload"), object: self)
            self.dismiss(animated: true) {}*/
        }
    }
    func fetchPrescription(){
        ApiServices.shared.FetchGetDataFromUrl(vc: self, withOutBaseUrl: "prescriptionsgeneral", parameter: "", bearertoken: bearertoken!, onSuccessCompletion: {
            do {
                let decode = try JSONDecoder().decode(PrescriptionsGeneral.self, from: ApiServices.shared.data)
                self.prescriptionsgeneral = [decode]
                DispatchQueue.global(qos: .userInteractive).async {
                    for item in self.prescriptionsgeneral {
                        self.prescriptionsgeneraldata = item.data!
                    }
                    for item in self.prescriptionsgeneraldata{
                        self.idarray.append(item.prescription_id!)
                        self.problemArray.append(item.patientProblem!)
                    }
                    self.dropdown.dataSource = self.problemArray
                }
                
                DispatchQueue.main.async {
                    self.dropdown.reloadAllComponents()
                }
//                let json = try JSONSerialization.jsonObject(with: ApiServices.shared.data, options: .mutableContainers) as! NSDictionary
//                print(json)
//                if let msg = json.value(forKey: "msg") as? String {
//                    if msg == "success"{
//                        if let data = json.value(forKey: "data") as? NSArray{
//                            let prescription_id = data.value(forKey: "prescription_id") as! String
//                            self.dropdown.reloadAllComponents()
//                            for item in 0...data.count {
//                                self.idarray.append(prescription_id)
//                            }
//                        }
//                    }
//                }
            } catch {
                print("catch")
                DispatchQueue.main.async {
                    self.view.showToast("No Patient Id Found", position: .bottom, popTime: 3, dismissOnTap: true)
                }
            }
        }) { () -> (Dictionary<String, Any>) in
            [:]
        }
    }
    @objc func addPrescription(){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PrescriptionViewController") as! PrescriptionViewController
        vc.status = "1"
        
        dropdown.show()
        dropdown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.selectPrescription.setTitle(item, for: .normal)
            print("Selected item: \(item) at index: \(index)")
            self.selectedPrescription = self.idarray[index]
        }
        //self.present(vc, animated: true, completion: nil)
    }
    @objc func Reload(){
        self.imageCollectionView.reloadData()
    }
    @objc func change(notification : NSNotification){
        if let Buttontitle = notification.userInfo?["title"] as? String{
            self.selectPrescription.setTitle(Buttontitle, for: .normal)
        }
    }
    @objc func addAttachmentAction(){
        Alert.shared.choose(vc: self, ActionCompletion: {
            print("image")
            PHPhotoLibrary.requestAuthorization { (status) in
                if status == PHAuthorizationStatus.notDetermined {
                    self.addAttachmentAction()
                } else {
                    self.APC = DBAttachmentPickerController(finishPicking: { (attachmentArray) in
                        // let attachment = self.attachmentArray[0] as! DBAttachment
                        self.Filetitle.text = attachmentArray[0].fileName
                        attachmentArray[0].loadOriginalImage(completion: { (image) in
                            self.imagesPicView.image = image
                            
                        })
                        
                    }, cancel: nil)
                    self.APC.mediaType = [.other,.image]
                    self.APC.allowsMultipleSelection = false
                    self.APC.allowsSelectionFromOtherApps = true
                    self.APC.present(on: self)
                    
                }
                
            }
        }) {
            print("pdf")
            
            let documentPicker = UIDocumentPickerViewController(documentTypes: [String(kUTTypePDF),String(kUTTypePNG),String(kUTTypeJPEG)], in: .import)
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
        self.Filetitle.text = myURL.lastPathComponent
        print("import result : \(myURL)")
    }
}
//
//extension AddReportViewController: UICollectionViewDelegate, UICollectionViewDataSource {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return self.attachmentArray.count
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = imageCollectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as! imageCell
//
//
////        cell.images.image =  self.images.object(at: (indexPath as NSIndexPath).item) as? UIImage
////        print(self.images)
////        cell.deleteButton.tag = (indexPath as NSIndexPath).item
////        cell.deleteButton.addTarget(self, action: #selector(AddReportViewController.deletePhotoImage(_:)), for: .touchUpInside)
//        return cell
//    }
//    @objc func deletePhotoImage(_ sender: UIButton!) {
//        let mutableImages: NSMutableArray! = NSMutableArray.init(array: images)
//        mutableImages.removeObject(at: sender.tag)
//        print(sender.tag)
//        self.images = NSArray.init(array: mutableImages)
//        self.imageCollectionView.performBatchUpdates({
//            self.imageCollectionView.deleteItems(at: [IndexPath.init(item: sender.tag, section: 0)])
//        }, completion: { (finished) in
//            self.imageCollectionView.reloadItems(at: self.imageCollectionView.indexPathsForVisibleItems)
//        })
//
//    }
//
//}
