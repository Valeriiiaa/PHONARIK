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
   
    override func awakeFromNib() {
        super.awakeFromNib()
        lightSmartBulbLabel.text = "lightSmartLulb".localized
        backgroundMainView.layer.cornerRadius = 40
        backgroundMainView.layer.masksToBounds = true
    }
   
    @IBAction func switchDidTap(_ sender: Any) {
    }
    
    @IBAction func menuBtnDidTap(_ sender: Any) {
        menuButtonDidTap?()
    }
    
    func configure(roomImage: UIImage, stateLabel: Bool, roomNameLabel: String) {
        self.roomImage.image = roomImage
        self.stateLabel.text = stateLabel ? "connect".localized : "disconnect".localized
        self.roomNameLabel.text = roomNameLabel
    }
}
