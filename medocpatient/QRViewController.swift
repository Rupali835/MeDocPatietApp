
//
//  QRViewController.swift
//  MedocPatient
//
//  Created by Prem Sahni on 12/12/18.
//  Copyright © 2018 Kanishka. All rights reserved.
//

import UIKit
import CryptoSwift

class QRViewController: UIViewController {

    @IBOutlet var qrimage: UIImageView!
    var qrcodeImage: CIImage!
    @IBOutlet var uniqueCode: UILabel!
    @IBOutlet var Send: UIButton!
    var fiveDigitNumber: String {
        var result = ""
        repeat {
            // Create a string with a random number 0...9999
            result = String(format:"%04d", arc4random_uniform(100000) )
        } while result.count < 5
        return result
    }
    var hex = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let text = "\(fiveDigitNumber)"
        
        encrypt(text: text)
        
        let data = hex.data(using: String.Encoding.isoLatin1, allowLossyConversion: false)
 
        let filter = CIFilter(name: "CIQRCodeGenerator")
 
        filter?.setValue(data, forKey: "inputMessage")
        filter?.setValue("Q", forKey: "inputCorrectionLevel")
 
        qrcodeImage = filter!.outputImage
        displayQRCodeImage()
        print(text)
        
        let dec = decrypt(hexString: hex)
        uniqueCode.text = "Unique ID : \(dec!)"
        
        
        // Do any additional setup after loading the view.
    }
    func encrypt(text: String) -> String?  {
        if let aes = try? AES(key: "passwordpassword", iv: "drowssapdrowssap"),
            let encrypted = try? aes.encrypt(Array(text.utf8)) {
            hex = encrypted.toHexString()
            return encrypted.toHexString()
        }
        return nil
    }
    func decrypt(hexString: String) -> String? {
        if let aes = try? AES(key: "passwordpassword", iv: "drowssapdrowssap"),
            let decrypted = try? aes.decrypt(Array<UInt8>(hex: hexString)) {
            return String(data: Data(bytes: decrypted), encoding: .utf8)
        }
        return nil
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
