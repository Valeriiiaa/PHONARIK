//
//  AddLightViewController.swift
//  LedLamp
//
//  Created by Valeriya Chernyak on 03.03.2024.
//

import UIKit

class AddLightViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var youDontHaveAnyLightLabel: UILabel!
    @IBOutlet weak var lampImage: UIImageView!
    @IBOutlet weak var roomNameLabel: UILabel!
    @IBOutlet weak var devicesConnectedLabel: UILabel!
  
    override func viewDidLoad() {
        super.viewDidLoad()
        youDontHaveAnyLightLabel.text = "youDontHaveLight".localized
        tableView.register(UINib(nibName: "RoomDeviceCell", bundle: nil), forCellReuseIdentifier: "RoomDeviceCell")
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func configureTableView() {
        let isEmptyLights = DatabaseManager.shared.load().isEmpty
        tableView.showsVerticalScrollIndicator = false
        tableView.contentInset = .init(top: 0, left: 0, bottom: 100, right: 0)
        tableView.isHidden = isEmptyLights
        tableView.isHidden = !isEmptyLights
        youDontHaveAnyLightLabel.isHidden = !isEmptyLights
    }
   
    @IBAction func addLightBtnDidTap(_ sender: Any) {
        
    }
   
    @IBAction func menuBtnDidTap(_ sender: Any) {
    }
    
    @IBAction func backBtnDidTap(_ sender: Any) {
        navigationController?.popViewController(animated: true)
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

extension AddLightViewController: UITableViewDelegate, UITableViewDataSource {
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        DatabaseManager.shared.load().count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RoomDeviceCell", for: indexPath)
        let lightModel = DatabaseManager.shared.load()[indexPath.row]
        (cell as? RoomDeviceCell)?.configure(deviceName: lightModel.name, imageDevice: UIImage(), stateLabel: lightModel.isEnabled, hexLabel: UIColor(hex: lightModel.color).hexValue(), instensityLabel: "")
        
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
