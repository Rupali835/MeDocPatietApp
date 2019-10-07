//
//  AddPHQViewController.swift
//  medocpatient
//
//  Created by Nishikant Ashok UMBARKAR on 18/4/19.
//  Copyright © 2019 kspl. All rights reserved.
//

import UIKit
import CoreData

class AddPHQCell: UITableViewCell {
    
    @IBOutlet var question: UILabel!
    @IBOutlet var AnswerRadio: [SKRadioButton]!

    @IBAction func AnswerRadioActions(sender: SKRadioButton){
        self.AnswerRadio.forEach { (button) in
            button.isSelected = false
        }
        sender.isSelected = true
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        Utilities.shared.cornerRadius(objects: [self.question], number: 5.0)
        self.AnswerRadio[0].titleText = "Not at all".localized()
        self.AnswerRadio[1].titleText = "Several days".localized()
        self.AnswerRadio[2].titleText = "Most than half day".localized()
        self.AnswerRadio[3].titleText = "Nearly every day".localized()
    }
}
class AddPHQViewController: UIViewController {

    @IBOutlet var tableview: UITableView!
    @IBOutlet var FinalAnswerRadio: [SKRadioButton]!
    @IBOutlet var lblstatus: UILabel!
    @IBOutlet var lbltotal: UILabel!
    @IBOutlet var popuptitle: UILabel!
    @IBOutlet var popupmsg: UILabel!
    
    var faq = [FAQDataModal]()
    var totalcountarr = [Int]()
    var count = 0
    var final_answer_title = ""
    let appdel = UIApplication.shared.delegate as! AppDelegate
    let bearertoken = UserDefaults.standard.string(forKey: "bearertoken")
    let p_id = UserDefaults.standard.string(forKey: "Patient_id")
    let id = UserDefaults.standard.integer(forKey: "id")
    var queans = [Dictionary<String, Any>]()

    @IBOutlet var finalanswerview: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.tableFooterView = UIView(frame: .zero)
        self.navigationItem.title = "PHQ-9 Questions"
        totalcountarr = [Int].init(repeating: 0, count: self.faq.count)
        self.lbltotal.text = "Total = \(count) / 27"
        
        let save = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(Action_Save))
        self.navigationItem.rightBarButtonItem = save
        
        self.popuptitle.text = "Final thing to answer".localized()
        self.popupmsg.text = "if you checked off any problem, how difficult have these problems made it for you to do your work, take care of things at home, or get along with other people?".localized()
        self.FinalAnswerRadio[0].titleText = "Not difficult at all".localized()
        self.FinalAnswerRadio[1].titleText = "Somewhat difficult".localized()
        self.FinalAnswerRadio[2].titleText = "Very difficult".localized()
        self.FinalAnswerRadio[3].titleText = "Extremely difficult".localized()
        // Do any additional setup after loading the view.
    }
    @objc func Action_Save(){
        if self.faq.contains(where: {$0.Answer == ""}) {
            Utilities.shared.showToast(text: "You have not answered all question", duration: 3.0)
        } else {
            self.finalanswerview.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
            self.view.addSubview(self.finalanswerview)
        }
    }
    @IBAction func cancel(){
        self.finalanswerview.removeFromSuperview()
    }
    @IBAction func submit(){
        if self.final_answer_title == ""{
            Utilities.shared.showToast(text: "Select anyone of the following", duration: 3.0)
        } else {
            NetworkManager.isReachable { _ in
                DispatchQueue.main.async {
                    self.finalanswerview.removeFromSuperview()
                    self.uploadphq()
                }
            }
            NetworkManager.isUnreachable { _ in
                DispatchQueue.main.async {
                    Utilities.shared.showToast(text: "Turn on Internet Connection to upload", duration: 3.0)
                }
            }
        }
    }
    @IBAction func FinalAnswerRadioActions(sender: SKRadioButton){
        self.FinalAnswerRadio.forEach { (button) in
            button.isSelected = false
        }
        self.final_answer_title = sender.titleText
        sender.isSelected = true
    }
}
extension AddPHQViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.faq.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddPHQCell") as! AddPHQCell
        cell.question.text = self.faq[indexPath.row].Question.localized()
        
        cell.AnswerRadio[0].tag = indexPath.row
        cell.AnswerRadio[1].tag = indexPath.row
        cell.AnswerRadio[2].tag = indexPath.row
        cell.AnswerRadio[3].tag = indexPath.row
        
        cell.AnswerRadio[0].addTarget(self, action: #selector(Action_not_at_all(sender:)), for: .touchUpInside)
        cell.AnswerRadio[1].addTarget(self, action: #selector(Action_several_days(sender:)), for: .touchUpInside)
        cell.AnswerRadio[2].addTarget(self, action: #selector(Action_most_than_half_day(sender:)), for: .touchUpInside)
        cell.AnswerRadio[3].addTarget(self, action: #selector(Action_nearly_every_day(sender:)), for: .touchUpInside)
        
        cell.AnswerRadio.forEach { (button) in
            button.isSelected = false
        }
        
        switch self.faq[indexPath.row].Answer {
        case "Not at all":
            cell.AnswerRadio[0].isSelected = true
            break;
        case "Several days":
            cell.AnswerRadio[1].isSelected = true
            break;
        case "Most than half day":
            cell.AnswerRadio[2].isSelected = true
            break;
        case "Nearly every day":
            cell.AnswerRadio[3].isSelected = true
            break;
        default:
            break;
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    @objc func Action_not_at_all(sender: SKRadioButton){
        self.faq[sender.tag].Answer = "Not at all"
        self.totalcountarr[sender.tag] = 0
        totalcount_status()
    }
    @objc func Action_several_days(sender: SKRadioButton){
        self.faq[sender.tag].Answer = "Several days"
        self.totalcountarr[sender.tag] = 1
        totalcount_status()
    }
    @objc func Action_most_than_half_day(sender: SKRadioButton){
        self.faq[sender.tag].Answer = "Most than half day"
        self.totalcountarr[sender.tag] = 2
        totalcount_status()
    }
    @objc func Action_nearly_every_day(sender: SKRadioButton){
        self.faq[sender.tag].Answer = "Nearly every day"
        self.totalcountarr[sender.tag] = 3
        totalcount_status()
    }
    func totalcount_status(){
        count = 0
        for i in self.totalcountarr {
            count = count + i
        }
        self.lbltotal.text = "Total = \(count) / 27"
        if count < 5 {
            self.lblstatus.text = "None".localized()
        }
        else if count >= 5 && count < 10 {
            self.lblstatus.text = "Mild".localized()
        }
        else if count >= 10 && count < 20 {
            self.lblstatus.text = "Moderate".localized()
        }
        else if count >= 20{
            self.lblstatus.text = "Moderately Severe".localized()
        }
    }
    func uploadphq(){
        for (index,item) in self.faq.enumerated() {
            var dict = Dictionary<String, Any>()
            dict["questionId"] = index
            switch item.Answer {
            case "Not at all":
                dict["answer"] = 0
                break;
            case "Several days":
                dict["answer"] = 1
                break;
            case "Most than half day":
                dict["answer"] = 2
                break;
            case "Nearly every day":
                dict["answer"] = 3
                break;
            default:
                dict["answer"] = 0
                break;
            }
            self.queans.append(dict)
        }
        var finalanswerid = 1
        switch self.final_answer_title {
        case self.FinalAnswerRadio[0].titleText:
            finalanswerid = 1
        case self.FinalAnswerRadio[1].titleText:
            finalanswerid = 2
        case self.FinalAnswerRadio[2].titleText:
            finalanswerid = 3
        case self.FinalAnswerRadio[3].titleText:
            finalanswerid = 4
        default:
            finalanswerid = 1
        }
        print(self.queans)
        let prettyjson = String(data: try! JSONSerialization.data(withJSONObject: self.queans, options: .prettyPrinted), encoding: String.Encoding.utf8)!
        ApiServices.shared.FetchformPostDataFromUrl(vc: self, Url: ApiServices.shared.medocDoctorUrl + "add_phq", bearertoken: bearertoken!, parameter: "patient_id=\(self.p_id!)&final_ans=\(finalanswerid)&loggedin_id=\(self.id)&que_ans=\(prettyjson)", onSuccessCompletion: {
            do {
                let json = try JSONSerialization.jsonObject(with: ApiServices.shared.data, options: .mutableContainers) as! NSDictionary
                let msg = json.value(forKey: "msg") as! String
                if msg == "success" {
                    DispatchQueue.main.async {
                        NotificationCenter.default.post(name: NSNotification.Name("reloadphq"), object: self)
                        Utilities.shared.showToast(text: "Submitted PHQ Successfully", duration: 3.0)
                        self.navigationController?.popViewController(animated: true)
                    }
                }
                print(json)
            } catch {
                print("catch")
            }
        })
        
        
    }
}
