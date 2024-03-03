//
//  RoomsViewController.swift
//  LedLamp
//
//  Created by Valeriya Chernyak on 03.03.2024.
//

import UIKit
import BottomSheet

class RoomsViewController: UIViewController {

    @IBOutlet weak var backgroundBrightenView: UIView!
    @IBOutlet weak var backgroundAddRoomView: UIView!
    @IBOutlet weak var addButton: UILabel!
    @IBOutlet weak var brightenYourEnviroment: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        brightenYourEnviroment.text = "brightenYourEnv".localized
        addButton.text = "addLight".localized
        backgroundBrightenView.layer.cornerRadius = 40
        backgroundBrightenView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        backgroundAddRoomView.layer.cornerRadius = 36
        backgroundAddRoomView.layer.masksToBounds = true
}
   
    @IBAction func addRoomBtnDidTap(_ sender: Any) {
        let entrance = UIStoryboard(name: "RoomBottomSheets", bundle: nil).instantiateViewController(identifier: "AddRoomViewController")
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
    
    @IBAction func settingBtnDidTap(_ sender: Any) {
        let entrance = UIStoryboard(name: "Settings", bundle: nil).instantiateViewController(withIdentifier: "SettingsViewController")
        navigationController?.pushViewController(entrance, animated: true)
    }
}
