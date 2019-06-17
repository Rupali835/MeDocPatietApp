//
//  HealthViewController.swift
//  medocpatient
//
//  Created by iAM on 09/01/19.
//  Copyright © 2019 kspl. All rights reserved.
//

import UIKit
import ZAlertView

class HealthViewController: UIViewController {
    let bearertoken = UserDefaults.standard.string(forKey: "bearertoken")

    @IBOutlet var tableview: UITableView!
    let list = ["Blood Pressure","Weight","Height","Temperature"]
    var Prescriptiondata = NSArray()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableview.tableFooterView = UIView(frame: .zero)
        fetchPrescription()
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
                        }
                    }
                }
                DispatchQueue.main.async {
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
        cell.accessoryType = .disclosureIndicator
        if indexPath.row == 0{
            if self.Prescriptiondata.count > 0{
                let d1 = self.Prescriptiondata.object(at: self.Prescriptiondata.count - 1) as! NSDictionary
                let created_at1 = d1.value(forKey: "created_at") as! String
                if let blood_pressure = d1.value(forKey: "blood_pressure") as? String {
                    cell.firstdata.text = "Blood Pressure: \(blood_pressure)"
                }
                cell.seconddata.text = ""
                cell.date.text = "Date: \(created_at1)"
            } else {
                cell.firstdata.text = "Blood Pressure"
                cell.seconddata.text = ""
                cell.date.text = "No Data Found"
            }
        }
        if indexPath.row == 1{
            if self.Prescriptiondata.count > 0{
                let d1 = self.Prescriptiondata.object(at: self.Prescriptiondata.count - 1) as! NSDictionary
                let created_at1 = d1.value(forKey: "created_at") as! String
                if let weight = d1.value(forKey: "weight") as? Int{
                    cell.firstdata.text = "Weight: \(weight) Kg"
                }
                else if let weight = d1.value(forKey: "weight") as? String{
                    if weight == "NF" {
                        cell.firstdata.text = "Weight: \(weight)"
                    } else {
                        cell.firstdata.text = "Weight: \(weight) Kg"
                    }
                }
                cell.seconddata.text = ""
                cell.date.text = "Date: \(created_at1)"
            } else {
                cell.firstdata.text = "Weight"
                cell.seconddata.text = ""
                cell.date.text = "No Data Found"
            }
        }
        if indexPath.row == 2{
            if self.Prescriptiondata.count > 0{
                let d1 = self.Prescriptiondata.object(at: self.Prescriptiondata.count - 1) as! NSDictionary
                let created_at1 = d1.value(forKey: "created_at") as! String
                if let height = d1.value(forKey: "height") as? Int{
                    cell.firstdata.text = "Height: \(height) Cm"
                }
                else if let height = d1.value(forKey: "height") as? String{
                    cell.firstdata.text = "Height: \(height)"
                }
                cell.seconddata.text = ""
                cell.date.text = "Date: \(created_at1)"
            } else {
                cell.firstdata.text = "Height"
                cell.seconddata.text = ""
                cell.date.text = "No Data Found"
            }
        }
        if indexPath.row == 3{
            if self.Prescriptiondata.count > 0{
                let d1 = self.Prescriptiondata.object(at: self.Prescriptiondata.count - 1) as! NSDictionary
                let created_at1 = d1.value(forKey: "created_at") as! String
                if let temperature = d1.value(forKey: "temperature") as? Int {
                    cell.firstdata.text = "Temperature: \(temperature) ºC"
                }
                else if let temperature = d1.value(forKey: "temperature") as? String {
                    if temperature == "NF"{
                        cell.firstdata.text = "Temperature: \(temperature)"
                    } else {
                        cell.firstdata.text = "Temperature: \(temperature) ºC"
                    }
                }
                cell.seconddata.text = ""
                cell.date.text = "Date: \(created_at1)"
            } else {
                cell.firstdata.text = "Temperature"
                cell.seconddata.text = ""
                cell.date.text = "No Data Found"
            }
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if Prescriptiondata.count > 0 {
            let chartvc = self.storyboard?.instantiateViewController(withIdentifier: "ChartViewController") as! ChartViewController
            chartvc.selectedtitle = self.list[indexPath.row]
            chartvc.dataarr = self.Prescriptiondata
            self.navigationController?.pushViewController(chartvc, animated: true)
        }
    }
   
}

