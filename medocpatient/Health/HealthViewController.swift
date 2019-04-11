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
    
    var alertwithtext = ZAlertView()
    var bp_dataarr = NSArray()
    var w_dataarr = NSArray()
    var h_dataarr = NSArray()
    var t_dataarr = NSArray()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableview.tableFooterView = UIView(frame: .zero)
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        fetchhealthdata(attr: "bp")
        fetchhealthdata(attr: "w")
        fetchhealthdata(attr: "h")
        fetchhealthdata(attr: "t")
    }
    func fetchhealthdata(attr: String){
        ApiServices.shared.FetchGetDataFromUrl(vc: self, withOutBaseUrl: "viewhealthdata/\(attr)/m/0/0", parameter: "", bearertoken: bearertoken!, onSuccessCompletion: {
            do {
                let json = try JSONSerialization.jsonObject(with: ApiServices.shared.data, options: .mutableContainers) as! NSDictionary
                if let msg = json.value(forKey: "msg") as? String {
                    if msg == "success"{
                        if let data = json.value(forKey: "data") as? NSArray{
                            if attr == "bp"{
                                self.bp_dataarr = data
                                self.fetchhealthdata(attr: "w")
                                print("bpdata-\(self.bp_dataarr)")
                            }
                            else if attr == "w"{
                                self.w_dataarr = data
                                self.fetchhealthdata(attr: "h")
                                print("wdata-\(self.w_dataarr)")
                            }
                            else if attr == "h"{
                                self.h_dataarr = data
                                self.fetchhealthdata(attr: "t")
                                print("hdata-\(self.h_dataarr)")
                            }
                            else if attr == "t"{
                                self.t_dataarr = data
                                print("tdata-\(self.t_dataarr)")
                            }
                            DispatchQueue.main.async {
                                self.tableview.reloadData()
                            }
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
extension HealthViewController: UITableViewDataSource , UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.list.count
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "healthcell") as! HealthListTableViewCell
        cell.title.text = self.list[indexPath.row]
        cell.delegate = self
        if indexPath.section == 1{
            let cell2 = tableView.dequeueReusableCell(withIdentifier: "LatestData") as! LatestDataTableViewCell
            cell2.accessoryType = .disclosureIndicator
            if indexPath.row == 0{
                if self.bp_dataarr.count > 0{
                    let d1 = self.bp_dataarr.object(at: self.bp_dataarr.count - 1) as! NSDictionary
                    let created_at1 = d1.value(forKey: "created_at") as! String
                    let blood_pressure = d1.value(forKey: "blood_pressure") as! String
                    cell2.firstdata.text = "Blood Pressure: \(blood_pressure)"
                    cell2.seconddata.text = ""
                    cell2.date.text = "Date: \(created_at1)"
                } else {
                    cell2.firstdata.text = "Blood Pressure"
                    cell2.seconddata.text = ""
                    cell2.date.text = "No Data Found"
                }
            }
            if indexPath.row == 1{
                if self.w_dataarr.count > 0{
                    let d1 = self.w_dataarr.object(at: self.w_dataarr.count - 1) as! NSDictionary
                    let created_at1 = d1.value(forKey: "created_at") as! String
                    let weight = d1.value(forKey: "weight") as! String
                    cell2.firstdata.text = "Weight: \(weight) Kg"
                    cell2.seconddata.text = ""
                    cell2.date.text = "Date: \(created_at1)"
                } else {
                    cell2.firstdata.text = "Weight"
                    cell2.seconddata.text = ""
                    cell2.date.text = "No Data Found"
                }
            }
            if indexPath.row == 2{
                if self.h_dataarr.count > 0{
                    let d1 = self.h_dataarr.object(at: self.h_dataarr.count - 1) as! NSDictionary
                    let created_at1 = d1.value(forKey: "created_at") as! String
                    let height = d1.value(forKey: "height") as! String
                    cell2.firstdata.text = "Height: \(height) Cm"
                    cell2.seconddata.text = ""
                    cell2.date.text = "Date: \(created_at1)"
                } else {
                    cell2.firstdata.text = "Height"
                    cell2.seconddata.text = ""
                    cell2.date.text = "No Data Found"
                }
            }
            if indexPath.row == 3{
                if self.t_dataarr.count > 0{
                    let d1 = self.t_dataarr.object(at: self.t_dataarr.count - 1) as! NSDictionary
                    let created_at1 = d1.value(forKey: "created_at") as! String
                    let temperature = d1.value(forKey: "temperature") as! String
                    cell2.firstdata.text = "Temperature: \(temperature) "
                    cell2.seconddata.text = ""
                    cell2.date.text = "Date: \(created_at1)"
                } else {
                    cell2.firstdata.text = "Temperature"
                    cell2.seconddata.text = ""
                    cell2.date.text = "No Data Found"
                }
            }
            return cell2
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1{
            return 80
        }
        return 50
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1{
            let chartvc = self.storyboard?.instantiateViewController(withIdentifier: "ChartViewController") as! ChartViewController
            chartvc.selectedtitle = self.list[indexPath.row]
            self.navigationController?.pushViewController(chartvc, animated: true)
        }
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return ["Add Health Data","Show Latest & All Data"][section]
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
}
extension HealthViewController: HealthListTableViewCelldelegate , UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let limitLength = 3
        let newLength = textField.text!.count + string.count - range.length
        return newLength <= limitLength
    }
    func indexpath(cell: HealthListTableViewCell) {
        if let indexPath = tableview.indexPath(for: cell){
            let selectedtitle = cell.title.text
            if selectedtitle == "Blood Pressure"{
                addbloodpressure()
            }
            else if selectedtitle == "Height"{
                addheight()
            }
            else if selectedtitle == "Weight"{
                addWeight()
            }
            else if selectedtitle == "Temperature"{
                addTemperature()
            }
            else {
                print("none")
            }
        }
    }
    func postApi(param : [String:String]){
        ApiServices.shared.FetchPostDataFromUrl(vc: self, withOutBaseUrl: "addhealthdata", bearertoken: bearertoken!, parameter: "", onSuccessCompletion: {
            do {
                let json = try JSONSerialization.jsonObject(with: ApiServices.shared.data, options: .mutableContainers) as! NSDictionary
                print(json)
                DispatchQueue.main.async {
                    self.alertwithtext.dismissAlertView()
                }
            } catch {
                DispatchQueue.main.async {
                    self.alertwithtext.dismissAlertView()
                }
                print("catch")
            }
        }) { () -> (Dictionary<String, Any>) in
            param
        }
    }
    func addbloodpressure(){
        alertwithtext = ZAlertView(title: "Write Blood Pressure", message: "", isOkButtonLeft: false, okButtonText: "Add", cancelButtonText: "Cancel", okButtonHandler: { (send) in
            
            let txt1 = self.alertwithtext.getTextFieldWithIdentifier("Systolic")!
            let txt2 = self.alertwithtext.getTextFieldWithIdentifier("Diastolic")!
            print(txt1.text!)
            print(txt2.text!)
            txt1.delegate = self
            txt2.delegate = self

            if (txt1.text?.isEmpty)! && (txt2.text?.isEmpty)! {
                self.view.showToast("Write Systolic & Diastolic", position: .bottom, popTime: 3, dismissOnTap: false)
            }
            else if (txt1.text?.isEmpty)!{
                self.view.showToast("Write Systolic", position: .bottom, popTime: 3, dismissOnTap: false)
            }
            else if (txt2.text?.isEmpty)!{
                self.view.showToast("Write Diastolic", position: .bottom, popTime: 3, dismissOnTap: false)
            }
            else if (txt1.text?.characters.count)! > 3 || (txt1.text?.characters.count)! < 2 {
                self.view.showToast("Invalid Systolic", position: .bottom, popTime: 3, dismissOnTap: false)
            }
            else if (txt2.text?.characters.count)! > 3 || (txt2.text?.characters.count)! < 2 {
                self.view.showToast("Invalid Diastolic", position: .bottom, popTime: 3, dismissOnTap: false)
            }
            else {
                Utilities.shared.ShowLoaderView(view: self.view, Message: "Adding Blood Pressure")
                self.postApi(param: ["systolic" : txt1.text!,
                                     "diastolic": txt2.text!])
                self.fetchhealthdata(attr: "bp")
                Utilities.shared.RemoveLoaderView()
            }
        }) { (cancel) in
            cancel.dismissAlertView()
        }
        alertwithtext.addTextField("Systolic", placeHolder: "Systolic",keyboardType: .numberPad)
        alertwithtext.addTextField("Diastolic", placeHolder: "Diastolic",keyboardType: .numberPad)
        alertwithtext.show()
    }
    func addheight(){
        alertwithtext = ZAlertView(title: "Write Height in Cm", message: "", isOkButtonLeft: false, okButtonText: "Add", cancelButtonText: "Cancel", okButtonHandler: { (send) in
            
            let txt1 = self.alertwithtext.getTextFieldWithIdentifier("Height")!
            txt1.delegate = self

            print(txt1.text!)
            if (txt1.text?.isEmpty)!{
                self.view.showToast("Write Height in Cm", position: .bottom, popTime: 3, dismissOnTap: false)
            }
            else if (txt1.text?.characters.count)! > 3 || (txt1.text?.characters.count)! < 2{
                self.view.showToast("Invalid Height", position: .bottom, popTime: 3, dismissOnTap: false)
            }
            else {
                Utilities.shared.ShowLoaderView(view: self.view, Message: "Adding Height")
                self.postApi(param: ["height" : txt1.text!])
                self.fetchhealthdata(attr: "h")
                Utilities.shared.RemoveLoaderView()
            }
        }) { (cancel) in
            cancel.dismissAlertView()
        }
        alertwithtext.addTextField("Height", placeHolder: "Height",keyboardType: .numberPad)
        alertwithtext.show()
    }
    func addWeight(){
        alertwithtext = ZAlertView(title: "Write Weight in Kg", message: "", isOkButtonLeft: false, okButtonText: "Add", cancelButtonText: "Cancel", okButtonHandler: { (send) in
            
            let txt1 = self.alertwithtext.getTextFieldWithIdentifier("Weight")!
            print(txt1.text!)
            txt1.delegate = self

            if (txt1.text?.isEmpty)!{
                self.view.showToast("Write Weight in Kg", position: .bottom, popTime: 3, dismissOnTap: false)
            }
            else if (txt1.text?.characters.count)! > 3{
                self.view.showToast("Invalid Weight", position: .bottom, popTime: 3, dismissOnTap: false)
            }
            else {
                Utilities.shared.ShowLoaderView(view: self.view, Message: "Adding Weight")
                self.postApi(param: ["weight" : txt1.text!])
                self.fetchhealthdata(attr: "w")
                Utilities.shared.RemoveLoaderView()
            }
        }) { (cancel) in
            cancel.dismissAlertView()
        }
        alertwithtext.addTextField("Weight", placeHolder: "Weight",keyboardType: .numberPad)
        alertwithtext.show()
    }
    func addTemperature(){
        alertwithtext = ZAlertView(title: "Write Temperature in ºC", message: "", isOkButtonLeft: false, okButtonText: "Add", cancelButtonText: "Cancel", okButtonHandler: { (send) in
            
            let txt1 = self.alertwithtext.getTextFieldWithIdentifier("Temperature")!
            print(txt1.text!)
            txt1.delegate = self

            if (txt1.text?.isEmpty)!{
                self.view.showToast("Write Temperature in ºC", position: .bottom, popTime: 3, dismissOnTap: false)
            }
            else if (txt1.text?.characters.count)! > 3{
                self.view.showToast("Invalid Temperature", position: .bottom, popTime: 3, dismissOnTap: false)
            }
            else {
                Utilities.shared.ShowLoaderView(view: self.view, Message: "Adding Temperature")
                self.postApi(param: ["temperature" : txt1.text!])
                self.fetchhealthdata(attr: "t")
                Utilities.shared.RemoveLoaderView()
            }
        }) { (cancel) in
            cancel.dismissAlertView()
        }
        alertwithtext.addTextField("Temperature", placeHolder: "Temperature",keyboardType: .numberPad)
        alertwithtext.show()
    }
}

