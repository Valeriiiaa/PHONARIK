//
//  MusicPlayerViewController.swift
//  LedLamp
//
//  Created by Valeriya Chernyak on 04.03.2024.
//

import UIKit

class MusicPlayerViewController: UIViewController {

    @IBOutlet weak var syncWithMusicBtn: UIButton!
    @IBOutlet weak var musicOnIphineBtn: UIButton!
    @IBOutlet weak var selectYourMusicLabel: UILabel!
    @IBOutlet weak var brigtenBackgroundView: UIView!
    @IBOutlet weak var brightenedLabel: UILabel!
  
    override func viewDidLoad() {
        super.viewDidLoad()
        syncWithMusicBtn.setTitle("syncWithMusic".localized, for: .normal)
        musicOnIphineBtn.setTitle("musicOnIphone".localized, for: .normal)
        selectYourMusicLabel.text = "selectYourMusicSource".localized
        brightenedLabel.text = "brightenYourEnv".localized
        brigtenBackgroundView.layer.cornerRadius = 40
        brigtenBackgroundView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
       
        syncWithMusicBtn.titleLabel?.numberOfLines = 3
        syncWithMusicBtn.titleLabel?.textAlignment = .center
        musicOnIphineBtn.titleLabel?.numberOfLines = 3
        musicOnIphineBtn.titleLabel?.textAlignment = .center
       }
    
    @IBAction func syncWithMusicBtnDidTap(_ sender: Any) {
        let entrance = UIStoryboard(name: "MusicPlayer", bundle: nil).instantiateViewController(withIdentifier: "SyncWithMusicViewController")
        navigationController?.pushViewController(entrance, animated: true)
    }
   
    @IBAction func musicOnIphoneBtnDidTap(_ sender: Any) {
        let entrance = UIStoryboard(name: "MusicPlayer", bundle: nil).instantiateViewController(withIdentifier: "MusicIphoneViewController")
        navigationController?.pushViewController(entrance, animated: true)
    }
    
    
    @IBAction func settingsBtnDidTap(_ sender: Any) {
        let entrance = UIStoryboard(name: "Settings", bundle: nil).instantiateViewController(withIdentifier: "SettingsViewController")
        navigationController?.pushViewController(entrance, animated: true)
    }
    
}
