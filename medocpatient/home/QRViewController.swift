
//
//  QRViewController.swift
//  MedocPatient
//
//  Created by Prem Sahni on 12/12/18.
//  Copyright © 2018 Kanishka. All rights reserved.
//

import UIKit

class QRViewController: UIViewController {

    @IBOutlet var qrimage: UIImageView!
    var qrcodeImage: CIImage!
    @IBOutlet var uniqueCode: UILabel!
    @IBOutlet var OtpTF: UITextField!
    @IBOutlet var Send: UIButton!
    var fiveDigitNumber: String {
        var result = ""
        repeat {
            // Create a string with a random number 0...9999
            result = String(format:"%04d", arc4random_uniform(100000) )
        } while result.count < 5
        return result
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let text = "\(fiveDigitNumber)"
        let data = text.data(using: String.Encoding.isoLatin1, allowLossyConversion: false)
 
        let filter = CIFilter(name: "CIQRCodeGenerator")
 
        filter?.setValue(data, forKey: "inputMessage")
        filter?.setValue("Q", forKey: "inputCorrectionLevel")
 
        qrcodeImage = filter!.outputImage
        displayQRCodeImage()
        
        uniqueCode.text = "Unique ID : \(fiveDigitNumber)"
        // Do any additional setup after loading the view.
    }
    func displayQRCodeImage() {
        let scaleX = qrimage.frame.size.width / qrcodeImage.extent.size.width
        let scaleY = qrimage.frame.size.height / qrcodeImage.extent.size.height
        
        let transformedImage = qrcodeImage.transformed(by: CGAffineTransform(scaleX: scaleX, y: scaleY))
        
        qrimage.image = UIImage(ciImage: transformedImage)
    }
    func getRandomNumbers(maxNumber: Int, listSize: Int)-> Set<Int> {
        var randomNumbers = Set<Int>()
        while randomNumbers.count < listSize {
            let randomNumber = Int(arc4random_uniform(UInt32(maxNumber+1)))
            randomNumbers.insert(randomNumber)
        }
        return randomNumbers
    }
    
}
