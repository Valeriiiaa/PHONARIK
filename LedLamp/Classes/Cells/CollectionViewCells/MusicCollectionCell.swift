//
//  MusicCollectionCell.swift
//  LedLamp
//
//  Created by Valeriya Chernyak on 11.03.2024.
//

import UIKit

class MusicCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var stateButton: UIButton!
    @IBOutlet weak var roomNameLabel: UILabel!
    @IBOutlet weak var deviceNameLabel: UILabel!
  
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    @IBAction func stateBtnDidTap(_ sender: Any) {
    }
    
    func configure(roomNameLabel: String, deviceNameLabel: String, isEnabled: Bool) {
        self.roomNameLabel.text = roomNameLabel
        self.deviceNameLabel.text = deviceNameLabel
        stateButton.setImage(UIImage(resource: isEnabled ? .musicOn : .musicOff), for: .normal)
    }
}
