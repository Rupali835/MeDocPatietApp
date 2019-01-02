//
//  RegisterViewController.swift
//  MedocPatient
//
//  Created by Prem Sahni on 12/12/18.
//  Copyright © 2018 Kanishka. All rights reserved.
//
// Sign up form 
/*
 full name
 email
 number
 password
 confirm 
 gender
 */

import UIKit

class RegisterViewController: UIViewController {

    @IBOutlet var Close: UIButton!
    @IBOutlet var FullNameTF: UITextField!
    @IBOutlet var EmailTF: UITextField!
    @IBOutlet var NumberTF: UITextField!
    @IBOutlet var PasswordTF: UITextField!
    @IBOutlet var ConfirmPasswordTF: UITextField!
    @IBOutlet var GenderSegment: UISegmentedControl!
    @IBOutlet var RegisterNow: UIButton!
    @IBOutlet var Signup: UIButton!
    @IBOutlet var Gview: UIView!


    override func viewDidLoad() {
        super.viewDidLoad()
       // Utilities.shared.bottomBorderSetup(fields: [FullNameTF,EmailTF,NumberTF,PasswordTF,ConfirmPasswordTF],color: UIColor(hexString: "FFFFFF"))
        Utilities.shared.borderRadius(objects: [RegisterNow], color: UIColor(hexString: "4CAF50"))
        Utilities.shared.cornerRadius(objects: [RegisterNow,Signup], number: 5.0)
        
        GenderSegment.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor(hexString: "212121"), NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 15)], for: .normal)
        GenderSegment.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor(hexString: "4CAF50"), NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20)], for: .selected)
        GenderSegment.tintColor = UIColor.clear
        GenderSegment.backgroundColor = UIColor.clear
        
        Close.addTarget(self, action: #selector(CloseAction), for: .touchUpInside)
        Signup.addTarget(self, action: #selector(SigninAction), for: .touchUpInside)
        Utilities.shared.setGradientBackground(view: self.view, color1: UIColor.groupTableViewBackground,color2: UIColor.white)
        Utilities.shared.setGradientBackground(view: Gview, color1: UIColor.groupTableViewBackground,color2: UIColor.white)
        // Do any additional setup after loading the view.
    }
    @objc func CloseAction(){
        let pageViewController = self.parent as! PageViewController
        pageViewController.PreviousPageWithIndex(index: 1)
    }
    @objc func SigninAction(){
        let pageViewController = self.parent as! PageViewController
        pageViewController.PreviousPageWithIndex(index: 1)
    }
}
