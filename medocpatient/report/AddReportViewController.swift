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
    
    var selectedPrescription = "0"
    var pdfurl = URL(string: "NF")!
    var imagename = ""
    var fourDigitNumber: String {
        var result = ""
        repeat {
            // Create a string with a random number 0...9999
            result = String(format:"%04d", arc4random_uniform(10000) )
        } while result.count < 4
        return result
    }
    
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
        Utilities.shared.cornerRadius(objects: [Done,selectPrescription,addAttachment,imagesPicView], number: 10)
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(change), name: NSNotification.Name("change"), object: nil)
        fetchPrescription()
    }
    func addReport(){
        
        SwiftLoader.show(title: "adding data", animated: true)
        self.uploadimage()
        ApiServices.shared.FetchformPostDataFromUrl(vc: self, withOutBaseUrl: "reportstore", bearertoken: bearertoken!, parameter: "prescription_id=\(self.selectedPrescription)&image_name=[{ \"dataName\": \"\(imagename)\",\"dataTag\": \"\(self.textfield.text!)\" }]", onSuccessCompletion: {
            do {
                let json = try JSONSerialization.jsonObject(with: ApiServices.shared.data, options: .mutableContainers) as! NSDictionary
                if let msg = json.value(forKey: "msg") as? String{
                    if msg == "success" {
                        
                    }
                }
                DispatchQueue.main.async {
                   // SwiftLoader.hide()
                }
                print("data:\(json)")
            } catch {
                DispatchQueue.main.async {
                    SwiftLoader.hide()
                }
                print("catch")
            }
        }, HttpBodyCompletion: { () -> (Dictionary<String, Any>) in
            [:]
        })
    }
    func uploadimage(){
        //SwiftLoader.show(title: "adding image", animated: true)
//
//        if let text = self.Filetitle.text {
//            if text == "capturedimage"{
//                let name = fourDigitNumber
//                imagename = "img\(name).jpg"
//            }
//            else if !text.contains(find: "jpg") {
//                let removedot = text.replacingOccurrences(of: ".", with: "")
//                imagename = removedot.appending(".jpg")
//            }
//            else {
//                imagename = text
//            }
//        }
        print("prescription_id: \(self.selectedPrescription)")
        print("dataName:\(imagename)")
        print("dataTag:\(self.textfield.text!)")
        ApiServices.shared.FetchMultiformDataWithImageFromUrl(vc: self, withOutBaseUrl: "add_files", parameter: nil, bearertoken: bearertoken!, image: self.imagesPicView.image!, filename: imagename, filePathKey: "images[]", pdfurl: pdfurl, onSuccessCompletion: {
            do {
                let json = try JSONSerialization.jsonObject(with: ApiServices.shared.data, options: .mutableContainers) as! NSDictionary
                if let msg = json.value(forKey: "msg") as? String{
                    if msg == "success" {
                        self.dismiss(animated: true, completion: {
                            self.view.showToast("Report Added Successfully", position: .bottom, popTime: 1, dismissOnTap: true)
                        })
                    }
                }
                DispatchQueue.main.async {
                    SwiftLoader.hide()
                }
                print("image:\(json)")
            } catch {
                DispatchQueue.main.async {
                    SwiftLoader.hide()
                }
                print("image catch")
            }
        }) { () -> (Dictionary<String, Any>) in
            [:]
        }
    }
    @objc func doneAction(){
//        if (selectPrescription.titleLabel?.text)! == "Select Prescription"{
//            view.showToast("not selected Prescription", position: .bottom, popTime: 3, dismissOnTap: true)
//        }
        if Filetitle.text == ""{
            view.showToast("Not Selected Image", position: .bottom, popTime: 3, dismissOnTap: true)
        }
        else if (textfield.text?.isEmpty)! {
            view.showToast("Write Tag", position: .bottom, popTime: 3, dismissOnTap: true)
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
        SwiftLoader.show(animated: true)
        self.idarray.removeAll()
        self.problemArray.removeAll()
        ApiServices.shared.FetchGetDataFromUrl(vc: self, withOutBaseUrl: "prescriptionsgeneral", parameter: "", bearertoken: bearertoken!, onSuccessCompletion: {
            do {
                let decode = try JSONDecoder().decode(PrescriptionsGeneral.self, from: ApiServices.shared.data)
                self.prescriptionsgeneral = [decode]
                DispatchQueue.global(qos: .userInteractive).async {
                    for item in self.prescriptionsgeneral {
                        self.prescriptionsgeneraldata = item.data ?? [PrescriptionsGeneralData]()
                    }
                    for item in self.prescriptionsgeneraldata{
                        self.idarray.append(item.prescription_id!)
                        self.problemArray.append(item.patientProblem!)
                    }
                    self.dropdown.dataSource = self.problemArray
                }
                
                DispatchQueue.main.async {
                    self.dropdown.reloadAllComponents()
                    SwiftLoader.hide()
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
        self.textfield.endEditing(true)

        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PrescriptionViewController") as! PrescriptionViewController
        vc.status = "1"
        
        if self.prescriptionsgeneraldata.count == 0{
            self.view.showToast("No Prescription Found", position: .top, popTime: 5, dismissOnTap: true)
        }
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
        self.textfield.endEditing(true)
        Alert.shared.choose(vc: self, ActionCompletion: {
            print("image")
            PHPhotoLibrary.requestAuthorization { (status) in
                if status == PHAuthorizationStatus.notDetermined {
                    self.addAttachmentAction()
                } else {
                    self.APC = DBAttachmentPickerController(finishPicking: { (attachmentArray) in
                        // let attachment = self.attachmentArray[0] as! DBAttachment
                       // self.Filetitle.text = attachmentArray[0].fileName
                        attachmentArray[0].loadOriginalImage(completion: { (image) in
                            let timestamp = Date().toMillis()
                            image?.accessibilityIdentifier = String(describing: timestamp)
                            self.imagename = "\(String(describing: timestamp!)).jpg"
                            self.Filetitle.text = self.imagename
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
//extension AddReportViewController: UIPickerViewDelegate,UIPickerViewDataSource{
//    func numberOfComponents(in pickerView: UIPickerView) -> Int {
//        return 1
//    }
//    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//        return self.prescriptionsgeneraldata.count
//    }
//    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        return self.prescriptionsgeneraldata[row].patientProblem!
//    }
//    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        if self.prescriptionsgeneraldata.count == 0{
//
//        } else {
//            self.BloodGroupTF.text = self.prescriptionsgeneraldata[row].patientProblem!
//        }
//    }
//    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
//        return 45
//    }
//    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
//        var label: UILabel
//        if let view = view as? UILabel{
//            label = view
//        } else {
//            label = UILabel()
//        }
//        label.textColor = UIColor.black
//        label.textAlignment = .center
//        label.font = UIFont.boldSystemFont(ofSize: 20)
//        label.text = self.prescriptionsgeneraldata[row].patientProblem!
//
//        return label
//    }
//}

extension AddReportViewController: UIDocumentPickerDelegate,UINavigationControllerDelegate{
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        let myURL = url as URL
        pdfurl = myURL
        self.imagename = myURL.lastPathComponent
        self.Filetitle.text = myURL.lastPathComponent
        self.imagesPicView.image = #imageLiteral(resourceName: "placeholder--pdf.png")
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
