//
//  AddedRoomCell.swift
//  LedLamp
//
//  Created by Valeriya Chernyak on 03.03.2024.
//

import UIKit

class AddedRoomCell: UICollectionViewCell {
    @IBOutlet weak var backgroundMainView: UIView!
    @IBOutlet weak var roomImage: UIImageView!
    @IBOutlet weak var switchState: UISwitch!
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
    }
   
    @IBAction func switchDidTap(_ sender: Any) {
            switchValueChanged?(switchState.isOn)
        switchState.onTintColor = .green
        switchState.tintColor = .red
        switchState.subviews[0].subviews[0].backgroundColor = .red
    }
    
    @IBAction func menuBtnDidTap(_ sender: Any) {
        menuButtonDidTap?()
    }
    
    func configure(roomImage: UIImage, stateLabel: Bool, roomNameLabel: String) {
        self.roomImage.image = roomImage
        self.stateLabel.text = stateLabel ? "connect".localized : "disconnect".localized
        switchState.onTintColor = .green
        switchState.tintColor = .red
        switchState.subviews[0].subviews[0].backgroundColor = .red
        switchState.setNeedsDisplay()
        switchState.layoutSubviews()
        switchState.tintColorDidChange()
        switchState.isOn = stateLabel
        self.roomNameLabel.text = roomNameLabel
        switchState.onTintColor = .green
        switchState.tintColor = .red
        switchState.subviews[0].subviews[0].backgroundColor = .red
        switchState.setNeedsDisplay()
        switchState.layoutSubviews()
        switchState.tintColorDidChange()
    }
}
