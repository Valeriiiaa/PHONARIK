//
//  PlaybackLightViewController.swift
//  LedLamp
//
//  Created by Valeriya Chernyak on 04.03.2024.
//

import UIKit

class PlaybackLightViewController: UIViewController {
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var pressPlayLabel: UILabel!
    @IBOutlet weak var thisFeatureLabel: UILabel!
    @IBOutlet weak var playBackLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        preferredContentSize = .init(width: view.frame.width, height: 403)
        doneButton.setTitle("done".localized, for: .normal)
        pressPlayLabel.text = "pressPlay".localized
        thisFeatureLabel.text = "thisFeatureWorks".localized
        playBackLabel.text = "playbackLight".localized
        doneButton.layer.cornerRadius = 30
        doneButton.layer.masksToBounds = true
       
    }
    
    @IBAction func closeBtnDidTap(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
  
    @IBAction func doneBtnDidTap(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
}
