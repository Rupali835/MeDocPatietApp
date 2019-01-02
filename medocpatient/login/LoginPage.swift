//
//  ViewController.swift
//  MedocPatient
//
//  Created by Prem Sahni on 08/12/18.
//  Copyright © 2018 Kanishka. All rights reserved.
//

import UIKit

class LoginPage: UIViewController{

    @IBOutlet var LoginNow: UIButton!
    @IBOutlet var PatientTextField: UITextField!
    @IBOutlet var PasswordTextField: UITextField!
    @IBOutlet var Register: UIButton!
    @IBOutlet var Gview: UIView!

    var pageVC = PageViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
     //   Utilities.shared.bottomBorderSetup(fields: [PatientTextField,PasswordTextField],color: UIColor(hexString: "FFFFFF"))
        Utilities.shared.borderRadius(objects: [LoginNow], color: UIColor(hexString: "4CAF50"))
        Utilities.shared.cornerRadius(objects: [LoginNow,Register], number: 5.0)
        Register.addTarget(self, action: #selector(registerAction), for: .touchUpInside)
       
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func viewWillLayoutSubviews() {
        Utilities.shared.setGradientBackground(view: self.view, color1: UIColor.groupTableViewBackground,color2: UIColor.white)
        Utilities.shared.setGradientBackground(view: Gview, color1: UIColor.groupTableViewBackground,color2: UIColor.white)
    }
    @objc func registerAction(){
        let pageViewController = self.parent as! PageViewController
        pageViewController.nextPageWithIndex(index: 2)
    }
}

