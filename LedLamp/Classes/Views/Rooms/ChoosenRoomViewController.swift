//
//  ChoosenRoomViewController.swift
//  LedLamp
//
//  Created by Valeriya Chernyak on 02.03.2024.
//

import UIKit

class ChoosenRoomViewController: UIViewController {
    
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var roomImage: UIImageView!
    @IBOutlet weak var roomName: UILabel!
    
    var roomsName = ""
    var imageRoom: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        preferredContentSize = .init(width: view.frame.width, height: 457)
        roomName.text = roomsName
        roomImage.image = imageRoom
        saveButton.setTitle("save".localized, for: .normal)
        saveButton.layer.cornerRadius = 30
        saveButton.layer.masksToBounds = true
        roomImage.layer.cornerRadius = 32
        roomImage.layer.masksToBounds = true
        loadViewIfNeeded()
        view.setNeedsLayout()
        view.layoutIfNeeded()
        view.layoutSubviews()
    }
    
    @IBAction func saveButtonDidTap(_ sender: Any) {
        //TODO: Show loader
        guard let room = HomeManager.shared.home?.rooms.first(where: { $0.name == roomsName }) else { 
            HomeManager.shared.createRoom(withName: roomsName, { [unowned self] room in
                DatabaseManager.shared.save(RoomModel(roomId: room.uniqueIdentifier.uuidString,
                                                      name: roomsName,
                                                      background: imageRoom?.pngData(),
                                                      lamps: "",
                                                      status: true,
                                                      room: room))
                DispatchQueue.main.async {
                    ActionManager.shared.reload()
                    self.dismiss(animated: true)
                }
            }, errorCompletion: { [unowned self] in
                self.dismiss(animated: true)
            })
            return
        }
        
        DatabaseManager.shared.save(RoomModel(roomId: room.uniqueIdentifier.uuidString,
                                              name: roomsName,
                                              background: imageRoom?.pngData(),
                                              lamps: "",
                                              status: true,
                                              room: room))
        DispatchQueue.main.async {
            ActionManager.shared.reload()
            self.dismiss(animated: true)
        }
    }
    
    @IBAction func closeBtnDidTap(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
}
