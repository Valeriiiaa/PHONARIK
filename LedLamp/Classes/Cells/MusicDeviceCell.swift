//
//  MusicDeviceCell.swift
//  LedLamp
//
//  Created by Valeriya Chernyak on 12.03.2024.
//

import UIKit

class MusicDeviceCell: UITableViewCell {
   
    @IBOutlet weak var chooseButton: UIButton!
    @IBOutlet weak var switcher: ConfigurableSwitchControl!
    @IBOutlet weak var backgroundCellView: UIView!
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var hexLabel: UILabel!
    @IBOutlet weak var intensityLabel: UILabel!
    @IBOutlet weak var roomNameLabel: UILabel!
    @IBOutlet weak var deviceNameLabel: UILabel!
    @IBOutlet weak var imageRoom: UIImageView!
    
    var menuButtonDidTap: (() -> Void)?
    var switchValueChanged: ((Bool) -> Void)?
    var choosenButtonDidTap: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageRoom.layer.cornerRadius = 16
        imageRoom.layer.masksToBounds = true
        backgroundCellView.layer.cornerRadius = 40
        backgroundCellView.layer.masksToBounds = true
      
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

       
    }
    @IBAction func chooseBtnDidTap(_ sender: Any) {
        choosenButtonDidTap?()
    }
    @IBAction func switcherDidTap(_ sender: Any) {
        switchValueChanged?(switcher.isOn)
        stateLabel.text = switcher.isOn ? "connect".localized : "disconnect".localized
        stateLabel.textColor = switcher.isOn ? .activeText : .inactiveText
    }
    
    @IBAction func menuBtnDidTap(_ sender: Any) {
        menuButtonDidTap?()
    }
    func configure(deviceName: String, imageDevice: UIImage, stateLabel: Bool, hexLabel: String, instensityLabel: String, isSelected: Bool) {
        self.imageRoom.image = imageDevice
        self.stateLabel.text = stateLabel ? "connect".localized : "disconnect".localized
        self.hexLabel.text = hexLabel
        intensityLabel.text = instensityLabel
        self.stateLabel.textColor = stateLabel ? .activeText : .inactiveText
        deviceNameLabel.text = deviceName
        chooseButton.isSelected = isSelected
        DispatchQueue.main.async {
            self.switcher.setOn(stateLabel, animated: false)
        }
    }
}
