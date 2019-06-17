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
import WebKit
import SVGKit

class PatientHomePageViewController: UIViewController{
    
    @IBOutlet var hometitle: UILabel!
    @IBOutlet var tableview: UITableView!
    @IBOutlet var imagesPicView: UIImageView!
    @IBOutlet var Name: UILabel!
    @IBOutlet var DateOfBirth: UILabel!
    @IBOutlet var Gender: UILabel!
    @IBOutlet var cornerview: UIView!
    
    @IBOutlet var infoBtn: UIButton!
    @IBOutlet var logoutBtn: UIButton!

    @IBOutlet var followupBtn: UIButton!
    var Prescriptiondata = NSArray()

    @IBOutlet var headerview: UIView!
    @IBOutlet var height_of_header_contraint: NSLayoutConstraint!
    
    //let icons = [#imageLiteral(resourceName: "users"),#imageLiteral(resourceName: "reports"),#imageLiteral(resourceName: "prescription.png"),#imageLiteral(resourceName: "pills.png"),#imageLiteral(resourceName: "qrcode.png"),#imageLiteral(resourceName: "cardiogram"),#imageLiteral(resourceName: "question"),#imageLiteral(resourceName: "my-space.png"),#imageLiteral(resourceName: "support.png"),#imageLiteral(resourceName: "reading.png"),#imageLiteral(resourceName: "family.png")]
    let icons = ["group.svg","report.svg","prescription.svg","pills.svg","qr-code.svg","hospital.svg","question.svg","teamwork.svg","customer-support.svg","guide.svg","family.svg"]
    let titles = ["Profile","Reports","Prescription","Medicines","QR Code","Health","FAQ","About us","Contact us","Disha Guideline","Family"]
    let appdel = UIApplication.shared.delegate as! AppDelegate
    let user = User()
    let bearertoken = UserDefaults.standard.string(forKey: "bearertoken")
    var dict = NSDictionary()
    let spacing: CGFloat = 1
    
    override func viewDidLoad(){
        super.viewDidLoad()
        Utilities.shared.cornerRadius(objects: [imagesPicView], number: imagesPicView.frame.width / 2)
        Utilities.shared.cornerRadius(objects: [cornerview], number: cornerview.frame.width / 2)
        infoBtn.addTarget(self, action: #selector(infodetails), for: .touchUpInside)
        logoutBtn.addTarget(self, action: #selector(LogoutAction), for: .touchUpInside)
        self.tableview.tableFooterView = UIView(frame: .zero)
        self.hometitle.text = "Welcome To Medoc !".localized()
        fetchPrescription()
        followupBtn.addTarget(self, action: #selector(ActionFollowUp), for: .touchUpInside)
        // Do any additional setup after loading the view.
    }
    @objc func ActionFollowUp(){
        let Prescriptionvc = self.storyboard?.instantiateViewController(withIdentifier: "PrescriptionViewController") as! PrescriptionViewController
        Prescriptionvc.navigationItem.title = "Prescription".localized()
        self.splitnavigate(vc: Prescriptionvc)
    }
    func fetchPrescription(){
        ApiServices.shared.FetchGetDataFromUrl(vc: self, Url: ApiServices.shared.baseUrl + "prescriptions", bearertoken: bearertoken!, onSuccessCompletion: {
            do {
                let json = try JSONSerialization.jsonObject(with: ApiServices.shared.data, options: .mutableContainers) as! NSDictionary
                if let msg = json.value(forKey: "msg") as? String {
                    if msg == "success" {
                        if let p_data = json.value(forKey: "data") as? NSArray{
                            self.Prescriptiondata = p_data
                            DispatchQueue.main.async {
                                self.followupBtn.setTitle("Follow Up \(self.Prescriptiondata.count) Times", for: .normal)
                            }
                        }
                    }
                }
            } catch {
                print("catch")
            }
        })
    }
    override func viewWillLayoutSubviews() {
        navItem()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    override func viewDidAppear(_ animated: Bool) {
        Name.text = UserDefaults.standard.string(forKey: "name")
        let img = UserDefaults.standard.string(forKey: "profile_image")
        imagesPicView.sd_setImage(with: URL(string: "\(ApiServices.shared.imageorpdfUrl)\(img!)"), placeholderImage: #imageLiteral(resourceName: "man.png"), options: .continueInBackground, completed: nil)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Show the navigation bar on other view controllers
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    func fetchlogout() {
        ApiServices.shared.FetchGetDataFromUrl(vc: self, Url: ApiServices.shared.baseUrl + "logout", bearertoken: bearertoken!) {
            do {
                let json = try JSONSerialization.jsonObject(with: ApiServices.shared.data, options: .mutableContainers) as! NSDictionary
                let msg = json.value(forKey: "msg") as? String ?? ""
                if msg == "Successfully logged out" {
                    DispatchQueue.main.async {
                        UserDefaults.standard.set(false, forKey: "Logged")
                        UserDefaults.standard.set("nil", forKey: "bearertoken")
                        UserDefaults.standard.synchronize()
                        self.appdel.SwitchLogin()
                        Utilities.shared.showToast(text: msg, duration: 3.0)
                    }
                } else {
                    print(json)
                    DispatchQueue.main.async {
                        Utilities.shared.showToast(text: msg, duration: 3.0)
                    }
                }
            } catch {
                print("catch")
            }
        }
    }
    func navItem(){
        let title = UILabel()
        title.textColor = UIColor.white
        title.font = UIFont.boldSystemFont(ofSize: 23)
        title.text = "Welcome To Medoc !".localized()//"MeDoc"
        let titlebar = UIBarButtonItem(customView: title)
        self.navigationItem.leftBarButtonItem = titlebar
        
        let LogoutBar = UIBarButtonItem.itemWith(colorfulImage: #imageLiteral(resourceName: "power.png"), target: self, action: #selector(LogoutAction))
        let info = UIBarButtonItem.itemWith(colorfulImage: #imageLiteral(resourceName: "info"), target: self, action: #selector(infodetails))
        self.navigationItem.rightBarButtonItems = [LogoutBar,info]
 
    }
    
    @objc func infodetails(){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "TimeInfoViewController") as! TimeInfoViewController
        self.present(vc, animated: true, completion: nil)
    }
    @objc func LogoutAction(){
        Utilities.shared.alertview(title: "Alert".localized(), msg: "Are You Sure, Do You Want to Logout?".localized(), dismisstitle: "No".localized(), mutlipleButtonAdd: { (alert) in
            alert.addButton("Yes".localized(), font: UIFont.boldSystemFont(ofSize: 20), color: UIColor.orange, titleColor: UIColor.white) { (action) in
                self.fetchlogout()
                alert.dismissAlertView()
            }
        }, dismissAction: { })
    }
    @IBAction func go_to_PHQ_VC(sender: UIButton){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PHQ_9ViewController") as! PHQ_9ViewController
        self.splitnavigate(vc: vc)
       // self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func changeLanguage(_ sender: UIButton) {
        let alertvc = UIAlertController(title: "Choose Language", message: nil, preferredStyle: .actionSheet)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let english = UIAlertAction(title: "English", style: .default) { (action) in
            Bundle.setLanguage(lang: "en")
            self.updatelanguage()
        }
        let hindi = UIAlertAction(title: "Hindi", style: .default) { (action) in
            Bundle.setLanguage(lang: "hi")
            self.updatelanguage()
        }
        let marathi = UIAlertAction(title: "Marathi", style: .default) { (action) in
            Bundle.setLanguage(lang: "mr")
            self.updatelanguage()
        }
        alertvc.addAction(english)
        alertvc.addAction(hindi)
        alertvc.addAction(marathi)
        alertvc.addAction(cancel)
        
        alertvc.popoverPresentationController?.sourceView = sender
        alertvc.popoverPresentationController?.sourceRect = sender.bounds
        alertvc.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.any;
        
        self.present(alertvc, animated: true, completion: nil)
    }
    func updatelanguage(){
        self.hometitle.text = "Welcome To Medoc !".localized()
        self.navItem()
        self.tableview.reloadData()
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
        cell.icon.image = SVGKImage(named: icons[indexPath.row])?.uiImage
        cell.title.text = titles[indexPath.row].localized()
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let title = titles[indexPath.row].localized()
        if indexPath.row == 0 {
            let Profilevc = self.storyboard?.instantiateViewController(withIdentifier: "ProfilePageViewController") as! ProfilePageViewController
            Profilevc.navigationItem.title = title
            self.splitnavigate(vc: Profilevc)
           // self.navigationController?.pushViewController(Profilevc, animated: true)
        }
        else if indexPath.row == 1{
            let Reportvc = self.storyboard?.instantiateViewController(withIdentifier: "ReportViewController") as! ReportViewController
            Reportvc.navigationItem.title = title
            self.splitnavigate(vc: Reportvc)
            //self.navigationController?.pushViewController(Reportvc, animated: true)
        }
        else if indexPath.row == 2{
            let Prescriptionvc = self.storyboard?.instantiateViewController(withIdentifier: "PrescriptionViewController") as! PrescriptionViewController
            Prescriptionvc.navigationItem.title = title
            self.splitnavigate(vc: Prescriptionvc)
           // self.navigationController?.pushViewController(Prescriptionvc, animated: true)
        }
        else if indexPath.row == 3{
            let Medicinevc = self.storyboard?.instantiateViewController(withIdentifier: "MedicineViewController") as! MedicineViewController
            Medicinevc.navigationItem.title = title
            self.splitnavigate(vc: Medicinevc)
           // self.navigationController?.pushViewController(Medicinevc, animated: true)
        }
        else if indexPath.row == 4{
            let qrvc = self.storyboard?.instantiateViewController(withIdentifier: "QRViewController") as! QRViewController
            qrvc.navigationItem.title = title
            self.splitnavigate(vc: qrvc)
            //self.navigationController?.pushViewController(qrvc, animated: true)
        }
        else if indexPath.row == 5{
            let Healthvc = self.storyboard?.instantiateViewController(withIdentifier: "HealthViewController") as! HealthViewController
            Healthvc.navigationItem.title = title
            self.splitnavigate(vc: Healthvc)
           // self.navigationController?.pushViewController(Healthvc, animated: true)
        }
        else if indexPath.row == 6{
            let FAQvc = self.storyboard?.instantiateViewController(withIdentifier: "FAQViewController") as! FAQViewController
            FAQvc.navigationItem.title = title
            self.splitnavigate(vc: FAQvc)
           // self.navigationController?.pushViewController(FAQvc, animated: true)
        }
        else if indexPath.row == 7{
            let Aboutvc = self.storyboard?.instantiateViewController(withIdentifier: "AboutUsViewController") as! AboutUsViewController
            Aboutvc.navigationItem.title = title
            self.splitnavigate(vc: Aboutvc)
           // self.navigationController?.pushViewController(Aboutvc, animated: true)
        }
        else if indexPath.row == 8{
            let contactvc = self.storyboard?.instantiateViewController(withIdentifier: "ContactUsViewController") as! ContactUsViewController
            contactvc.navigationItem.title = title
            self.splitnavigate(vc: contactvc)
            //self.navigationController?.pushViewController(contactvc, animated: true)
        }
        else if indexPath.row == 9{
            let pdfVC = UIViewController()
            let url = Bundle.main.url(forResource: "R_4179_1521627488625_0", withExtension: "pdf")
            let webView = WKWebView()
            webView.translatesAutoresizingMaskIntoConstraints = false
            pdfVC.view.addSubview(webView)
            
            webView.leadingAnchor.constraint(equalTo: pdfVC.view.safeAreaLayoutGuide.leadingAnchor).isActive = true
            webView.trailingAnchor.constraint(equalTo: pdfVC.view.safeAreaLayoutGuide.trailingAnchor).isActive = true
            webView.topAnchor.constraint(equalTo: pdfVC.view.safeAreaLayoutGuide.topAnchor).isActive = true
            webView.bottomAnchor.constraint(equalTo: pdfVC.view.bottomAnchor).isActive = true
            
            let urlRequest = URLRequest(url: url!)
            //webView.navigationDelegate = self
            webView.load(urlRequest)
            
            pdfVC.navigationItem.title = title
            pdfVC.view.backgroundColor = UIColor.white
            self.splitnavigate(vc: pdfVC)
            //self.navigationController?.pushViewController(pdfVC, animated: true)
        }
        else if indexPath.row == 10{
            let familyvc = self.storyboard?.instantiateViewController(withIdentifier: "FamilyViewController") as! FamilyViewController
            familyvc.navigationItem.title = title
            self.splitnavigate(vc: familyvc)
           // self.navigationController?.pushViewController(familyvc, animated: true)
        }
    }
    func splitnavigate(vc: UIViewController){
        let detailvc = UINavigationController(rootViewController: vc)
        detailvc.navigationBar.barTintColor = #colorLiteral(red: 0.2117647059, green: 0.09411764706, blue: 0.3294117647, alpha: 1)
        detailvc.navigationBar.tintColor = UIColor.white
        detailvc.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.splitViewController?.showDetailViewController(detailvc, sender: self)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return CGSize(width: (collectionView.frame.size.width / 3) - (spacing + spacing/2), height: (collectionView.frame.size.width / 2.65) - (spacing + spacing/2))
        }
        else {
            return CGSize(width: (collectionView.frame.size.width / 2) - (spacing + spacing/2), height: (collectionView.frame.size.width / 2) - (spacing + spacing/2))
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return spacing
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return spacing
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
    }
}
