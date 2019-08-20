//
//  ZoomImagesCollectionViewController.swift
//  medocpatient
//
//  Created by Nishikant Ashok UMBARKAR on 1/8/19.
//  Copyright © 2019 kspl. All rights reserved.
//

import UIKit

class ZoomImagesCollectionViewController: UIViewController {

    @IBOutlet var collectionview: UICollectionView!
    var imagesinstr = [String]()
    var images = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = imagesinstr.count > 0 ? "1/\(self.imagesinstr.count)" : ""
        for imgstr in self.imagesinstr {
            let url = URL(string: "\(ApiServices.shared.imageorpdfUrl)\(imgstr)")
            do {
                let data = try Data(contentsOf: url!)
                let image = UIImage(data: data)!
                self.images.append(image)
            } catch {
                print("catch")
            }
        }
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        DispatchQueue.main.async {
            self.collectionview.reloadData()
        }
    }
    
}
extension ZoomImagesCollectionViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.images.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ZoomImagesCollectionCell", for: indexPath) as! ZoomImagesCollectionCell
        collectionView.collectionViewLayout.invalidateLayout()
        print("cell:\(cell.frame.size)")
        let imageview = ImageScrollView(frame: CGRect(x: 0, y: 0, width: cell.frame.width, height: cell.frame.height))
        cell.addSubview(imageview)
        imageview.display(image: images[indexPath.row])
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height)
        print("sizeforitem:\(size)")
        return size
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let current = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width) + 1
        navigationItem.title = "\(current)/\(self.imagesinstr.count)"
    }
}
class ZoomImagesCollectionCell: UICollectionViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}
