//
//  MusicAddLightViewController.swift
//  LedLamp
//
//  Created by Valeriya Chernyak on 11.03.2024.
//

import UIKit
import BottomSheet

class MusicAddLightViewController: UIViewController {
   
    @IBOutlet weak var buttonTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var youDontHaveLightsLabel: UILabel!
    @IBOutlet weak var playBackButton: UIButton!
    @IBOutlet weak var selectLightLabel: UILabel!
    @IBOutlet weak var addLightLabel: UILabel!
    @IBOutlet weak var backgroundAddLight: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    var bottomButtonConstraint: NSLayoutConstraint!
    let homeKitManager = HomeManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playBackButton.setTitle("playbackLight".localized, for: .normal)
        selectLightLabel.text = "selectLight".localized
        addLightLabel.text = "addLight".localized
        youDontHaveLightsLabel.text = "youDontHaveLight".localized
        
        tableView.register(UINib(nibName: "RoomDeviceCell", bundle: nil), forCellReuseIdentifier: "RoomDeviceCell")
        tableView.dataSource = self
        tableView.delegate = self
        
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
        HomeManager.shared.showCamera()
    }
    
    private func configureTableView() {
        let isEmptyLights = DatabaseManager.shared.load().isEmpty
        tableView.showsVerticalScrollIndicator = false
        tableView.contentInset = .init(top: 0, left: 0, bottom: 100, right: 0)
        tableView.isHidden = isEmptyLights
        tableView.isHidden = !isEmptyLights
        youDontHaveLightsLabel.isHidden = !isEmptyLights
        buttonTopConstraint.isActive = isEmptyLights
        bottomButtonConstraint?.isActive = false
        if !isEmptyLights {
            bottomButtonConstraint = backgroundAddLight.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
            bottomButtonConstraint.isActive = true
        }
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

extension MusicAddLightViewController: UITableViewDelegate, UITableViewDataSource {
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        DatabaseManager.shared.load().count
    }
   
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RoomDeviceCell", for: indexPath)
        let lightModel = DatabaseManager.shared.load()[indexPath.row]
        (cell as? RoomDeviceCell)?.configure(imageDevice: UIImage(), stateLabel: lightModel.isEnabled, hexLabel: UIColor(hex: lightModel.color).hexValue(), instensityLabel: <#T##String#>)
        
        (cell as? MainScreenCell)?.switchValueChanged = { [unowned self] value in
            lightModel.isEnabled = value
            DatabaseManager.shared.update(lightModel)
            lightModel.accessory?.getCharacteristic(forType: .power)?.writeValue(lightModel.isEnabled, completionHandler: { error in
                print(error)
            })
        }
        (cell as? RoomDeviceCell)?.menuButtonDidTap = { [unowned self] in
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
