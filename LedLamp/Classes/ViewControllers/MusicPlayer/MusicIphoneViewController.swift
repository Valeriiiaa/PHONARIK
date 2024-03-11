//
//  MusicIphoneViewController.swift
//  LedLamp
//
//  Created by Valeriya Chernyak on 04.03.2024.
//

import UIKit
import BottomSheet

class MusicIphoneViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var playBackLightBtn: UIButton!
    @IBOutlet weak var musicOnIPhoneLabel: UILabel!
    @IBOutlet weak var selectLightButton: UIButton!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        playBackLightBtn.setTitle("playbackLight".localized, for: .normal)
        musicOnIPhoneLabel.text = "musicOnIphone2".localized
        selectLightButton.setTitle("selectLight".localized, for: .normal)
        selectLightButton.layer.cornerRadius = 30
        selectLightButton.layer.masksToBounds = true
       
    }
    @IBAction func selectLightDidTap(_ sender: Any) {
        let storyboard = UIStoryboard(name: "MusicPlayer", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "MusicAddLightViewController")
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .coverVertical
        present(vc, animated: true)
    }
    
    @IBAction func backButtonDidTap(_ sender: Any) {
        dismiss(animated: true)
    }
   
    @IBAction func playBackLightBtnDidTap(_ sender: Any) {
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
    
}
