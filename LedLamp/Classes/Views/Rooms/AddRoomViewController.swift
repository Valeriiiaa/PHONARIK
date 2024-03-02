//
//  AddRoomViewController.swift
//  LedLamp
//
//  Created by Valeriya Chernyak on 02.03.2024.
//

import UIKit

class AddRoomViewController: UIViewController {
    @IBOutlet weak var openCameraView: UIView!
    @IBOutlet weak var openCamerLabel: UILabel!
    @IBOutlet weak var addFromGalleryLabel: UILabel!
    @IBOutlet weak var galleryView: UIView!
    @IBOutlet weak var collectionLabel: UILabel!
    @IBOutlet weak var collectionView: UIView!
    @IBOutlet weak var wallpaperLabel: UILabel!
    @IBOutlet weak var textFieldNameDevice: TextField!
    @IBOutlet weak var pleaseInputLabel: UILabel!
    @IBOutlet weak var addRoomLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        preferredContentSize = .init(width: view.frame.width, height: 539)
        [openCameraView, galleryView, collectionView].forEach({ item in
            item?.layer.cornerRadius = 30
            item?.layer.masksToBounds = true
        })
        openCamerLabel.text = "OpenCamera".localized
        addFromGalleryLabel.text = "addFromGallery".localized
        collectionLabel.text = "collection".localized
        wallpaperLabel.text = "wallpaper".localized
        pleaseInputLabel.text = "pleaseInputRoomsName".localized
        addRoomLabel.text = "addRoom".localized
        
        textFieldNameDevice.layer.cornerRadius = 30
        textFieldNameDevice.layer.masksToBounds = true
        textFieldNameDevice.keyboardAppearance =  .dark
        textFieldNameDevice.autocapitalizationType = .sentences
        textFieldNameDevice.textColor = UIColor(red: 195/255, green: 195/255, blue: 195/255, alpha: 1)
        textFieldNameDevice.font = UIFont(name: "ChakraPetch-Regular", size: 16)
        textFieldNameDevice.tintColor = UIColor.white
        let attributes = [
            NSAttributedString.Key.foregroundColor: UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.7),
            NSAttributedString.Key.font : UIFont(name: "ChakraPetch-Regular", size: 16)!
        ]

        textFieldNameDevice.attributedPlaceholder = NSAttributedString(string: "deviceName".localized, attributes:attributes)
       
    }
   
    @IBAction func openCamerBtnDidTap(_ sender: Any) {
    }
   
    @IBAction func openGalleryBtnDidTap(_ sender: Any) {
    }
   
    @IBAction func collectionBtnDidTap(_ sender: Any) {
    }
    
    @IBAction func closeBtnDidTap(_ sender: Any) {
        self.dismiss(animated: true)
    }
}
