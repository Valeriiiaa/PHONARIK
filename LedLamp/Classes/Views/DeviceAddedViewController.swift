//
//  DeviceAddedViewController.swift
//  LedLamp
//
//  Created by Valeriya Chernyak on 29.02.2024.
//

import UIKit

class DeviceAddedViewController: UIViewController {

    @IBOutlet weak var livingroomImage: UIImageView!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var deviceAddedLabel: UILabel!
  
    override func viewDidLoad() {
        super.viewDidLoad()
        preferredContentSize = .init(width: view.frame.width, height: 390)
        doneButton.layer.cornerRadius = 30
        doneButton.layer.masksToBounds = true
        doneButton.setTitle("done".localized, for: .normal)
        deviceAddedLabel.text = "deviceAdded".localized
    }
    
    @IBAction func closeBtn(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    
    @IBAction func doneBtnDidTap(_ sender: Any) {
    }
    
}
