//
//  SelectAccessoryCell.swift
//  LedLamp
//
//  Created by Valeriya Chernyak on 02.03.2024.
//

import UIKit

class SelectAccessoryCell: UITableViewCell {

    @IBOutlet weak var titleLampLabel: UILabel!
    @IBOutlet weak var backgroundCellView: UIView!
   
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundCellView.layer.cornerRadius = 30
        backgroundCellView.layer.masksToBounds = true
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

       
    }
    func configure(titleLampLabel: String) {
        self.titleLampLabel.text = titleLampLabel
    }
}
