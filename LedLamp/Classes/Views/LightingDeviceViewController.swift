//
//  LightingDeviceViewController.swift
//  LedLamp
//
//  Created by Valeriya Chernyak on 29.02.2024.
//

import UIKit
import BottomSheet

class LightingDeviceViewController: UIViewController {
   
    @IBOutlet weak var backgroundAddView: UIView!
    @IBOutlet weak var addToAppleHomeLabel: UILabel!
    @IBOutlet weak var lampImage: UIImageView!
    @IBOutlet weak var lightingDeviceLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addToAppleHomeLabel.text = "addAppleHome".localized
        lightingDeviceLabel.text = "lightingDevice".localized
        backgroundAddView.layer.cornerRadius = 30
        backgroundAddView.layer.masksToBounds = true
        
        preferredContentSize = .init(width: view.frame.width, height: 403)
    }
    
    @IBAction func addBtnDidTap(_ sender: Any) {
        let entrance = UIStoryboard(name: "ScanDeviceView", bundle: nil).instantiateViewController(identifier: "ConnectionDeviceViewController")
        presentBottomSheet(
            viewController: entrance,
            configuration: BottomSheetConfiguration(
                cornerRadius: 40,
                pullBarConfiguration: .hidden,
                shadowConfiguration: .init(backgroundColor: UIColor(red: 34/255, green: 34/255, blue: 34/255, alpha: 0.46), blur: .regular)
            )
        )
    }
   
    @IBAction func closeBtnDidTap(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
  

}
