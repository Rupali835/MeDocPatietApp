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
    override func viewDidLoad() {
        super.viewDidLoad()
     //   SearchAction()
        NotificationCenter.default.addObserver(self, selector: #selector(reload), name: NSNotification.Name("reloadmedicine"), object: nil)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add
            , target: self, action: #selector(add))
        
       
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
        self.navigationItem.searchController = searchController
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
            tableview.reloadData()
        } 
    }
    override func viewDidAppear(_ animated: Bool) {
        fetchdata()
    }
    func fetchdata(){
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
        print(items[indexPath.row].took)
        if notificationGranted {
            repeatNotification(title: "Time To Take Medicine", body: "-\(items[indexPath.row].name!)", minute: Int(items[indexPath.row].repeattimeslot!)!)
        } else {
            print("notification not granted")
        }
        for _ in 0...items.count{
            for i in items {
                if items.count > 0{
                    if i.took == false {
                        
                        let now = Date()
                        var first = Date()
                        var second = Date()
                        
                        if (i.timeslot?.contains(find: "Morning"))! {
                            first = now.dateAt(hours: 8, minutes: 0)
                            second = now.dateAt(hours: 11, minutes: 00)
                            print("M-\(first)-\(second)")
                            break
                        }
                        else if (i.timeslot?.contains(find: "Afternoon"))! {
                            first = now.dateAt(hours: 12, minutes: 0)
                            second = now.dateAt(hours: 15, minutes: 00)
                            print("A-\(first)-\(second)")
                            break
                        }
                        else if (i.timeslot?.contains(find: "Evening"))! {
                            first = now.dateAt(hours: 17, minutes: 0)
                            second = now.dateAt(hours: 19, minutes: 00)
                            print("E-\(first)-\(second)")
                            break
                        }
                        else if (i.timeslot?.contains(find: "Night"))! {
                            first = now.dateAt(hours: 20, minutes: 0)
                            second = now.dateAt(hours: 23, minutes: 59)
                            print("N-\(first)-\(second)")
                            break
                        }
                        print("\(first)-\(second)")
                        print("BT: \(now >= first) && \(now <= second)")
                        if now >= first &&
                            now <= second
                        {
                            DispatchQueue.main.async {
                                print("BT: \(now >= first) && \(now <= second)")
                                Alert.shared.ActionAlert(vc: self, title: "Time To Take Medicine", msg: "-\(i.name!)", buttontitle: "Took", button2title: "Remind Me Later", ActionCompletion: {
                                    i.took = true
                                }) {
                                    i.took = false
                                    self.timerDic = ["msg":"-\(i.name!)","took":i.took]
                                    Timer.scheduledTimer(timeInterval: 60 * 5, target: self, selector: #selector(self.remind), userInfo: self.timerDic, repeats: true)
                                }
                            }
                        }
                    } else {
                        // Alert.shared.dismissAlert(vc: self)
                    }
                }
            }
        }
       
        return medicinecell
    }
    @objc func remind(timer: Timer){
        if let timerDic = timer.userInfo as? NSMutableDictionary {
            var took = timerDic["took"] as? Bool
            if took == false {
                if let msg = timerDic["msg"] as? String {
                    Alert.shared.ActionAlert(vc: self, title: "Time To Take Medicine", msg: msg, buttontitle: "Took", button2title: "Remind Me Later", ActionCompletion: {
                        took = true
                    }) {
                        took = false
                        Timer.scheduledTimer(timeInterval: 60 * 5, target: self, selector: #selector(self.remind), userInfo: ["msg":msg], repeats: true)
                    }
                }
            } else {
           //     Alert.shared.dismissAlert(vc: self)
            }
            
        }
    }
    
}

