//
//  CollectionImageCell.swift
//  LedLamp
//
//  Created by Valeriya Chernyak on 04.03.2024.
//

import UIKit

class CollectionImageCell: UICollectionViewCell {
    @IBOutlet weak var imageRooms: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageRooms.layer.cornerRadius = 20
        imageRooms.layer.masksToBounds = true
    }
    func configure(imageRooms: UIImage) {
        self.imageRooms.image = imageRooms
    }
}
