//
//  SettingsCell.swift
//  LedLamp
//
//  Created by Valeriya Chernyak on 26.02.2024.
//

import UIKit

class SettingsCell: UITableViewCell {
    
    @IBOutlet weak var backgroundSettingsView: UIView!
    @IBOutlet weak var settingsLabel: UILabel!
    @IBOutlet weak var settingsImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundSettingsView.layer.cornerRadius = 30
        backgroundSettingsView.layer.masksToBounds = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(settingsLabel: String, settingsImage: String) {
        self.settingsLabel.text = settingsLabel
        self.settingsImage.image = UIImage(named: settingsImage)
    }
}
