//
//  MusicAddLightViewController.swift
//  LedLamp
//
//  Created by Valeriya Chernyak on 11.03.2024.
//

import UIKit
import BottomSheet

class MusicAddLightViewController: UIViewController {
   
    @IBOutlet weak var youDontHaveLightsLabel: UILabel!
    @IBOutlet weak var playBackButton: UIButton!
    @IBOutlet weak var selectLightLabel: UILabel!
    @IBOutlet weak var addLightLabel: UILabel!
    @IBOutlet weak var backgroundAddLight: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playBackButton.setTitle("playbackLight".localized, for: .normal)
        selectLightLabel.text = "selectLight".localized
        addLightLabel.text = "addLight".localized
        youDontHaveLightsLabel.text = "youDontHaveLight".localized
    }
   
    @IBAction func playbackBtnDidTap(_ sender: Any) {
        let entrance = UIStoryboard(name: "PlaybackLightView", bundle: nil).instantiateViewController(identifier: "PlaybackLightViewController")
        let navigationContorller = BottomSheetNavigationController(rootViewController: entrance, configuration: BottomSheetConfiguration(
            cornerRadius: 40,
            pullBarConfiguration: .hidden,
            shadowConfiguration: .init(backgroundColor: UIColor(red: 34/255, green: 34/255, blue: 34/255, alpha: 0.46), blur: .regular)
        ))
        navigationContorller.navigationBar.isHidden = true
        navigationContorller.view.backgroundColor = UIColor(red: 116/255, green: 116/255, blue: 116/255, alpha: 1)
        presentBottomSheet(viewController: navigationContorller, configuration: BottomSheetConfiguration(
            cornerRadius: 40,
            pullBarConfiguration: .hidden,
            shadowConfiguration: .init(backgroundColor: UIColor(red: 34/255, green: 34/255, blue: 34/255, alpha: 0.46), blur: .regular)
        ))
    }

    @IBAction func backButtonDidTap(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func addLightBtnDidTap(_ sender: Any) {
    }
    
}
