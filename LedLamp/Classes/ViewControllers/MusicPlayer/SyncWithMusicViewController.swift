//
//  SyncWithMusicViewController.swift
//  LedLamp
//
//  Created by Valeriya Chernyak on 05.03.2024.
//

import UIKit
import BottomSheet

class SyncWithMusicViewController: UIViewController {
   
    @IBOutlet weak var playbackLightBtn: UIButton!
    @IBOutlet weak var syncWithMusicLabel: UILabel!
    @IBOutlet weak var selectLightButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playbackLightBtn.setTitle("playbackLight".localized, for: .normal)
        syncWithMusicLabel.text = "syncWithMusic2".localized
        selectLightButton.setTitle("selectLight".localized, for: .normal)
        selectLightButton.layer.cornerRadius = 30
        selectLightButton.layer.masksToBounds = true
    }
   
    @IBAction func playbackLightBtnDidTap(_ sender: Any) {
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
    
    @IBAction func backBtnDidTap(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func selectLightBtnDidTap(_ sender: Any) {
    }
    

}
