//
//  AddMedicinesViewController.swift
//  MedocPatient
//
//  Created by iAM on 26/12/18.
//  Copyright © 2018 Kanishka. All rights reserved.
//

import UIKit

class AddMedicinesViewController: UIViewController {

    @IBOutlet var quantity: UILabel!
    @IBOutlet var StepCounter: UIStepper!
    
    @IBOutlet var medicineTF: UITextField!
    
    @IBOutlet var morning: UIButton!
    @IBOutlet var afternoon: UIButton!
    @IBOutlet var evening: UIButton!
    @IBOutlet var night: UIButton!
    
    @IBOutlet var hr2: UIButton!
    @IBOutlet var hr3: UIButton!
    @IBOutlet var hr4: UIButton!
    @IBOutlet var hr5: UIButton!
    @IBOutlet var hr6: UIButton!
    
    var selectedhr = ""
    var selectedtime = [String]()
    
    @IBOutlet var done: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        StepCounter.addTarget(self, action: #selector(stepperValueDidChange), for: .valueChanged)
        done.addTarget(self, action: #selector(doneAction), for: .touchUpInside)
        // Do any additional setup after loading the view.
    }
    @objc func doneAction(){
        if (medicineTF.text?.isEmpty)! {
            view.showToast("Enter Medicine Name", position: .bottom, popTime: 3, dismissOnTap: true)
        }
            
        else if selectedtime.isEmpty {
            view.showToast("select time", position: .bottom, popTime: 3, dismissOnTap: true)
        }
        else if selectedhr == ""{
            view.showToast("select repeated hour", position: .bottom, popTime: 3, dismissOnTap: true)
        }
        else {
            
//            SwiftLoader.show(title: "Set Medicine...", animated: true)
//            let appdel = UIApplication.shared.delegate as! AppDelegate
//            let conttxt = appdel.persistentContainer.viewContext
//            let singleitem = Medicine(context: conttxt)
//            singleitem.name = medicineTF.text!
//            singleitem.quantity = quantity.text!
//            singleitem.repeattimeslot = selectedhr
//            singleitem.timeslot = selectedtime.joined(separator: "-")
//            //pretitle  attachReport
//            
//            appdel.saveContext()
//            NotificationCenter.default.post(name: NSNotification.Name("reloadmedicine"), object: self)
//            SwiftLoader.hide()
//            self.navigationController?.popViewController(animated: true)
            
        }

    }
    func resetButtonStates() {
        let buttons = [hr2,hr3,hr4,hr5,hr6]
        for button in buttons {
            button!.isSelected = false
            button!.setTitleColor(UIColor.gray, for: .normal)
        }
    }
    @objc func stepperValueDidChange(stepper: UIStepper) {
        
        let stepperMapping: [UIStepper: UILabel] = [StepCounter: quantity]
        
        stepperMapping[stepper]!.text = "\(Int(stepper.value))"
    }
    @IBAction func actionRepeatedTimeSlot(sender: UIButton){
        let isAlreadySelected = sender.isSelected == true
        
        // Reset the default state to all the buttons
        resetButtonStates()
        
        // Now update the button state of the selected button alone if its not selected already
        if !isAlreadySelected {
            sender.isSelected = true
            sender.setTitleColor(UIColor.black, for: .normal)
        } else {
            // Do
            print("do")
        }
        if sender.tag == 11{
            self.selectedhr = "2"
        }
        if sender.tag == 12{
            self.selectedhr = "3"
        }
        if sender.tag == 13{
            self.selectedhr = "4"
        }
        if sender.tag == 14{
            self.selectedhr = "5"
        }
        if sender.tag == 15{
            self.selectedhr = "6"
        }
    }
    
    @IBAction func actionTimeSlot(sender: UIButton){
        
        if sender.tag == 16{
            if self.selectedtime.contains("Morning"){
                let index = self.selectedtime.index(of: "Morning")
                self.selectedtime.remove(at: index!)
                morning.isSelected = false
            } else {
                morning.isSelected = true
                self.selectedtime.append("Morning")
            }
        }
        if sender.tag == 17{
            if self.selectedtime.contains("Afternoon"){
                let index = self.selectedtime.index(of: "Afternoon")
                self.selectedtime.remove(at: index!)
                afternoon.isSelected = false
            } else {
                afternoon.isSelected = true
                self.selectedtime.append("Afternoon")
            }
        }
        if sender.tag == 18{
            if self.selectedtime.contains("Evening"){
                let index = self.selectedtime.index(of: "Evening")
                self.selectedtime.remove(at: index!)
                evening.isSelected = false
            } else {
                evening.isSelected = true
                self.selectedtime.append("Evening")
            }
        }
        if sender.tag == 19{
            if self.selectedtime.contains("Night"){
                night.isSelected = false
                let index = self.selectedtime.index(of: "Night")
                self.selectedtime.remove(at: index!)
            } else {
                night.isSelected = true
                self.selectedtime.append("Night")
            }
        }
    }
}
