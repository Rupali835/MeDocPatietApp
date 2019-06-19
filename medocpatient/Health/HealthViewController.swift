//
//  HealthViewController.swift
//  medocpatient
//
//  Created by iAM on 09/01/19.
//  Copyright © 2019 kspl. All rights reserved.
//

import UIKit
import ZAlertView
import SVGKit

class HealthViewController: UIViewController {
    let bearertoken = UserDefaults.standard.string(forKey: "bearertoken")

    @IBOutlet var tableview: UITableView!
    var list = ["Blood Pressure","Weight","Height","Temperature"]
    let images = ["blood-pressure.svg","scale.svg","height-limit.svg","thermometer.svg"]
    var Prescriptiondata = NSArray()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableview.tableFooterView = UIView(frame: .zero)
        NetworkManager.isReachable { _ in
            self.fetchPrescription()
        }
        NetworkManager.sharedInstance.reachability.whenReachable = { _ in
            self.fetchPrescription()
        }
        NetworkManager.isUnreachable { _ in
            self.tableview.isHidden = true
            Utilities.shared.centermsg(msg: "No Internet Connection", view: self.view)
        }
        // Do any additional setup after loading the view.
    }
    func fetchPrescription(){
        Utilities.shared.ShowLoaderView(view: self.view, Message: "Please Wait..")
        ApiServices.shared.FetchGetDataFromUrl(vc: self, Url: ApiServices.shared.baseUrl + "prescriptions", bearertoken: bearertoken!, onSuccessCompletion: {
            do {
                let json = try JSONSerialization.jsonObject(with: ApiServices.shared.data, options: .mutableContainers) as! NSDictionary
                print(json)
                if let msg = json.value(forKey: "msg") as? String {
                    if msg == "success" {
                        if let p_data = json.value(forKey: "data") as? NSArray{
                            self.Prescriptiondata = p_data
                            Utilities.shared.removecentermsg()
                        }
                    }
                }
                DispatchQueue.main.async {
                    self.tableview.isHidden = false
                    self.tableview.reloadData()
                    Utilities.shared.RemoveLoaderView()
                }
            } catch {
                print("catch")
                DispatchQueue.main.async {
                    Utilities.shared.RemoveLoaderView()
                    Utilities.shared.ActionToast(text: "Something Went Wrong", actionTitle: "Retry", actionHandler: {
                        self.fetchPrescription()
                    })
                }
            }
        })
    }
}
extension HealthViewController: UITableViewDataSource , UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.list.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LatestData") as! LatestDataTableViewCell
        //cell.accessoryType = .disclosureIndicator
        cell.type_name.text = self.list[indexPath.row]
        cell.type_img.image = SVGKImage(named: self.images[indexPath.row])?.uiImage
        cell.value.text = "No Data Found"

        if self.Prescriptiondata.count > 0 {
            let d1 = self.Prescriptiondata.object(at: self.Prescriptiondata.count - 1) as! NSDictionary
            let created_at = d1.value(forKey: "created_at") as! String
            
            if indexPath.row == 0{
                if let blood_pressure = d1.value(forKey: "blood_pressure") as? String {
                    cell.value.text = blood_pressure//"Blood Pressure: \(blood_pressure)"
                }
            }
            if indexPath.row == 1{
                if let weight = d1.value(forKey: "weight") as? Int{
                    cell.value.text = "\(weight) Kg"//"Weight: \(weight) Kg"
                }
                else if let weight = d1.value(forKey: "weight") as? String{
                    if weight == "NF" {
                        cell.value.text = weight//"Weight: \(weight)"
                    } else {
                        cell.value.text = "\(weight) Kg"//"Weight: \(weight) Kg"
                    }
                }
            }
            if indexPath.row == 2{
                if let height = d1.value(forKey: "height") as? Int{
                    cell.value.text = "\(height) Cm"//"Height: \(height) Cm"
                }
                else if let height = d1.value(forKey: "height") as? String{
                    cell.value.text = height//"Height: \(height)"
                }
            }
            if indexPath.row == 3{
                if let temperature = d1.value(forKey: "temperature") as? Int {
                    cell.value.text = "\(temperature) ºC"//"Temperature: \(temperature) ºC"
                }
                else if let temperature = d1.value(forKey: "temperature") as? String {
                    if temperature == "NF"{
                        cell.value.text = temperature//"Temperature: \(temperature)"
                    } else {
                        cell.value.text = "\(temperature) ºC"//Temperature: \(temperature) ºC"
                    }
                }
            }
            let df = DateFormatter()
            df.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let date = df.date(from: created_at)
            
            let df1 = DateFormatter()
            df1.dateFormat = "dd MMM yyyy HH:mm:ss"
            let datestr = df1.string(from: date!)
            
            let dateSeparate = datestr.components(separatedBy: .whitespaces)
            
            cell.date.text = dateSeparate[0]
            cell.month.text = dateSeparate[1]
            cell.year.text = dateSeparate[2]
            cell.time.text = dateSeparate[3]
            
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if Prescriptiondata.count > 0 {
            let cell = self.tableview.cellForRow(at: indexPath) as! LatestDataTableViewCell
            let chartvc = self.storyboard?.instantiateViewController(withIdentifier: "ChartViewController") as! ChartViewController
            chartvc.selectedtitle = self.list[indexPath.row]
            chartvc.dataarr = self.Prescriptiondata
            chartvc.typeimage = cell.type_img.image!
            //self.navigationController?.pushViewController(chartvc, animated: true)
            self.navigationController?.pushViewControllerWithFlipAnimation(Self: self, pushVC: chartvc)
        }
    }
   
}

