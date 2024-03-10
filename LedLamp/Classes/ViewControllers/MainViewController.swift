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
        
        HomeManager.shared.itemDidAdded = { [weak self] hm in
            guard let self else { return }
            DatabaseManager.shared.save(LampModel(name: hm.name, deviceId: hm.uniqueIdentifier.uuidString, color: 0xE7FE55, isEnabled: false, accessory: hm))
            ActionManager.shared.reload()
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
        HomeManager.shared.showCamera()
    }
    
    @IBAction func settingsButtonDidTap(_ sender: Any) {
        let entrance = UIStoryboard(name: "Settings", bundle: nil).instantiateViewController(withIdentifier: "SettingsViewController")
        entrance.modalPresentationStyle = .fullScreen
        entrance.modalTransitionStyle = .coverVertical
        present(entrance, animated: true)
    }
    
    func editName(lightModel: LampModel) {
        let alertController = UIAlertController(title: "New Room", message: "Please enter a room name", preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.text = lightModel.name
            textField.placeholder = "Room name..."
            textField.keyboardType = .default
            textField.autocorrectionType = .no
        }
        let okAction = UIAlertAction(title: "Save", style: .default) {
            action in guard let textField = alertController.textFields?.first,
                            let text = textField.text else {
                return
            }
            lightModel.name = text
            DatabaseManager.shared.update(lightModel)
            ActionManager.shared.reload()
            
            guard let accessory = lightModel.accessory else { return }
            
            HomeManager.shared.updateName(accessory, name: text, { _ in })
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
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
        print(light.accessory)
        (entrance as? ColorPickerViewController)?.lampModel = light
        present(entrance!, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MainScreenCell", for: indexPath)
        let lightModel = DatabaseManager.shared.load()[indexPath.row]
        (cell as? MainScreenCell)?.configure(deviceName: lightModel.name, 
                                             roomName: lightModel.room ?? "",
                                             stateLabel: lightModel.isEnabled,
                                             color: lightModel.color)
        
        (cell as? MainScreenCell)?.switchValueChanged = { [unowned self] value in
            lightModel.isEnabled = value
            DatabaseManager.shared.update(lightModel)
            lightModel.accessory?.getCharacteristic(forType: .power)?.writeValue(lightModel.isEnabled, completionHandler: { error in
                print(error)
            })
        }
        
        (cell as? MainScreenCell)?.menuDidTap = { [unowned self] in
            let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "editName".localized, style: .default, handler: { [unowned self] _ in
                self.editName(lightModel: lightModel)
            }))
            alert.addAction(UIAlertAction(title: "delete".localized, style: .destructive, handler: { [unowned tableView] _ in
                let alert = UIAlertController(title: nil, message: "wantToDelete".localized, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "yes".localized, style: .default, handler: { _ in
                    DispatchQueue.main.async {
                        DatabaseManager.shared.remove(lightModel.name)
                        ActionManager.shared.reload()
                        guard let accessory = lightModel.accessory else { return }
                        HomeManager.shared.removeDevice(accessory, { _ in })
                    }
                }))
                alert.addAction(UIAlertAction(title: "no".localized, style: .cancel))
                self.present(alert, animated: true)
            }))
           
            alert.addAction(UIAlertAction(title: "cancel".localized, style: .cancel))
            alert.popoverPresentationController?.barButtonItem = self.navigationItem.rightBarButtonItem
            present(alert, animated: true)
        }
        return cell
    }
}
