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

    @IBOutlet var tableview: UITableView!
    let list = ["Blood Pressure","Weight","Height","Temperature"]
    
    var alertwithtext = ZAlertView()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableview.tableFooterView = UIView(frame: .zero)
        // Do any additional setup after loading the view.
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
            return cell2
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1{
            let chartvc = self.storyboard?.instantiateViewController(withIdentifier: "ChartViewController") as! ChartViewController
            chartvc.selectedtitle = self.list[indexPath.row]
            self.navigationController?.pushViewController(chartvc, animated: true)
        }
    }
}
extension HealthViewController: HealthListTableViewCelldelegate {
    func indexpath(cell: HealthListTableViewCell) {
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
    func addbloodpressure(){
        alertwithtext = ZAlertView(title: "Write Blood Pressure", message: "", isOkButtonLeft: false, okButtonText: "Add", cancelButtonText: "Cancel", okButtonHandler: { (send) in
            
            let txt1 = self.alertwithtext.getTextFieldWithIdentifier("Systolic")!
            let txt2 = self.alertwithtext.getTextFieldWithIdentifier("Diastolic")!
            print(txt1.text!)
            print(txt2.text!)
            if (txt1.text?.isEmpty)! && (txt2.text?.isEmpty)! {
                self.view.showToast("Write Systolic & Diastolic", position: .bottom, popTime: 3, dismissOnTap: false)
            }
            else if (txt1.text?.isEmpty)!{
                self.view.showToast("Write Systolic", position: .bottom, popTime: 3, dismissOnTap: false)
            }
            else if (txt2.text?.isEmpty)!{
                self.view.showToast("Write Diastolic", position: .bottom, popTime: 3, dismissOnTap: false)
            }
            else {
                
            }
        }) { (cancel) in
            cancel.dismissAlertView()
        }
        alertwithtext.addTextField("Systolic", placeHolder: "Write Systolic",keyboardType: .numberPad)
        alertwithtext.addTextField("Diastolic", placeHolder: "Write Diastolic",keyboardType: .numberPad)
        alertwithtext.show()
    }
    func addheight(){
        alertwithtext = ZAlertView(title: "Write Height in Cm", message: "", isOkButtonLeft: false, okButtonText: "Add", cancelButtonText: "Cancel", okButtonHandler: { (send) in
            
            let txt1 = self.alertwithtext.getTextFieldWithIdentifier("Height")!
            print(txt1.text!)
            if (txt1.text?.isEmpty)!{
                self.view.showToast("Write Height in Cm", position: .bottom, popTime: 3, dismissOnTap: false)
            }
            else {
                
            }
        }) { (cancel) in
            cancel.dismissAlertView()
        }
        alertwithtext.addTextField("Height", placeHolder: "Write Height",keyboardType: .numberPad)
        alertwithtext.show()
    }
    func addWeight(){
        alertwithtext = ZAlertView(title: "Write Weight in Kg", message: "", isOkButtonLeft: false, okButtonText: "Add", cancelButtonText: "Cancel", okButtonHandler: { (send) in
            
            let txt1 = self.alertwithtext.getTextFieldWithIdentifier("Weight")!
            print(txt1.text!)
            if (txt1.text?.isEmpty)!{
                self.view.showToast("Write Weight in Kg", position: .bottom, popTime: 3, dismissOnTap: false)
            }
            else {
                
            }
        }) { (cancel) in
            cancel.dismissAlertView()
        }
        alertwithtext.addTextField("Weight", placeHolder: "Write Weight",keyboardType: .numberPad)
        alertwithtext.show()
    }
    func addTemperature(){
        alertwithtext = ZAlertView(title: "Write Temperature in ºC", message: "", isOkButtonLeft: false, okButtonText: "Add", cancelButtonText: "Cancel", okButtonHandler: { (send) in
            
            let txt1 = self.alertwithtext.getTextFieldWithIdentifier("Temperature")!
            print(txt1.text!)
            if (txt1.text?.isEmpty)!{
                self.view.showToast("Write Temperature in ºC", position: .bottom, popTime: 3, dismissOnTap: false)
            }
            else {
                
            }
        }) { (cancel) in
            cancel.dismissAlertView()
        }
        alertwithtext.addTextField("Temperature", placeHolder: "Write Temperature",keyboardType: .numberPad)
        alertwithtext.show()
    }
}

