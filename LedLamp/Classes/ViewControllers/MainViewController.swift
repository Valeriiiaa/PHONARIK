//
//  MainViewController.swift
//  LedLamp
//
//  Created by Valeriya Chernyak on 26.02.2024.
//

import UIKit
import BottomSheet

class MainViewController: UIViewController {

    @IBOutlet weak var lightsTableView: UITableView!
    @IBOutlet weak var youDontHaveSmartLightsLabel: UILabel!
    @IBOutlet weak var lightImageView: UIImageView!
    @IBOutlet weak var youDontHaveLight: UILabel!
    @IBOutlet weak var addLightLabel: UILabel!
    @IBOutlet weak var backgroundButtonView: UIView!
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var backgroundMainView: UIView!
    
    var bottomButtonConstraint: NSLayoutConstraint!
    
    @IBOutlet var buttonTopConstraint: NSLayoutConstraint!
    let homeKitManager = HomeManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        youDontHaveLight.text = "youDontHaveLight".localized
        addLightLabel.text = "addLight".localized
        titleLabel.text = "brightenYourEnv".localized
        backgroundMainView.layer.cornerRadius = 40
        backgroundMainView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        backgroundButtonView.layer.cornerRadius = 36
        backgroundButtonView.layer.masksToBounds = true
        lightsTableView.register(UINib(nibName: "MainScreenCell", bundle: nil), forCellReuseIdentifier: "MainScreenCell")
        
        lightsTableView.dataSource = self
        lightsTableView.delegate = self
        
        ActionManager.shared.reloadData.append { [weak self] in
            guard let self else { return }
            self.configureTableView()
            self.lightsTableView.reloadData()
        }
        
        configureTableView()
    }
    
    private func configureTableView() {
        let isEmptyLights = DatabaseManager.shared.load().isEmpty
        lightsTableView.showsVerticalScrollIndicator = false
        lightsTableView.contentInset = .init(top: 0, left: 0, bottom: 100, right: 0)
        lightsTableView.isHidden = isEmptyLights
        lightImageView.isHidden = !isEmptyLights
        youDontHaveSmartLightsLabel.isHidden = !isEmptyLights
        buttonTopConstraint.isActive = isEmptyLights
        bottomButtonConstraint?.isActive = false
        if !isEmptyLights {
            bottomButtonConstraint = backgroundButtonView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
            bottomButtonConstraint.isActive = true
        }
    }
  
    @IBAction func addLightButtonDidTap(_ sender: Any) {
        let entrance = UIStoryboard(name: "ScanDeviceView", bundle: nil).instantiateViewController(identifier: "ScanDeviceView")
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
    
    @IBAction func settingsButtonDidTap(_ sender: Any) {
        let entrance = UIStoryboard(name: "Settings", bundle: nil).instantiateViewController(withIdentifier: "SettingsViewController")
        navigationController?.pushViewController(entrance, animated: true)
    }
    
    func editName(_ action: Any) {
        
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        DatabaseManager.shared.load().count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let light = DatabaseManager.shared.load()[indexPath.row]
        let entrance = UIStoryboard(name: "ColorPicker", bundle: nil).instantiateInitialViewController()
        entrance?.modalPresentationStyle = .fullScreen
        entrance?.modalTransitionStyle = .crossDissolve
        present(entrance!, animated: true)
//        navigationController?.pushViewController(entrance!, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MainScreenCell", for: indexPath)
        let lightModel = DatabaseManager.shared.load()[indexPath.row]
        (cell as? MainScreenCell)?.configure(deviceName: lightModel.name, roomName: lightModel.room ?? "", stateLabel: lightModel.isEnabled)
        
        (cell as? MainScreenCell)?.menuDidTap = { [unowned self] in
            let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "editName".localized, style: .default, handler: editName))
            alert.addAction(UIAlertAction(title: "delete".localized, style: .destructive, handler: { [unowned tableView] _ in
                let alert = UIAlertController(title: nil, message: "wantToDelete".localized, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "yes".localized, style: .default, handler: { _ in
                    DispatchQueue.main.async {
                        DatabaseManager.shared.remove(lightModel.name)
                        ActionManager.shared.reload()
                    }
                }))
                alert.addAction(UIAlertAction(title: "no".localized, style: .cancel))
                self.present(alert, animated: true)
                
                
            }))
           
            alert.addAction(UIAlertAction(title: "cancel".localized, style: .cancel))
            alert.popoverPresentationController?.barButtonItem = self.navigationItem.rightBarButtonItem
            present(alert, animated: true)
        }
        
        (cell as? MainScreenCell)?.switchValueChanged = { [lightModel] value in
            lightModel.isEnabled = value
            DatabaseManager.shared.update(lightModel)
            print("saved")
        }
        return cell
    }
}
