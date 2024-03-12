//
//  RoomDeviceCell.swift
//  LedLamp
//
//  Created by Valeriya Chernyak on 11.03.2024.
//

import UIKit

class RoomDeviceCell: UITableViewCell {
   
    @IBOutlet weak var hexLabel: UILabel!
    @IBOutlet weak var intensityLabel: UILabel!
    @IBOutlet weak var bckgroundCellView: UIView!
    @IBOutlet weak var switchView: ConfigurableSwitchControl!
    @IBOutlet weak var deviceNameLabel: UILabel!
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var imageDevice: UIImageView!
    
    var menuButtonDidTap: (() -> Void)?
    var switchValueChanged: ((Bool) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageDevice.layer.cornerRadius = 16
        imageDevice.layer.masksToBounds = true
        bckgroundCellView.layer.cornerRadius = 40
        bckgroundCellView.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    
    @IBAction func menuBtnDIdTap(_ sender: Any) {
        menuButtonDidTap?()
    }
   
    @IBAction func switcherDidTap(_ sender: Any) {
        switchValueChanged?(switchView.isOn)
        stateLabel.text = switchView.isOn ? "connect".localized : "disconnect".localized
        stateLabel.textColor = switchView.isOn ? .activeText : .inactiveText
    }
    
    func configure(deviceName: String, imageDevice: UIImage, stateLabel: Bool, hexLabel: String, instensityLabel: String) {
        self.imageDevice.image = imageDevice
        self.stateLabel.text = stateLabel ? "connect".localized : "disconnect".localized
        self.hexLabel.text = hexLabel
        intensityLabel.text = instensityLabel
        self.stateLabel.textColor = stateLabel ? .activeText : .inactiveText
        deviceNameLabel.text = deviceName
        DispatchQueue.main.async {
            self.switchView.setOn(stateLabel, animated: false)
        }
    }
}
