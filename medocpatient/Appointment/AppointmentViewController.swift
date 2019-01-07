//
//  AppointmentViewController.swift
//  medocpatient
//
//  Created by iAM on 05/01/19.
//  Copyright © 2019 kspl. All rights reserved.
//

import UIKit
import FSCalendar
import DropDown

class AppointmentViewController: UIViewController , FSCalendarDataSource , FSCalendarDelegate {
    
    @IBOutlet var selectHospital: UIButton!
    @IBOutlet var selectDoctor: UIButton!
    @IBOutlet var appointmentdate: UIButton!

    @IBOutlet var send: UIButton!
    @IBOutlet var cv: UIView!
    @IBOutlet var cancel: UIButton!
    @IBOutlet var fscalendar: FSCalendar!
    let dropdownHospital = DropDown()
    let dropdownDoctor = DropDown()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dropdownHospital.arrowIndicationX = self.selectHospital.frame.width / 2
        dropdownDoctor.arrowIndicationX = self.selectDoctor.frame.width / 2
        
        dropdownHospital.anchorView = selectHospital
        dropdownDoctor.anchorView = selectDoctor
        
        dropdownHospital.dataSource = ["Nanavati Hospital","Balaji Hospital"]
        dropdownDoctor.dataSource = ["Dr. Mehta","Dr. Tiwari"]
        
        dropdownHospital.direction = .bottom
        dropdownDoctor.direction = .bottom
        
        dropdownHospital.bottomOffset = CGPoint(x: 0, y:(dropdownHospital.anchorView?.plainView.bounds.height)!)
        dropdownDoctor.bottomOffset = CGPoint(x: 0, y:(dropdownDoctor.anchorView?.plainView.bounds.height)!)
        
        DropDown.appearance().textFont = UIFont.boldSystemFont(ofSize: 20)
        fscalendar.delegate = self
        fscalendar.dataSource = self
        fscalendar.backgroundColor = UIColor.groupTableViewBackground
        selectHospital.addTarget(self, action: #selector(selectHospitalAction), for: .touchUpInside)
        selectDoctor.addTarget(self, action: #selector(selectDoctorAction), for: .touchUpInside)
        appointmentdate.addTarget(self, action: #selector(ClicktoSelectDate), for: .touchUpInside)
        send.addTarget(self, action: #selector(sendAction), for: .touchUpInside)
        cancel.addTarget(self, action: #selector(cancelAction), for: .touchUpInside)
        // Do any additional setup after loading the view.
    }
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE-dd/MMM/yyyy"
        let datestr = formatter.string(from: date)
        
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.1) {
                self.appointmentdate.setTitle(datestr, for: .normal)
                self.cv.isHidden = true
                self.cv.alpha = 0.0
            }
        }
    }
    @objc func cancelAction(){
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.1) {
                self.cv.isHidden = true
                self.cv.alpha = 0.0
                self.appointmentdate.setTitle("Appointment Date", for: .normal)
            }
        }
    }
    func minimumDate(for calendar: FSCalendar) -> Date {
        return Date()
    }
    @objc func ClicktoSelectDate(sender: UIButton){
        UIView.animate(withDuration: 0.1) {
            self.cv.isHidden = false
            self.cv.alpha = 1.0
        }
    }
    @objc func selectHospitalAction(){
        dropdownHospital.show()
        dropdownHospital.selectionAction = { [unowned self] (index: Int, item: String) in
            self.selectHospital.setTitle(item, for: .normal)
            print("Selected item: \(item) at index: \(index)")
        }
    }
    @objc func selectDoctorAction(){
        dropdownDoctor.show()
        dropdownDoctor.selectionAction = { [unowned self] (index: Int, item: String) in
            self.selectDoctor.setTitle(item, for: .normal)
            print("Selected item: \(item) at index: \(index)")
        }
    }
    @objc func sendAction(){
        
    }
}
