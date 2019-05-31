//
//  PHQ-9ViewController.swift
//  medocpatient
//
//  Created by Nishikant Ashok UMBARKAR on 18/4/19.
//  Copyright © 2019 kspl. All rights reserved.
//

import UIKit
import CoreData

class PHQCell: UITableViewCell {
    @IBOutlet var date: UILabel!
}
class PHQ_9ViewController: UIViewController {

    @IBOutlet var tableview: UITableView!
    @IBOutlet var btn_add: UIButton!
    let appdel = UIApplication.shared.delegate as! AppDelegate
    var items = [Entity_PHQ]()
    let p_id = UserDefaults.standard.string(forKey: "Patient_id")
    let bearertoken = UserDefaults.standard.string(forKey: "bearertoken")
    var phqarr = NSArray()
    var faq = [FAQDataModal]()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.tableFooterView = UIView(frame: .zero)
        self.navigationItem.title = "Patient Health Questionnaire"
        Utilities.shared.cornerRadius(objects: [self.btn_add], number: self.btn_add.frame.width / 2)
        data()
        NetworkManager.isReachable { _ in
            self.fetchphq()
        }
        NetworkManager.isUnreachable { _ in
            self.offlinephq()
        }
        NetworkManager.sharedInstance.reachability.whenReachable = { _ in
            self.fetchphq()
        }
        NotificationCenter.default.addObserver(self, selector: #selector(reloadphq), name: NSNotification.Name("reloadphq"), object: nil)
        // Do any additional setup after loading the view.
    }
    @objc func reloadphq(){
        NetworkManager.isReachable { _ in
            self.fetchphq()
        }
    }
    @IBAction func Add(sender: UIButton){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddPHQViewController") as! AddPHQViewController
        vc.faq = self.faq
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func offlinephq(){
        let context = appdel.persistentContainer.viewContext
        
        do{
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Entity_PHQ")
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "created_at", ascending: false, selector: #selector(NSString.localizedStandardCompare))]
            items = try context.fetch(fetchRequest) as! [Entity_PHQ]
            if items.count > 0{
                DispatchQueue.main.async {
                    self.tableview.reloadData()
                    Utilities.shared.removecentermsg()
                }
            } else {
                DispatchQueue.main.async {
                    Utilities.shared.centermsg(msg: "No PHQ Added", view: self.view)
                }
            }
        } catch {
            print("catch offline")
        }
    }
    func fetchphq(){
        Utilities.shared.ShowLoaderView(view: self.view, Message: "Please Wait..")
        ApiServices.shared.FetchformPostDataFromUrl(vc: self, Url: ApiServices.shared.medocDoctorUrl + "get_phq", bearertoken: bearertoken!, parameter: "patient_id=\(self.p_id!)") {
            do {
                let jsondict = try JSONSerialization.jsonObject(with: ApiServices.shared.data, options: .mutableContainers) as! NSDictionary
                let msg = jsondict.value(forKey: "msg") as! String
                self.deletePHQData()
                if msg == "success" {
                    self.phqarr = jsondict.value(forKey: "phq") as! NSArray
                    DispatchQueue.main.async {
                        self.savephqdata()
                        Utilities.shared.RemoveLoaderView()
                    }
                } else {
                    DispatchQueue.main.async {
                        Utilities.shared.RemoveLoaderView()
                        Utilities.shared.centermsg(msg: "No PHQ Added", view: self.view)
                    }
                }
            } catch {
                print("catch")
            }
        }
    }
    func savephqdata(){
        let conttxt = self.appdel.persistentContainer.viewContext

        for (index,_) in self.phqarr.enumerated() {
            
            let data = self.phqarr.object(at: index) as! NSDictionary
            
            let masteritem = Entity_PHQ(context: conttxt)
            masteritem.created_at = data.value(forKey: "created_at") as? String
            masteritem.final_ans = data.value(forKey: "final_ans") as? String
            masteritem.created_by = data.value(forKey: "created_by") as? String
            masteritem.id = data.value(forKey: "id") as? String
            masteritem.patient_id = data.value(forKey: "patient_id") as? String
            masteritem.que_ans = data.value(forKey: "que_ans") as? String
            
        }
        
        do {
            try conttxt.save()
        } catch {
            print("catch")
        }
        self.offlinephq()
    }
    func deletePHQData() {
        let contx = appdel.persistentContainer.viewContext
        do{
            let DataArr = try contx.fetch(Entity_PHQ.fetchRequest()) as [Entity_PHQ]
            
            for (index, _) in DataArr.enumerated()
            {
                let UserEntity = DataArr[index]
                contx.delete(UserEntity)
            }
        } catch {}
    }
}
extension PHQ_9ViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PHQCell") as! PHQCell
        cell.date.text = self.items[indexPath.row].created_at
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ShowPHQViewController") as! ShowPHQViewController
        let created_at = self.items[indexPath.row].created_at!
        let que_ans = self.items[indexPath.row].que_ans!
        vc.faq = self.faq
        vc.que_ansarr = que_ans.convertIntoJsonArray()!
        vc.navigationItem.title = created_at
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
extension PHQ_9ViewController {
    func data(){
        let Q1 = FAQDataModal(question: "Little interest or pleasure in doing things?", answer: "")
        faq.append(Q1)
        
        let Q2 = FAQDataModal(question: "Feeling down, depressed, or hopeless?", answer: "")
        faq.append(Q2)
        
        let Q3 = FAQDataModal(question: "Trouble falling or staying asleep, or sleeping too much?", answer: "")
        faq.append(Q3)
        
        let Q4 = FAQDataModal(question: "Feeling tired or having little energy?", answer: "")
        faq.append(Q4)
        
        let Q5 = FAQDataModal(question: "Poor appetite or overeating?", answer: "")
        faq.append(Q5)
        
        let Q6 = FAQDataModal(question: "Feeling bad about yourself - or that you are a failure or have let yourself or your family down?", answer: "")
        faq.append(Q6)
        
        let Q7 = FAQDataModal(question: "Trouble concentrating on things, such as reading the newspaper or watching television?", answer: "")
        faq.append(Q7)
        
        let Q8 = FAQDataModal(question: "Moving or speaking so slowly that other people could have noticed? Or the opposite - being so fidgety or restless that you have been moving around a lot more than usual?", answer: "")
        faq.append(Q8)
        
        let Q9 = FAQDataModal(question: "Thoughts that you would be better off dead, or of hurting yourself in some way?", answer: "")
        faq.append(Q9)
    }
}
