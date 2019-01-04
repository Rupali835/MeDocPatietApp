//
//  GetStartedViewController.swift
//  MedocPatient
//
//  Created by iAM on 17/12/18.
//  Copyright © 2018 Kanishka. All rights reserved.
//

import UIKit

class GetStartedViewController: UIViewController {

    @IBOutlet var LoginNow: UIButton!
    @IBOutlet var Register: UIButton!
    @IBOutlet var image: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Utilities.shared.borderRadius(objects: [Register,LoginNow], color: UIColor(hexString: "4CAF50"))
        Utilities.shared.cornerRadius(objects: [Register,LoginNow,image], number: 5.0)
        Register.addTarget(self, action: #selector(registerAction), for: .touchUpInside)
        LoginNow.addTarget(self, action: #selector(SigninAction), for: .touchUpInside)
        // Do any additional setup after loading the view.
    }
    @objc func registerAction(){
        let pageViewController = self.parent as! PageViewController
        pageViewController.nextPageWithIndex(index: 2)
    }
    @objc func SigninAction(){
        let pageViewController = self.parent as! PageViewController
        pageViewController.nextPageWithIndex(index: 1)
    }
}
