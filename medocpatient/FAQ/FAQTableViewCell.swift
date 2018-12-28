//
//  FAQTableViewCell.swift
//  MedocPatient
//
//  Created by Prem Sahni on 10/12/18.
//  Copyright © 2018 Kanishka. All rights reserved.
//

import UIKit
protocol FAQTableViewCelldelegate: class {
    func expand(cell: FAQTableViewCell)
}
class FAQTableViewCell: UITableViewCell {

    @IBOutlet var question: UILabel!
    @IBOutlet var answer: UILabel! {
        didSet{
            answer.numberOfLines = 2
        }
    }
    @IBOutlet var morebutton: UIButton!
    weak var delegate: FAQTableViewCelldelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBAction func more(_ sender: Any){
        delegate?.expand(cell: self)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
