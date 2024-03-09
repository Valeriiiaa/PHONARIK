//
//  RoomsViewController.swift
//  LedLamp
//
//  Created by Valeriya Chernyak on 03.03.2024.
//

import UIKit
import BottomSheet

class ActionManager {
    static let shared = ActionManager()
    var reloadData = [(() -> Void)]()
    
    func reload() {
        reloadData.forEach({ $0() })
    }
}

class RoomsViewController: UIViewController {

    @IBOutlet var buttonTopConstraint: NSLayoutConstraint!
    @IBOutlet var sofaImageView: UIImageView!
    @IBOutlet var youDontHaveAnyRoomsLabel: UILabel!
    @IBOutlet weak var roomCollectionView: UICollectionView!
    @IBOutlet weak var backgroundBrightenView: UIView!
    @IBOutlet weak var backgroundAddRoomView: UIView!
    @IBOutlet weak var addButton: UILabel!
    @IBOutlet weak var brightenYourEnviroment: UILabel!
    
    var previousCell: AddedRoomCell?
    
    var bottomButtomConstraint: NSLayoutConstraint!
    
    private var pageSize: CGSize {
        let layout = self.roomCollectionView.collectionViewLayout as! UPCarouselFlowLayout
        var pageSize = layout.itemSize
        if layout.scrollDirection == .horizontal {
            pageSize.width += layout.minimumLineSpacing
        } else {
            pageSize.height += layout.minimumLineSpacing
        }
        return pageSize
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        brightenYourEnviroment.text = "brightenYourEnv".localized
        addButton.text = "addRoom".localized
        youDontHaveAnyRoomsLabel.text = "youDontHaveRooms".localized
        backgroundBrightenView.layer.cornerRadius = 40
        backgroundBrightenView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        backgroundAddRoomView.layer.cornerRadius = 36
        backgroundAddRoomView.layer.masksToBounds = true
        
        roomCollectionView.delegate = self
        roomCollectionView.dataSource = self
        
        roomCollectionView.register(UINib(nibName: "AddedRoomCell", bundle: nil),
                                    forCellWithReuseIdentifier: "AddedRoomCell")
        
        ActionManager.shared.reloadData.append { [weak self] in
            guard let self else { return }
            self.configureCollectionView()
            self.roomCollectionView.reloadData()
        }
        configureCollectionView()
        setupLayout()
    }
    
    private func configureCollectionView() {
        let isEmptyRooms = DatabaseManager.shared.loadRooms().isEmpty
        roomCollectionView.isHidden = isEmptyRooms
        sofaImageView.isHidden = !isEmptyRooms
        youDontHaveAnyRoomsLabel.isHidden = !isEmptyRooms
        buttonTopConstraint.isActive = isEmptyRooms
        bottomButtomConstraint?.isActive = false
        
        let layout = roomCollectionView.collectionViewLayout as! UPCarouselFlowLayout
        layout.centeredIndexPath = { [unowned self] indexPath in
            let center = self.view.convert(roomCollectionView.center, to: self.roomCollectionView)
            guard let index = roomCollectionView!.indexPathForItem(at: center) else { return }
            let cell = roomCollectionView.cellForItem(at: index) as? AddedRoomCell
            previousCell?.backgroundMainView.layer.borderColor = UIColor.clear.cgColor
            cell?.backgroundMainView.layer.borderColor = UIColor(red: 231/255, green: 254/255, blue: 85/255, alpha: 1).cgColor
            print(roomCollectionView.indexPathsForVisibleItems)
            previousCell = cell
        }
        
        if !isEmptyRooms {
            bottomButtomConstraint = backgroundAddRoomView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
            bottomButtomConstraint.isActive = true
            roomCollectionView.heightAnchor.constraint(lessThanOrEqualToConstant: 630).isActive = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: { [unowned self] in
            let firIndexPath = IndexPath(row: 0, section: 0)
            let cell = roomCollectionView.cellForItem(at: firIndexPath)
            (cell as? AddedRoomCell)?.backgroundMainView.layer.borderColor = UIColor(red: 231/255, green: 254/255, blue: 85/255, alpha: 1).cgColor
            previousCell = cell as? AddedRoomCell
        })
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
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let layout = self.roomCollectionView.collectionViewLayout as! UPCarouselFlowLayout
        layout.itemSize = .init(width: roomCollectionView.frame.height * 0.8, height: roomCollectionView.frame.height)
    }
    
    private func setupLayout() {
        roomCollectionView.layoutIfNeeded()
        let layout = self.roomCollectionView.collectionViewLayout as! UPCarouselFlowLayout
        layout.spacingMode = UPCarouselFlowLayoutSpacingMode.fixed(spacing: 10)
        
    }
    
    @IBAction func settingsDidTap(_ sender: Any) {
        let entrance = UIStoryboard(name: "Settings", bundle: nil).instantiateViewController(withIdentifier: "SettingsViewController")
        entrance.modalPresentationStyle = .fullScreen
        entrance.modalTransitionStyle = .coverVertical
        present(entrance, animated: true)
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
}

extension RoomsViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        DatabaseManager.shared.loadRooms().count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddedRoomCell", for: indexPath)
        let room = DatabaseManager.shared.loadRooms()[indexPath.row]
        var image = UIImage(resource: .kitchen)
        if let background = room.background,
        let img = UIImage(data: background) {
            image = img
        }
        (cell as? AddedRoomCell)?.configure(roomImage: image, stateLabel: room.status, roomNameLabel: room.name)
        
        (cell as? AddedRoomCell)?.menuButtonDidTap = {
            let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "editName".localized, style: .default, handler: { [unowned self] _ in
                self.editName(roomModel: room)
            }))
            alert.addAction(UIAlertAction(title: "delete".localized, style: .destructive, handler: { [unowned self] _ in
                let alert = UIAlertController(title: nil, message: "wantToDelete".localized, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "yes".localized, style: .default, handler: { _ in
                    DispatchQueue.main.async {
                        DatabaseManager.shared.removeRoom(room.name)
                        ActionManager.shared.reload()
                    }
                }))
                alert.addAction(UIAlertAction(title: "no".localized, style: .cancel))
                self.present(alert, animated: true)
            }))
            
            alert.addAction(UIAlertAction(title: "cancel".localized, style: .cancel))
            alert.popoverPresentationController?.barButtonItem = self.navigationItem.rightBarButtonItem
            self.present(alert, animated: true)
        }
        
        (cell as? AddedRoomCell)?.switchValueChanged = { value in
            room.status = value
            DatabaseManager.shared.update(room, oldName: room.name)
        }
        return cell
    }
}
