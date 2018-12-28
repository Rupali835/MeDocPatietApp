//
//  MedicineViewController.swift
//  MedocPatient
//
//  Created by Prem Sahni on 10/12/18.
//  Copyright © 2018 Kanishka. All rights reserved.
//

import UIKit
import UserNotifications

class MedicineViewController: UIViewController , UISearchControllerDelegate , UISearchBarDelegate{

    @IBOutlet var tableview: UITableView!
    let searchController = UISearchController(searchResultsController: nil)
    
    var items : [Medicine] = []
    var notificationGranted = false
    
    var timerDic = NSMutableDictionary()
    var took = Bool()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SearchAction()
        took = UserDefaults.standard.bool(forKey: "took")
        NotificationCenter.default.addObserver(self, selector: #selector(reload), name: NSNotification.Name("reloadmedicine"), object: nil)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add
            , target: self, action: #selector(add))
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.sound]) { (granted, error) in
            self.notificationGranted = granted
            if let error = error {
                print("granted, but Error in notification permission:\(error.localizedDescription)")
            }
        }
        UNUserNotificationCenter.current().cleanRepeatingNotifications()
        
        self.tableview.tableFooterView = UIView(frame: .zero)
        // Do any additional setup after loading the view.
    }
    @objc func add(){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddMedicinesViewController") as! AddMedicinesViewController
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    func repeatNotification(title: String,body: String,minute: Int){
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.categoryIdentifier = "medicine.reminder.category"
        
        //for testing
//        content.userInfo["endDate"] = Date(timeIntervalSinceNow: 60.00)
//
//       //  Set the end date to a number of days
//        let dayInSeconds = 10.0
//        content.userInfo["endDate"] = Date(timeIntervalSinceNow: dayInSeconds)
        
      //  A repeat trigger for every minute
      //  You cannot make a repeat shorter than this.
//        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 60.0, repeats: true)
        
        //Date component trigger
        var dateComponents = DateComponents()
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        dateComponents.hour = hour
        dateComponents.minute = minutes + minute
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        let request = UNNotificationRequest(identifier: "medicine.reminder", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                print("error in pizza reminder: \(error.localizedDescription)")
            }
        }
        print("added notification:\(request.identifier)")
    }
    @objc func reload(){
        self.tableview.reloadData()
    }
    func SearchAction(){
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.delegate = self  
        searchController.searchBar.delegate = self
        searchController.searchBar.backgroundColor = UIColor.clear
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.barTintColor = UIColor.white
        searchController.searchBar.tintColor = UIColor.white
        self.navigationItem.hidesSearchBarWhenScrolling = false
     //   self.navigationItem.searchController = searchController
        if let textfield = searchController.searchBar.value(forKey: "searchField") as? UITextField {
            textfield.textColor = UIColor.blue
            if let backgroundview = textfield.subviews.first {
                
                // Background color
                backgroundview.backgroundColor = UIColor.white
                
                // Rounded corner
                backgroundview.layer.cornerRadius = 10;
                backgroundview.clipsToBounds = true;
            }
        }
        let barButtonAppearanceInSearchBar: UIBarButtonItem?
        barButtonAppearanceInSearchBar = UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self])
      //  barButtonAppearanceInSearchBar?.image = #imageLiteral(resourceName: "close").withRenderingMode(.alwaysTemplate)
        barButtonAppearanceInSearchBar?.tintColor = UIColor.white
      //  barButtonAppearanceInSearchBar?.title = nil 
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchController.searchBar.endEditing(true)
    }
    override func viewWillDisappear(_ animated: Bool) {
        searchController.searchBar.endEditing(true)
        searchController.searchBar.text = ""
        searchController.searchBar.showsCancelButton = false
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchController.searchBar.endEditing(true)
        searchController.searchBar.showsCancelButton = false
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if (searchController.searchBar.text?.isEmpty)! {
           // filter = getAllusersdata
            tableview.reloadData()
            searchController.searchBar.showsCancelButton = true
        } else {
            searchController.searchBar.showsCancelButton = true
          /*  filter = getAllusersdata.filter({ (filterdata) -> Bool in
                tableview.reloadData()
                if self.filter.count == 0{
                    self.nofound.isHidden = false
                    self.nofound.text = "No Member Found"
                    self.tableview.isHidden = true
                } else {
                    self.nofound.isHidden = true
                    self.tableview.isHidden = false
                }
                return filterdata.user_name!.localizedCaseInsensitiveContains(searchController.searchBar.text!)
            })*/
            tableview.reloadData()
        } 
    }
    override func viewDidAppear(_ animated: Bool) {
        let appdel = UIApplication.shared.delegate as! AppDelegate
        let context = appdel.persistentContainer.viewContext
        
        do{
            items = try context.fetch(Medicine.fetchRequest())
            self.tableview.reloadData()
        } catch {
            
        }
    }
}
extension MedicineViewController: UITableViewDataSource , UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let medicinecell = tableView.dequeueReusableCell(withIdentifier: "MedicineCell") as! MedicineTableViewCell
        
        medicinecell.name.text = "Medicine Name: \(items[indexPath.row].name!)"
        medicinecell.quantity.text = "Quantity: \(items[indexPath.row].quantity!)"
        medicinecell.timeslot.text = "Time Slot: \(items[indexPath.row].timeslot!)"
        medicinecell.repeattimeslot.text = "Repeat Time Slot: \(items[indexPath.row].repeattimeslot!) hr"
        if notificationGranted {
            repeatNotification(title: "Time To Take Medicine", body: "-\(items[indexPath.row].name!)", minute: Int(items[indexPath.row].repeattimeslot!)!)
        } else {
            print("notification not granted")
        }
        if items.count > 0{
            if self.took == false {
                Alert.shared.ActionAlert(vc: self, title: "Time To Take Medicine", msg: "-\(items[indexPath.row].name!)", buttontitle: "Took", button2title: "Remind Me Later", ActionCompletion: {
                    UserDefaults.standard.set(true, forKey: "took")
                    UserDefaults.standard.synchronize()
                    self.took = true
                }) {
                    self.took = false
                    UserDefaults.standard.set(false, forKey: "took")
                    UserDefaults.standard.synchronize()
                    self.timerDic = ["msg":"-\(self.items[indexPath.row].name!)"]
                    Timer.scheduledTimer(timeInterval: 60 * 5, target: self, selector: #selector(self.remind), userInfo: self.timerDic, repeats: true)
                }
            } else {
                Alert.shared.dismissAlert(vc: self)
            }
        }
        return medicinecell
    }
    @objc func remind(timer: Timer){
        if let timerDic = timer.userInfo as? NSMutableDictionary {
            if self.took == false {
                if let msg = timerDic["msg"] as? String {
                    Alert.shared.ActionAlert(vc: self, title: "Time To Take Medicine", msg: msg, buttontitle: "Took", button2title: "Remind Me Later", ActionCompletion: {
                        self.took = true
                        UserDefaults.standard.set(true, forKey: "took")
                        UserDefaults.standard.synchronize()
                    }) {
                        self.took = false
                        UserDefaults.standard.set(false, forKey: "took")
                        UserDefaults.standard.synchronize()
                        Timer.scheduledTimer(timeInterval: 60 * 5, target: self, selector: #selector(self.remind), userInfo: ["msg":msg], repeats: true)
                    }
                }
            } else {
                Alert.shared.dismissAlert(vc: self)
            }
            
        }
    }
    
}

