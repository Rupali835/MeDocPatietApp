//
//  PatientHomePageViewController.swift
//  MedocPatient
//
//  Created by Prem Sahni on 08/12/18.
//  Copyright © 2018 Kanishka. All rights reserved.
//

import UIKit

class PatientHomePageViewController: UIViewController {

    @IBOutlet var tableview: UITableView!
    
    let icons = [#imageLiteral(resourceName: "man.png"),#imageLiteral(resourceName: "chart"),#imageLiteral(resourceName: "prescription.png"),#imageLiteral(resourceName: "pills.png"),#imageLiteral(resourceName: "qr-code.png"),#imageLiteral(resourceName: "organization.png"),#imageLiteral(resourceName: "question.png"),#imageLiteral(resourceName: "star.png")]
    let titles = ["Profile","Reports","Prescription","Medicines","QR Code","Promotion","FAQ","Rating US"]
    
    override func viewDidLoad(){
        super.viewDidLoad()
      //  fetchDoctor()
        self.tableview.tableFooterView = UIView(frame: .zero)
        // Do any additional setup after loading the view.
    }
    override func viewWillLayoutSubviews() {
        navItem()
        self.navigationController?.navigationBar.applyNavigationGradient(colors: [UIColor(hexString: "673AB7"),UIColor(hexString: "512DA8")])
    }
    func navItem(){
        let title = UILabel()
        title.textColor = UIColor.white
        title.font = UIFont.boldSystemFont(ofSize: 25)
        title.text = "Medoc Patient"
        let titlebar = UIBarButtonItem(customView: title)
        self.navigationItem.leftBarButtonItem = titlebar
        
        let LogoutBar = UIBarButtonItem.itemWith(colorfulImage: #imageLiteral(resourceName: "power.png"), target: self, action: #selector(LogoutAction))
        self.navigationItem.rightBarButtonItem = LogoutBar
 
    }
    @objc func LogoutAction(){
        self.dismiss(animated: true, completion: nil)
    }
    func fetchDoctor(){
        ApiServices.shared.FetchGetRequestDataFromURL(vc: self, withOutBaseUrl: "doctors", parameter: [                                                                                                 "user_key" : "6cb6362cf70555f1c3f1e230bb1a9d98","query":"Toothache"], onSuccessCompletion: { 
            do {
               let json = try JSONSerialization.jsonObject(with: ApiServices.shared.data, options: .mutableContainers) as! NSDictionary
                print("json: \(json)")
                DispatchQueue.main.async {
                    self.tableview.reloadData()
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
        return tableView.frame.size.height - 100
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
            Prescriptionvc.status = "0"
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
            let Promotionvc = self.storyboard?.instantiateViewController(withIdentifier: "PromotionViewController") as! PromotionViewController
            Promotionvc.navigationItem.largeTitleDisplayMode = .never
            Promotionvc.navigationItem.title = titles[indexPath.row]
            self.navigationController?.pushViewController(Promotionvc, animated: true)
        }
        else if indexPath.row == 6{
            let FAQvc = self.storyboard?.instantiateViewController(withIdentifier: "FAQViewController") as! FAQViewController
            FAQvc.navigationItem.largeTitleDisplayMode = .never
            FAQvc.navigationItem.title = titles[indexPath.row]
            self.navigationController?.pushViewController(FAQvc, animated: true)
        }
        else if indexPath.row == 7{
            let RatingUsvc = self.storyboard?.instantiateViewController(withIdentifier: "RatingUsViewController") as! RatingUsViewController
            RatingUsvc.navigationItem.largeTitleDisplayMode = .never
            RatingUsvc.navigationItem.title = titles[indexPath.row]
            self.navigationController?.pushViewController(RatingUsvc, animated: true)
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.size.width / 3) - (10 + 5), height: 100)
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
