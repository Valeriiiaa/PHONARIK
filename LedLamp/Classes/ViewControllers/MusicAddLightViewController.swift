//
//  MusicAddLightViewController.swift
//  LedLamp
//
//  Created by Valeriya Chernyak on 11.03.2024.
//

import UIKit
import BottomSheet

class MusicAddLightViewController: UIViewController {
   
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var lampImageView: UIImageView!
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var buttonTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var youDontHaveLightsLabel: UILabel!
    @IBOutlet weak var playBackButton: UIButton!
    @IBOutlet weak var selectLightLabel: UILabel!
    @IBOutlet weak var addLightLabel: UILabel!
    @IBOutlet weak var backgroundAddLight: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    var selectedLamps = [LampModel]()
    
    var saveDidTap: (([LampModel]) -> Void)?
    
    var image = ["firstImage", "fourthImage", "SecondImage", "thirdImage", "firstImage", "fourthImage", "SecondImage", "thirdImage", "firstImage", "fourthImage", "SecondImage", "thirdImage", "firstImage", "fourthImage", "SecondImage", "thirdImage", "firstImage", "fourthImage", "SecondImage", "thirdImage", "firstImage", "fourthImage", "SecondImage", "thirdImage", "firstImage", "fourthImage", "SecondImage", "thirdImage", "firstImage", "fourthImage", "SecondImage", "thirdImage", "firstImage", "fourthImage", "SecondImage", "thirdImage", "firstImage", "fourthImage", "SecondImage", "thirdImage", "firstImage", "fourthImage", "SecondImage", "thirdImage", "firstImage", "fourthImage", "SecondImage", "thirdImage", "firstImage", "fourthImage", "SecondImage", "thirdImage", "firstImage", "fourthImage", "SecondImage", "thirdImage", "firstImage", "fourthImage", "SecondImage", "thirdImage", "firstImage", "fourthImage", "SecondImage", "thirdImage", "firstImage", "fourthImage", "SecondImage", "thirdImage", "firstImage", "fourthImage", "SecondImage", "thirdImage", "firstImage", "fourthImage", "SecondImage", "thirdImage","firstImage", "fourthImage", "SecondImage", "thirdImage", "firstImage", "fourthImage", "SecondImage", "thirdImage","firstImage", "fourthImage", "SecondImage", "thirdImage", "firstImage", "fourthImage", "SecondImage", "thirdImage","firstImage", "fourthImage", "SecondImage", "thirdImage","firstImage", "fourthImage", "SecondImage", "thirdImage","firstImage", "fourthImage", "SecondImage", "thirdImage", "firstImage", "fourthImage", "SecondImage", "thirdImage"]
    
    var lights = [LampModel]()
    
    var bottomButtonConstraint: NSLayoutConstraint!
    let homeKitManager = HomeManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playBackButton.setTitle("playbackLight".localized, for: .normal)
        selectLightLabel.text = "selectLight".localized
        addLightLabel.text = "addLight".localized
        youDontHaveLightsLabel.text = "youDontHaveLight".localized
        backgroundAddLight.layer.cornerRadius = 30
        backgroundAddLight.layer.masksToBounds = true
        
        tableView.register(UINib(nibName: "MusicDeviceCell", bundle: nil), forCellReuseIdentifier: "MusicDeviceCell")
        tableView.dataSource = self
        tableView.delegate = self
        
        lights = DatabaseManager.shared.load()
        configure()
        configureTableView()
        
        saveButton.layer.cornerRadius = 30
        saveButton.layer.masksToBounds = true
        
        ActionManager.shared.reloadData.append { [weak self] in
            guard let self else { return }
            lights = DatabaseManager.shared.load()
            self.configure()
            self.configureTableView()
            self.tableView.reloadData()
        }
        
    }
    @IBAction func plusBtnDidTap(_ sender: Any) {
        HomeManager.shared.showCamera()
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
    
    private func configure() {
        backgroundAddLight.isHidden = !lights.isEmpty
        plusButton.isHidden = lights.isEmpty
        saveButton.isHidden = lights.isEmpty
        tableView.isHidden = lights.isEmpty
    }

    @IBAction func saveButtonDidTap(_ sender: Any) {
        saveDidTap?(selectedLamps)
        dismiss(animated: true)
    }
    
    @IBAction func backButtonDidTap(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func addLightBtnDidTap(_ sender: Any) {
        HomeManager.shared.showCamera()
    }
    
    private func configureTableView() {
        let isEmptyLights = lights.isEmpty
        tableView.showsVerticalScrollIndicator = false
        tableView.contentInset = .init(top: 0, left: 0, bottom: 100, right: 0)
        youDontHaveLightsLabel.isHidden = !isEmptyLights
        lampImageView.isHidden = !isEmptyLights
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
        lights.count
    }
   
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let lamp = lights[indexPath.row]
        guard selectedLamps.contains(where: { $0.deviceId == lamp.deviceId }) else {
            selectedLamps.append(lamp)
            tableView.reloadData()
            return
        }
        selectedLamps.removeAll(where: { $0.deviceId == lamp.deviceId })
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MusicDeviceCell", for: indexPath)
        let lightModel = lights[indexPath.row]
       
        let image = UIImage(named: image[indexPath.row]) ?? UIImage()
        (cell as? MusicDeviceCell)?.configure(deviceName: lightModel.name,
                                              roomName: lightModel.room ?? "",
                                              imageDevice: image,
                                              stateLabel: lightModel.isEnabled,
                                              hexLabel: "#" + UIColor(hex: lightModel.color).hexValue(),
                                              instensityLabel: Int(UIColor(hex: lightModel.color).hsbColor.brightness * 100).description + "%",
                                              isSelected: selectedLamps.contains(where: { $0.deviceId == lightModel.deviceId }))
        
        (cell as? MusicDeviceCell)?.switchValueChanged = { value in
            lightModel.isEnabled = value
            DatabaseManager.shared.update(lightModel)
            lightModel.accessory?.getCharacteristic(forType: .power)?.writeValue(lightModel.isEnabled, completionHandler: { error in
                print(error)
            })
        }
        (cell as? MusicDeviceCell)?.menuButtonDidTap = { [unowned self] in
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
