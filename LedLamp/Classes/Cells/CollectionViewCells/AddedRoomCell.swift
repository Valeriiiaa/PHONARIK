//
//  AddedRoomCell.swift
//  LedLamp
//
//  Created by Valeriya Chernyak on 03.03.2024.
//

import UIKit

class AddedRoomCell: UICollectionViewCell {
    @IBOutlet weak var switcher: ConfigurableSwitchControl!
    @IBOutlet weak var backgroundMainView: UIView!
    @IBOutlet weak var roomImage: UIImageView!
    @IBOutlet weak var roomNameLabel: UILabel!
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var lightSmartBulbLabel: UILabel!
    
    var menuButtonDidTap: (() -> Void)?
    var switchValueChanged: ((Bool) -> Void)?
   
    override func awakeFromNib() {
        super.awakeFromNib()
        roomImage.layer.cornerRadius = 16
        roomImage.layer.masksToBounds = true
        lightSmartBulbLabel.text = "lightSmartLulb".localized
        backgroundMainView.layer.cornerRadius = 40
        backgroundMainView.layer.masksToBounds = true
        backgroundMainView.layer.borderWidth = 2
        backgroundMainView.layer.borderColor = UIColor.clear.cgColor
    }
   
    @IBAction func switchDidTap(_ sender: Any) {
        switchValueChanged?(switcher.isOn)
        stateLabel.text = switcher.isOn ? "connect".localized : "disconnect".localized
        stateLabel.textColor = switcher.isOn ? .activeText : .inactiveText
    }
    
    @IBAction func menuBtnDidTap(_ sender: Any) {
        menuButtonDidTap?()
    }
    
    func configure(roomImage: UIImage, stateLabel: Bool, roomNameLabel: String) {
        self.roomImage.image = roomImage
        self.stateLabel.text = stateLabel ? "connect".localized : "disconnect".localized
        self.stateLabel.textColor = stateLabel ? .activeText : .inactiveText
        self.roomNameLabel.text = roomNameLabel
        DispatchQueue.main.async {
            self.switcher.setOn(stateLabel, animated: false)
        }
    }
}
