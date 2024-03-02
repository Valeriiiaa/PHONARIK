//
//  DeviceNameLocationViewController.swift
//  LedLamp
//
//  Created by Valeriya Chernyak on 29.02.2024.
//

import UIKit
import IQKeyboardManagerSwift
import BottomSheet


class DeviceNameLocationViewController: UIViewController {
   
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var locationCollectionView: UICollectionView!
    @IBOutlet weak var nextLabel: UILabel!
    @IBOutlet weak var backgroundNextView: UIView!
    @IBOutlet weak var textFieldName: TextField!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var deviceNameLabel: UILabel!
    @IBOutlet weak var lightingDevicaLabel: UILabel!
    
    let items = LocationCollectionViewModel.allCases
    var selectedIndex: Int?
    
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
        textFieldName.autocapitalizationType = .sentences
        textFieldName.textColor = UIColor(red: 195/255, green: 195/255, blue: 195/255, alpha: 1)
        textFieldName.font = UIFont(name: "ChakraPetch-Regular", size: 16)
        textFieldName.tintColor = UIColor.white
        textFieldName.iq.enableMode = .disabled
        textFieldName.iq.toolbar.isHidden = true
        let attributes = [
            NSAttributedString.Key.foregroundColor: UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.7),
            NSAttributedString.Key.font : UIFont(name: "ChakraPetch-Regular", size: 16)!
        ]

        textFieldName.attributedPlaceholder = NSAttributedString(string: "enterDeviceName".localized, attributes:attributes)
        locationCollectionView.delegate = self
        locationCollectionView.dataSource = self
        locationCollectionView.register(UINib(nibName: "DeviceLocationCell", bundle: nil),forCellWithReuseIdentifier: "DeviceLocationCell")
        
        textFieldName.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
    }
    @IBAction func nextBtnDidTap(_ sender: Any) {
        let entrance = UIStoryboard(name: "ScanDeviceView", bundle: nil).instantiateViewController(identifier: "DeviceAddedViewController")
        (entrance as? DeviceAddedViewController)?.deviceName = textFieldName.text ?? ""
        navigationController?.setViewControllers([entrance], animated: true)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        activateNextBtn()
    }
    
    @IBAction func closeBtnDidTap(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    func activateNextBtn() {
        if textFieldName.text != nil, textFieldName.text?.isEmpty == false && selectedIndex != nil {
            nextLabel.textColor = UIColor.white
            backgroundNextView.backgroundColor = UIColor(red: 34/255, green: 34/255, blue: 34/255, alpha: 1)
            nextButton.isEnabled = true
        } else {
            nextLabel.textColor = UIColor(red: 158/255, green: 158/255, blue: 158/255, alpha: 1)
            backgroundNextView.backgroundColor = UIColor(red: 34/255, green: 34/255, blue: 34/255, alpha: 0.6)
            nextButton.isEnabled = false
        }
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        collectionView.reloadData()
        activateNextBtn()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = items[indexPath.row]
        let cell = locationCollectionView.dequeueReusableCell(withReuseIdentifier: "DeviceLocationCell", for: indexPath)
        let backgroundColor = indexPath.row == selectedIndex ? UIColor.white : UIColor(red: 116/255, green: 116/255, blue: 116/255, alpha: 1)
        let labelColor = indexPath.row == selectedIndex ? UIColor(red: 34/255, green: 34/255, blue: 34/255, alpha: 1) : UIColor.white
        (cell as? DeviceLocationCell)?.configure(locationName: item.titel, backgroundLocationView: backgroundColor, labelColor: labelColor)
        return cell
    }
}
