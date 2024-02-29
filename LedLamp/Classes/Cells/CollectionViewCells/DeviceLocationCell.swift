//
//  DeviceLocationCell.swift
//  LedLamp
//
//  Created by Valeriya Chernyak on 29.02.2024.
//

import UIKit

class DeviceLocationCell: UICollectionViewCell {
    
   @IBOutlet weak var backgroundLocationView: UIView!
    @IBOutlet weak var locationName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundLocationView.layer.borderWidth = 1
        backgroundLocationView.layer.borderColor = UIColor.white.cgColor
        backgroundLocationView.layer.cornerRadius = 24
        backgroundLocationView.layer.masksToBounds = true
       
    }
    
    func configure(locationName: String, backgroundLocationView: UIColor, labelColor: UIColor) {
        self.locationName.text = locationName
        self.backgroundLocationView.backgroundColor = backgroundLocationView
        self.locationName.textColor = labelColor
    }
}
