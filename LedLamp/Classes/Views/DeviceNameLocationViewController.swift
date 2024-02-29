//
//  DeviceNameLocationViewController.swift
//  LedLamp
//
//  Created by Valeriya Chernyak on 29.02.2024.
//

import UIKit
import IQKeyboardManagerSwift

class DeviceNameLocationViewController: UIViewController {
   
    @IBOutlet weak var locationCollectionView: UICollectionView!
    @IBOutlet weak var nextLabel: UILabel!
    @IBOutlet weak var backgroundNextView: UIView!
    @IBOutlet weak var textFieldName: TextField!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var deviceNameLabel: UILabel!
    @IBOutlet weak var lightingDevicaLabel: UILabel!
    
    let items = LocationCollectionViewModel.allCases
    
    override func viewDidLoad() {
        super.viewDidLoad()
        preferredContentSize = .init(width: view.frame.width, height: 503)
        nextLabel.text = "next".localized
        locationLabel.text = "whereDeviceLocated".localized
        deviceNameLabel.text = "whatDeviceName".localized
        lightingDevicaLabel.text = "lightingDeviceNameLocation".localized
        textFieldName.layer.cornerRadius = 30
        textFieldName.layer.masksToBounds = true
        backgroundNextView.layer.cornerRadius = 30
        backgroundNextView.layer.masksToBounds = true
        textFieldName.keyboardAppearance =  .dark
        textFieldName.textColor = UIColor(red: 195/255, green: 195/255, blue: 195/255, alpha: 1)
        textFieldName.font = UIFont(name: "ChakraPetch-Regular", size: 16)
        textFieldName.tintColor = UIColor.white
        let attributes = [
            NSAttributedString.Key.foregroundColor: UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.7),
            NSAttributedString.Key.font : UIFont(name: "ChakraPetch-Regular", size: 16)!
        ]

        textFieldName.attributedPlaceholder = NSAttributedString(string: "enterDeviceName".localized, attributes:attributes)
        locationCollectionView.delegate = self
        locationCollectionView.dataSource = self
        locationCollectionView.register(UINib(nibName: "DeviceLocationCell", bundle: nil),forCellWithReuseIdentifier: "DeviceLocationCell")
        
    }
    @IBAction func nextBtnDidTap(_ sender: Any) {
    }
    
    @IBAction func closeBtnDidTap(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    

}

extension DeviceNameLocationViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
  
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout:
                        UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       
        return CGSize(width: 175, height: 48)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 8)
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = items[indexPath.row]
        let cell = locationCollectionView.dequeueReusableCell(withReuseIdentifier: "DeviceLocationCell", for: indexPath)
        (cell as? DeviceLocationCell)?.configure(locationName: item.titel)
        return cell
    }
}
