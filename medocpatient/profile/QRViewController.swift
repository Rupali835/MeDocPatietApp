
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
    
    var hex = ""
    let key = "GFyb1eIRzR6zqWJjY97L+A==:QjJ/cH+l6nEoXn+dqf2Djnec/y+/s/Lua6xq1dLrjMk="
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let patientid = UserDefaults.standard.string(forKey: "Patient_id")
        
        let text = "\(patientid!)"
        
      //  encrypt(text: text)
        let cryptLib = CryptLib()
        
        let cipherText = cryptLib.encryptPlainTextRandomIV(withPlainText: text, key: key)
        print("cipherText \(cipherText! as String)")
        
        let data = cipherText!.data(using: String.Encoding.isoLatin1, allowLossyConversion: false)
 
        let filter = CIFilter(name: "CIQRCodeGenerator")
 
        filter?.setValue(data, forKey: "inputMessage")
        filter?.setValue("Q", forKey: "inputCorrectionLevel")
 
        qrcodeImage = filter!.outputImage
        displayQRCodeImage()
        print(text)
      //  hex = "jk3JGfxX9y0+SuAGUIl4YQ==:KysnoS5SDt7gsdQ3RVrwT5j7QMkuQO26SZnHNUl8XL8=:omkqcFqQmu7rP7gsH1GF2w=="
        
        let decryptedString = cryptLib.decryptCipherTextRandomIV(withCipherText: cipherText, key: key)
        print("decryptedString \(decryptedString! as String)")
        
//        let dec = decrypt(hexString: hex)
//        uniqueCode.text = ""//"Patient ID : \(dec!)"
//        print(dec!)
        
        // Do any additional setup after loading the view.
    }
//    func encrypt(text: String) -> String?  {
//        if let aes = try? AES(key: key, iv: "drowssapdrowssap"),
//            let encrypted = try? aes.encrypt(Array(text.utf8)) {
//            hex = encrypted.toHexString()
//            return encrypted.toHexString()
//        }
//        return nil
//    }
//    func decrypt(hexString: String) -> String? {
//        if let aes = try? AES(key: key, iv: "drowssapdrowssap"),
//            let decrypted = try? aes.decrypt(Array<UInt8>(hex: hexString)) {
//            return String(data: Data(bytes: decrypted), encoding: .utf8)
//        }
//        return nil
//    }
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
