
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
    @IBOutlet var tableview: UITableView!
    var qrcodeImage: CIImage!
    let cryptLib = CryptLib()

    var hex = ""
    let key = "GFyb1eIRzR6zqWJjY97L+A==:QjJ/cH+l6nEoXn+dqf2Djnec/y+/s/Lua6xq1dLrjMk="
    
    let helptypename = ["Police Service\n (पुलिस सेवा)","Fire Service\n (अग्नि सेवा)","Ambulance\n  (एम्बुलेंस)","Traffic Police\n (यातायात पुलिस)","Disaster Management\n (आपदा प्रबंधन)","Railway Inquiry\n (रेलवे पूछताछ)","Anti-Curruption\n (भ्रष्टाचार विरोधी)","Rail Accident\n (रेल दुर्घटना)","Road Accident\n (सड़क दुर्घटना)","Women Helpline\n (महिला सहायता लाइन)","Children Victimization Helpline\n (बाल शोषण सहायता)","Farmer Call Center\n (किसान कॉल केंद्र)","Citizen Call Center\n (नागरिक कॉल केंद्र)","Blood Bank\n (रक्त बैंक)"]
    let helptypenumber = ["100","101","102","103","108","139","1031","1072","1073","1091","1098","1551","155300","9480044444"]

    override func viewDidLoad() {
        super.viewDidLoad()
        let patientid = UserDefaults.standard.string(forKey: "Patient_id")
        tableview.tableFooterView = UIView(frame: .zero)
        let text = "\(patientid!)"
                
        let cipherText = cryptLib.encryptPlainTextRandomIV(withPlainText: text, key: key)

        print("cipherText \(cipherText! as String)")
        
        let data = cipherText!.data(using: String.Encoding.isoLatin1, allowLossyConversion: false)
 
        let filter = CIFilter(name: "CIQRCodeGenerator")
 
        filter?.setValue(data, forKey: "inputMessage")
        filter?.setValue("Q", forKey: "inputCorrectionLevel")
 
        qrcodeImage = filter!.outputImage
        displayQRCodeImage()
        print(text)
        
        let decryptedString = cryptLib.decryptCipherTextRandomIV(withCipherText: cipherText!, key: key)
        print("decryptedString \(decryptedString)")
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
extension QRViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.helptypename.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "helplineNumberCell") as! helplineNumberCell
        cell.typename.text = self.helptypename[indexPath.row]
        cell.typenumber.text = self.helptypenumber[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
class helplineNumberCell: UITableViewCell {
    
    @IBOutlet var typename: UILabel!
    @IBOutlet var typenumber: UILabel!
    
}
