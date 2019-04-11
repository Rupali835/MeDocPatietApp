//
//  TimeInfoViewController.swift
//  medocpatient
//
//  Created by iAM on 21/01/19.
//  Copyright © 2019 kspl. All rights reserved.
//

import UIKit

class TimeInfoViewController: UIViewController {

    @IBOutlet var popview: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        Utilities.shared.cornerRadius(objects: [popview], number: 10.0)
        // Do any additional setup after loading the view.
    }
    @IBAction func ok(){
        self.dismiss(animated: true, completion: nil)
    }
}
