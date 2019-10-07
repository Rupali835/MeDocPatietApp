//
//  ShowPHQViewController.swift
//  medocpatient
//
//  Created by Nishikant Ashok UMBARKAR on 18/4/19.
//  Copyright © 2019 kspl. All rights reserved.
//

import UIKit
import CoreData

class ShowPHQCell: UITableViewCell {
    @IBOutlet var question: UILabel!
    @IBOutlet var answer: UILabel!
}
class ShowPHQViewController: UIViewController {

    @IBOutlet var tableview: UITableView!
    let appdel = UIApplication.shared.delegate as! AppDelegate
    var count = 0
    var que_ansarr = NSArray()
    var faq = [FAQDataModal]()

    @IBOutlet var lblstatus: UILabel!
    @IBOutlet var lbltotal: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.tableFooterView = UIView(frame: .zero)
        
        for (index,_) in self.que_ansarr.enumerated() {
            let data = self.que_ansarr.object(at: index) as! NSDictionary
            if let answer = data.value(forKey: "answer") as? Int {
                count = count + answer
            }
        }
        self.lbltotal.text = "Total: \(count)/27"
        
        if count < 5 {
            self.lblstatus.text = "None".localized()
        }
        else if count >= 5 && count < 10 {
            self.lblstatus.text = "Mild".localized()
        }
        else if count >= 10 && count < 20 {
            self.lblstatus.text = "Moderate".localized()
        }
        else if count >= 20 {
            self.lblstatus.text = "Moderately Severe".localized()
        }
        // Do any additional setup after loading the view.
    }
}
extension ShowPHQViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.que_ansarr.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShowPHQCell") as! ShowPHQCell
        let data = self.que_ansarr.object(at: indexPath.row) as! NSDictionary
        let qid = data.value(forKey: "questionId") as! Int
        let answer = data.value(forKey: "answer") as! Int
        for (index,item) in self.faq.enumerated() {
            if qid == index {
                cell.question.text = item.Question.localized()
                break;
            }
        }
        switch answer {
        case 0:
            cell.answer.text = "Not at all".localized()
            break;
        case 1:
            cell.answer.text = "Several days".localized()
            break;
        case 2:
            cell.answer.text = "Most than half day".localized()
            break;
        case 3:
            cell.answer.text = "Nearly every day".localized()
            break;
        default:
            cell.answer.text = "Not at all".localized()
            break;
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
