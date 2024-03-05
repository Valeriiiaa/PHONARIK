//
//  MainScreenCell.swift
//  LedLamp
//
//  Created by Valeriya Chernyak on 01.03.2024.
//

import UIKit

class MainScreenCell: UITableViewCell {
    @IBOutlet weak var backgrounCellView: UIView!
    @IBOutlet weak var lampImage: UIImageView!
    @IBOutlet weak var switchState: UISwitch!
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var roomNameLabel: UILabel!
    @IBOutlet weak var lightSmartLabel: UILabel!
    
    var menuDidTap: (()-> Void)?
    
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
    }
   
    @IBAction func menuBtnDidTap(_ sender: Any) {
        menuDidTap?()
    }
    
    func configure(deviceName: String, roomName: String, stateLabel: Bool) {
        roomNameLabel.text = roomName
        lightSmartLabel.text = deviceName
        self.stateLabel.text = stateLabel ? "connect".localized : "disconnect".localized
    }
}
