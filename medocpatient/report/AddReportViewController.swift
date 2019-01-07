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
class AddReportViewController: UIViewController,DBAssetPickerControllerDelegate {
    
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
        dropdown.dataSource = ["dd1","dd2"]
        DropDown.appearance().textFont = UIFont.boldSystemFont(ofSize: 18)
        // Do any additional setup after loading the view.
    }
    @objc func doneAction(){
        if (selectPrescription.titleLabel?.text)! == "Select Prescription Of Report"{
            view.showToast("not selected Prescription", position: .bottom, popTime: 3, dismissOnTap: true)
        }
        else if imagesPicView.image == nil || Filetitle.text == ""{
            view.showToast("not selected images", position: .bottom, popTime: 3, dismissOnTap: true)
        }
        else if (textfield.text?.isEmpty)! {
            view.showToast("Write Remark", position: .bottom, popTime: 3, dismissOnTap: true)
        }
        else {
            let appdel = UIApplication.shared.delegate as! AppDelegate
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
            self.dismiss(animated: true) {}
        }
    }
    @objc func addPrescription(){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PrescriptionViewController") as! PrescriptionViewController
        vc.status = "1"
        dropdown.show()
        dropdown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.selectPrescription.setTitle(item, for: .normal)
            print("Selected item: \(item) at index: \(index)")
        }
        //self.present(vc, animated: true, completion: nil)
    }
    @objc func Reload(){
        self.imageCollectionView.reloadData()
    }
    override func viewDidAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(change), name: NSNotification.Name("change"), object: nil)
        
    }
    @objc func change(notification : NSNotification){
        if let Buttontitle = notification.userInfo?["title"] as? String{
            self.selectPrescription.setTitle(Buttontitle, for: .normal)
        }
    }
    @objc func addAttachmentAction(){
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
        
    }
    @objc func closeAction(){
        self.dismiss(animated: true, completion: nil)
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
