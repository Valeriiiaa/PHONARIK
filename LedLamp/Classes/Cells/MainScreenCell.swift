//
//  MainScreenCell.swift
//  LedLamp
//
//  Created by Valeriya Chernyak on 01.03.2024.
//

import UIKit

class MainScreenCell: UITableViewCell {
    @IBOutlet weak var switcher: ConfigurableSwitchControl!
    @IBOutlet weak var backgrounCellView: UIView!
    @IBOutlet weak var lampImage: UIImageView!
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var roomNameLabel: UILabel!
    @IBOutlet weak var pizdaLightImageView: UIImageView!
    @IBOutlet weak var lightSmartLabel: UILabel!
    
    var menuDidTap: (()-> Void)?
    var switchValueChanged: ((Bool) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgrounCellView.layer.cornerRadius = 32
        backgrounCellView.layer.masksToBounds = true
        lightSmartLabel.text = "lightSmartLulb".localized
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
   
    @IBAction func switchDidTap(_ sender: Any) {
        stateLabel.text = switcher.isOn ? "connect".localized : "disconnect".localized
        stateLabel.textColor = switcher.isOn ? .activeText : .inactiveText
        switchValueChanged?(switcher.isOn)
    }
   
    @IBAction func menuBtnDidTap(_ sender: Any) {
        menuDidTap?()
    }
    
    func configure(deviceName: String, roomName: String, stateLabel: Bool, color: Int) {
        roomNameLabel.text = roomName
        lightSmartLabel.text = deviceName
        pizdaLightImageView.tintColor = UIColor(hex: color)
        self.stateLabel.textColor = stateLabel ? .activeText : .inactiveText
        DispatchQueue.main.async {
            self.switcher.setOn(stateLabel, animated: false)
        }
        self.stateLabel.text = stateLabel ? "connect".localized : "disconnect".localized
    }
}
