//
//  MainViewController.swift
//  LedLamp
//
//  Created by Valeriya Chernyak on 26.02.2024.
//

import UIKit

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
    }
    
    @IBAction func settingsButtonDidTap(_ sender: Any) {
        let entrance = UIStoryboard(name: "Settings", bundle: nil).instantiateViewController(withIdentifier: "SettingsViewController")
        navigationController?.pushViewController(entrance, animated: true)
    }
}
