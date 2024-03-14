//
//  AddLightViewController.swift
//  LedLamp
//
//  Created by Valeriya Chernyak on 03.03.2024.
//

import UIKit

class AddLightViewController: UIViewController {

    @IBOutlet weak var lampImage: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var youDontHaveAnyLightLabel: UILabel!
    @IBOutlet weak var roomNameLabel: UILabel!
    @IBOutlet weak var devicesConnectedLabel: UILabel!
    
    var roomModel: RoomModel!
    
    var lamps = [LampModel]()
    
    var image = ["firstImage", "fourthImage", "SecondImage", "thirdImage", "firstImage", "fourthImage", "SecondImage", "thirdImage", "firstImage", "fourthImage", "SecondImage", "thirdImage", "firstImage", "fourthImage", "SecondImage", "thirdImage", "firstImage", "fourthImage", "SecondImage", "thirdImage", "firstImage", "fourthImage", "SecondImage", "thirdImage", "firstImage", "fourthImage", "SecondImage", "thirdImage", "firstImage", "fourthImage", "SecondImage", "thirdImage", "firstImage", "fourthImage", "SecondImage", "thirdImage", "firstImage", "fourthImage", "SecondImage", "thirdImage", "firstImage", "fourthImage", "SecondImage", "thirdImage", "firstImage", "fourthImage", "SecondImage", "thirdImage", "firstImage", "fourthImage", "SecondImage", "thirdImage", "firstImage", "fourthImage", "SecondImage", "thirdImage", "firstImage", "fourthImage", "SecondImage", "thirdImage", "firstImage", "fourthImage", "SecondImage", "thirdImage", "firstImage", "fourthImage", "SecondImage", "thirdImage", "firstImage", "fourthImage", "SecondImage", "thirdImage", "firstImage", "fourthImage", "SecondImage", "thirdImage","firstImage", "fourthImage", "SecondImage", "thirdImage", "firstImage", "fourthImage", "SecondImage", "thirdImage","firstImage", "fourthImage", "SecondImage", "thirdImage", "firstImage", "fourthImage", "SecondImage", "thirdImage","firstImage", "fourthImage", "SecondImage", "thirdImage","firstImage", "fourthImage", "SecondImage", "thirdImage","firstImage", "fourthImage", "SecondImage", "thirdImage", "firstImage", "fourthImage", "SecondImage", "thirdImage"]
  
    override func viewDidLoad() {
        super.viewDidLoad()
        youDontHaveAnyLightLabel.text = "youDontHaveLight".localized
        tableView.register(UINib(nibName: "RoomDeviceCell", bundle: nil), forCellReuseIdentifier: "RoomDeviceCell")
        roomNameLabel.text = roomModel.name
        tableView.dataSource = self
        tableView.delegate = self
        lamps = DatabaseManager.shared.loadLamp(by: roomModel.name)
        ActionManager.shared.reloadData.append { [weak self] in
            guard let self else { return }
            self.lamps = DatabaseManager.shared.loadLamp(by: roomModel.name)
            configureTableView()
        }
        configureTableView()
    }
    
    private func configureTableView() {
        let isEmptyLights = lamps.isEmpty
        tableView.showsVerticalScrollIndicator = false
        tableView.contentInset = .init(top: 0, left: 0, bottom: 100, right: 0)
        tableView.isHidden = isEmptyLights
//        tableView.isHidden = !isEmptyLights
        youDontHaveAnyLightLabel.isHidden = !isEmptyLights
        lampImage.isHidden = !isEmptyLights
        
        devicesConnectedLabel.text = lamps.count.description + " " + "devicesConnected".localized
        tableView.reloadData()
    }
    
    func editName(roomModel: RoomModel) {
        let alertController = UIAlertController(title: "New Room", message: "Please enter a room name", preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.text = roomModel.name
            textField.placeholder = "Room name..."
            textField.keyboardType = .default
            textField.autocorrectionType = .no
        }
        let okAction = UIAlertAction(title: "Save", style: .default) {
            action in guard let textField = alertController.textFields?.first,
                            let text = textField.text else {
                return
            }
            let oldName = roomModel.name
            roomModel.name = text
            DatabaseManager.shared.update(roomModel, oldName: oldName)
            ActionManager.shared.reload()
            
            guard let room = roomModel.room else { return }
            HomeManager.shared.updateRoom(room, name: text, { _ in })
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
   
    @IBAction func addLightBtnDidTap(_ sender: Any) {
        HomeManager.shared.showCamera()
    }
   
    @IBAction func menuBtnDidTap(_ sender: Any) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "editName".localized, style: .default, handler: { [unowned self] _ in
            self.editName(roomModel: roomModel)
        }))
        alert.addAction(UIAlertAction(title: "delete".localized, style: .destructive, handler: { [unowned self] _ in
            let alert = UIAlertController(title: nil, message: "wantToDelete".localized, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "yes".localized, style: .default, handler: { _ in
                DispatchQueue.main.async {
                    DatabaseManager.shared.removeRoom(self.roomModel.name)
                    ActionManager.shared.reload()
                    dismiss(animated: true)
                }
            }))
            alert.addAction(UIAlertAction(title: "no".localized, style: .cancel))
            self.present(alert, animated: true)
        }))
        
        alert.addAction(UIAlertAction(title: "cancel".localized, style: .cancel))
        alert.popoverPresentationController?.barButtonItem = self.navigationItem.rightBarButtonItem
        self.present(alert, animated: true)
    }
    
    @IBAction func backBtnDidTap(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    func editName(lightModel: LampModel) {
        let alertController = UIAlertController(title: "New Room", message: "Please enter a room name", preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.text = lightModel.name
            textField.placeholder = "Room name..."
            textField.keyboardType = .default
            textField.autocorrectionType = .no
        }
        let okAction = UIAlertAction(title: "Save", style: .default) { [unowned self]
            action in guard let textField = alertController.textFields?.first,
                            let text = textField.text else {
                return
            }
            lightModel.name = text
            roomNameLabel.text = text
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
        lamps.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RoomDeviceCell", for: indexPath)
        let lightModel = lamps[indexPath.row]
        let imageName = image[indexPath.row]
        (cell as? RoomDeviceCell)?.configure(deviceName: lightModel.name,
                                             imageDevice: UIImage(named: imageName) ?? UIImage(),
                                             stateLabel: lightModel.isEnabled,
                                             hexLabel: "#" + UIColor(hex: lightModel.color).hexValue(),
                                             instensityLabel: Int(UIColor(hex: lightModel.color).hsbColor.brightness * 100).description + "%")
        
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
                        DatabaseManager.shared.remove(lightModel.deviceId)
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
