//
//  PatientHomePageViewController.swift
//  MedocPatient
//
//  Created by Prem Sahni on 08/12/18.
//  Copyright © 2018 Kanishka. All rights reserved.
//

import UIKit
import CoreData
import SDWebImage

class PatientHomePageViewController: UIViewController{
    
    @IBOutlet var tableview: UITableView!
    @IBOutlet var imagesPicView: UIImageView!
    @IBOutlet var Name: UILabel!
    @IBOutlet var DateOfBirth: UILabel!
    @IBOutlet var Gender: UILabel!
    @IBOutlet var cornerview: UIView!
    
    @IBOutlet var infoBtn: UIButton!
    @IBOutlet var logoutBtn: UIButton!

    @IBOutlet var headerview: UIView!
    
    let icons = [#imageLiteral(resourceName: "users.png"),#imageLiteral(resourceName: "reports.png"),#imageLiteral(resourceName: "prescription.png"),#imageLiteral(resourceName: "pills.png"),#imageLiteral(resourceName: "qrcode.png"),#imageLiteral(resourceName: "cardiogram.png"),#imageLiteral(resourceName: "question.png"),#imageLiteral(resourceName: "my-space.png"),#imageLiteral(resourceName: "support.png")]
    let titles = ["Profile","Reports","Prescription","Medicines","QR Code","Health","FAQ","About us","Contact us"]
    let appdel = UIApplication.shared.delegate as! AppDelegate
    let user = User()
    let bearertoken = UserDefaults.standard.string(forKey: "bearertoken")
    var dict = NSDictionary()
    
    override func viewDidLoad(){
        super.viewDidLoad()
        Utilities.shared.cornerRadius(objects: [imagesPicView], number: imagesPicView.frame.width / 2)
        Utilities.shared.cornerRadius(objects: [cornerview], number: cornerview.frame.width / 2)
        infoBtn.addTarget(self, action: #selector(infodetails), for: .touchUpInside)
        logoutBtn.addTarget(self, action: #selector(LogoutAction), for: .touchUpInside)
        self.tableview.tableFooterView = UIView(frame: .zero)
        // Do any additional setup after loading the view.
    }
    override func viewWillLayoutSubviews() {
        navItem()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //fetchProfileDatail()
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    override func viewDidAppear(_ animated: Bool) {
        Name.text = UserDefaults.standard.string(forKey: "name")
        let img = UserDefaults.standard.string(forKey: "profile_image")
        imagesPicView.sd_setImage(with: URL(string: "http://www.otgmart.com/medoc/medoc_doctor_api/uploads/\(img!)"), placeholderImage: #imageLiteral(resourceName: "man.png"), options: .continueInBackground, completed: nil)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Show the navigation bar on other view controllers
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    func navItem(){
        let title = UILabel()
        title.textColor = UIColor.white
        title.font = UIFont.boldSystemFont(ofSize: 23)
        title.text = "MeDoc"
        let titlebar = UIBarButtonItem(customView: title)
        self.navigationItem.leftBarButtonItem = titlebar
        
        let LogoutBar = UIBarButtonItem.itemWith(colorfulImage: #imageLiteral(resourceName: "power.png"), target: self, action: #selector(LogoutAction))
        let info = UIBarButtonItem.itemWith(colorfulImage: #imageLiteral(resourceName: "icons8-info-50.png"), target: self, action: #selector(infodetails))
        self.navigationItem.rightBarButtonItems = [LogoutBar,info]
 
    }
    @objc func infodetails(){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "TimeInfoViewController") as! TimeInfoViewController
        self.present(vc, animated: true, completion: nil)
    }
    @objc func LogoutAction(){
        Utilities.shared.alertview(title: "Alert", msg: "Are You Sure, Do You Want to Logout?", dismisstitle: "No", mutlipleButtonAdd: { (alert) in
            alert.addButton("Yes", font: UIFont.boldSystemFont(ofSize: 20), color: UIColor.orange, titleColor: UIColor.white) { (action) in
                DispatchQueue.main.async {
                    UserDefaults.standard.set(false, forKey: "Logged")
                    UserDefaults.standard.set("nil", forKey: "bearertoken")
                    UserDefaults.standard.synchronize()
                    self.appdel.SwitchLogin()
                }
                alert.dismissAlertView()
            }
        }, dismissAction: { })
    }
    func fetchProfileDatail(){
        ApiServices.shared.FetchGetDataFromUrl(vc: self, withOutBaseUrl: "patientprofile", parameter: "", bearertoken: bearertoken!, onSuccessCompletion: {
            do {
                self.dict = try JSONSerialization.jsonObject(with: ApiServices.shared.data, options: .mutableContainers) as! NSDictionary
                let msg = self.dict.value(forKey: "msg") as? String ?? ""
                if msg == "success" {
                    if let data = self.dict.value(forKey: "data") as? NSDictionary {
                        DispatchQueue.main.async {
                            let pp = data.value(forKey: "profile_picture") as? String ?? ""
                            if pp != ""{
                                let url = URL(string: "http://www.otgmart.com/medoc/medoc_doctor_api/uploads/\(pp)")!
                                self.imagesPicView.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "man.png"), options: .continueInBackground, completed: nil)
                            }
                            else {
                                self.imagesPicView.image = #imageLiteral(resourceName: "man.png")
                            }
                            let name = data.value(forKey: "name") as? String ?? ""
                            self.Name.text = "\(name)"
                        }
                    }
                }
            } catch {
                print("catch")
            }
        }) { () -> (Dictionary<String, Any>) in
            [:]
        }
    }
}
extension PatientHomePageViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! PatientTableViewCell
        cell.collectionview.reloadData()
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.size.height
    }
}
extension PatientHomePageViewController: UICollectionViewDataSource, UICollectionViewDelegate , UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! PatientHomePageCollectionViewCell
        cell.icon.image = icons[indexPath.row]
        cell.title.text = titles[indexPath.row]
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let Profilevc = self.storyboard?.instantiateViewController(withIdentifier: "ProfilePageViewController") as! ProfilePageViewController
            Profilevc.navigationItem.largeTitleDisplayMode = .never
            Profilevc.navigationItem.title = titles[indexPath.row]
            self.navigationController?.pushViewController(Profilevc, animated: true)
        }
        else if indexPath.row == 1{
            let Reportvc = self.storyboard?.instantiateViewController(withIdentifier: "ReportViewController") as! ReportViewController
            Reportvc.navigationItem.largeTitleDisplayMode = .never
            Reportvc.navigationItem.title = titles[indexPath.row]
            self.navigationController?.pushViewController(Reportvc, animated: true)
        }
        else if indexPath.row == 2{
            let Prescriptionvc = self.storyboard?.instantiateViewController(withIdentifier: "PrescriptionViewController") as! PrescriptionViewController
            Prescriptionvc.navigationItem.largeTitleDisplayMode = .never
            Prescriptionvc.navigationItem.title = titles[indexPath.row]
            self.navigationController?.pushViewController(Prescriptionvc, animated: true)
        }
        else if indexPath.row == 3{
            let Medicinevc = self.storyboard?.instantiateViewController(withIdentifier: "MedicineViewController") as! MedicineViewController
            Medicinevc.navigationItem.largeTitleDisplayMode = .never
            Medicinevc.navigationItem.title = titles[indexPath.row]
            self.navigationController?.pushViewController(Medicinevc, animated: true)
        }
        else if indexPath.row == 4{
            let qrvc = self.storyboard?.instantiateViewController(withIdentifier: "QRViewController") as! QRViewController
            qrvc.navigationItem.largeTitleDisplayMode = .never
            qrvc.navigationItem.title = titles[indexPath.row]
            self.navigationController?.pushViewController(qrvc, animated: true)
        }
        else if indexPath.row == 5{
            let Healthvc = self.storyboard?.instantiateViewController(withIdentifier: "HealthViewController") as! HealthViewController
            Healthvc.navigationItem.largeTitleDisplayMode = .never
            Healthvc.navigationItem.title = titles[indexPath.row]
//            Utilities.shared.alertview(title: "Sorry", msg: "Health Module is Not Completed Now", dismisstitle: "Ok", mutlipleButtonAdd: { (alert) in
//
//            }, dismissAction: { })
            self.navigationController?.pushViewController(Healthvc, animated: true)
        }
        else if indexPath.row == 6{
            let FAQvc = self.storyboard?.instantiateViewController(withIdentifier: "FAQViewController") as! FAQViewController
            FAQvc.navigationItem.largeTitleDisplayMode = .never
            FAQvc.navigationItem.title = titles[indexPath.row]
            self.navigationController?.pushViewController(FAQvc, animated: true)
        }
        else if indexPath.row == 7{
            let Aboutvc = self.storyboard?.instantiateViewController(withIdentifier: "AboutUsViewController") as! AboutUsViewController
            Aboutvc.navigationItem.largeTitleDisplayMode = .never
            Aboutvc.navigationItem.title = titles[indexPath.row]
            self.navigationController?.pushViewController(Aboutvc, animated: true)
        }
        else if indexPath.row == 8{
            let contactvc = self.storyboard?.instantiateViewController(withIdentifier: "ContactUsViewController") as! ContactUsViewController
            contactvc.navigationItem.largeTitleDisplayMode = .never
            contactvc.navigationItem.title = titles[indexPath.row]
            self.navigationController?.pushViewController(contactvc, animated: true)
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.size.width / 3) - (10 + 5), height: (collectionView.frame.size.width / 3) - (10 + 5))
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
}
