//
//  MainViewController.swift
//  LedLamp
//
//  Created by Valeriya Chernyak on 26.02.2024.
//

import UIKit
import BottomSheet

class MainViewController: UIViewController {

   @IBOutlet weak var youDontHaveLight: UILabel!
    @IBOutlet weak var addLightLabel: UILabel!
    @IBOutlet weak var backgroundButtonView: UIView!
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var backgroundMainView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        youDontHaveLight.text = "youDontHaveLight".localized
        addLightLabel.text = "addLight".localized
        titleLabel.text = "brightenYourEnv".localized
        backgroundMainView.layer.cornerRadius = 40
        backgroundMainView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        backgroundButtonView.layer.cornerRadius = 36
        backgroundButtonView.layer.masksToBounds = true
    }
  
    @IBAction func addLightButtonDidTap(_ sender: Any) {
        let entrance = UIStoryboard(name: "ScanDeviceView", bundle: nil).instantiateViewController(identifier: "ScanDeviceView")
        presentBottomSheet(
            viewController: entrance,
            configuration: BottomSheetConfiguration(
                cornerRadius: 40,
                pullBarConfiguration: .hidden,
                shadowConfiguration: .init(backgroundColor: UIColor(red: 34/255, green: 34/255, blue: 34/255, alpha: 0.46), blur: .regular)
            )
        )
    }
    
    @IBAction func settingsButtonDidTap(_ sender: Any) {
        let entrance = UIStoryboard(name: "Settings", bundle: nil).instantiateViewController(withIdentifier: "SettingsViewController")
        navigationController?.pushViewController(entrance, animated: true)
    }
}
