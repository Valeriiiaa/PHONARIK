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
    
    private var currentPage: Int = 0
    
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
        addButton.text = "addLight".localized
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
        setupLayout()
        configureCollectionView()
    }
    
    private func configureCollectionView() {
        let isEmptyRooms = DatabaseManager.shared.loadRooms().isEmpty
        roomCollectionView.isHidden = isEmptyRooms
        sofaImageView.isHidden = !isEmptyRooms
        youDontHaveAnyRoomsLabel.isHidden = !isEmptyRooms
        buttonTopConstraint.isActive = isEmptyRooms
        if !isEmptyRooms {
            backgroundAddRoomView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16).isActive = true
        }
    }
    
    private func setupLayout() {
        let layout = self.roomCollectionView.collectionViewLayout as! UPCarouselFlowLayout
        layout.spacingMode = UPCarouselFlowLayoutSpacingMode.overlap(visibleOffset: 30)
        layout.itemSize = .init(width: 384, height: roomCollectionView.frame.height - 100)
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
        return cell
    }
}
