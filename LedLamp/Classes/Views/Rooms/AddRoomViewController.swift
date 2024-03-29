//
//  AddRoomViewController.swift
//  LedLamp
//
//  Created by Valeriya Chernyak on 02.03.2024.
//

import UIKit
import BottomSheet
import IQKeyboardManagerSwift

class AddRoomViewController: UIViewController {
   
    @IBOutlet weak var openCameraButton: UIButton!
    @IBOutlet weak var galleryButton: UIButton!
    @IBOutlet weak var collectionButton: UIButton!
    @IBOutlet weak var openCameraView: UIView!
    @IBOutlet weak var openCamerLabel: UILabel!
    @IBOutlet weak var addFromGalleryLabel: UILabel!
    @IBOutlet weak var galleryView: UIView!
    @IBOutlet weak var collectionLabel: UILabel!
    @IBOutlet weak var collectionView: UIView!
    @IBOutlet weak var wallpaperLabel: UILabel!
    @IBOutlet weak var textFieldNameDevice: TextField!
    @IBOutlet weak var pleaseInputLabel: UILabel!
    @IBOutlet weak var addRoomLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        preferredContentSize = .init(width: view.frame.width, height: 539)
        [openCameraView, galleryView, collectionView].forEach({ item in
            item?.layer.cornerRadius = 30
            item?.layer.masksToBounds = true
        })
        openCamerLabel.text = "OpenCamera".localized
        addFromGalleryLabel.text = "addFromGallery".localized
        collectionLabel.text = "collection".localized
        wallpaperLabel.text = "wallpaper".localized
        pleaseInputLabel.text = "pleaseInputRoomsName".localized
        addRoomLabel.text = "addRoom".localized
        textFieldNameDevice.delegate = self
        
        [openCameraView, galleryView, collectionView].forEach({ item in
            item?.isUserInteractionEnabled = false
        })
        textFieldNameDevice.iq.enableMode = .disabled
        textFieldNameDevice.iq.toolbar.isHidden = true
        textFieldNameDevice.layer.cornerRadius = 30
        textFieldNameDevice.layer.masksToBounds = true
        textFieldNameDevice.keyboardAppearance =  .dark
        textFieldNameDevice.autocapitalizationType = .sentences
        textFieldNameDevice.textColor = UIColor(red: 195/255, green: 195/255, blue: 195/255, alpha: 1)
        textFieldNameDevice.font = UIFont(name: "ChakraPetch-Regular", size: 16)
        textFieldNameDevice.tintColor = UIColor.white
        let attributes = [
            NSAttributedString.Key.foregroundColor: UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.7),
            NSAttributedString.Key.font : UIFont(name: "ChakraPetch-Regular", size: 16)!
        ]

        textFieldNameDevice.attributedPlaceholder = NSAttributedString(string: "roomName".localized, attributes:attributes)
        
        textFieldNameDevice.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    private func pushToNext(with image: UIImage) {
        let entrance = UIStoryboard(name: "RoomBottomSheets", bundle: nil).instantiateViewController(identifier: "ChoosenRoomViewController")
        (entrance as? ChoosenRoomViewController)?.roomsName = textFieldNameDevice.text ?? ""
        (entrance as? ChoosenRoomViewController)?.imageRoom = image
        navigationController?.pushViewController(entrance, animated: true)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        configureText()
    }
    
    private func configureText() {
        if textFieldNameDevice.text != nil, textFieldNameDevice.text?.isEmpty == false {
            [openCameraView, galleryView, collectionView].forEach({ item in
                item?.isUserInteractionEnabled = true
            })
        } else {
            [openCameraView, galleryView, collectionView].forEach({ item in
                item?.isUserInteractionEnabled = false
            })
        }
    }
   
    @IBAction func openCamerBtnDidTap(_ sender: Any) {
        let cameraVc = UIImagePickerController()
        cameraVc.sourceType = UIImagePickerController.SourceType.camera
        cameraVc.delegate = self
        self.present(cameraVc, animated: true, completion: nil)
    }
   
    @IBAction func openGalleryBtnDidTap(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil
        )}
    
   
    @IBAction func collectionBtnDidTap(_ sender: Any) {
        let entrance = UIStoryboard(name: "CollectionImages", bundle: nil).instantiateViewController(identifier: "CollectionImagesViewController")
        (entrance as? CollectionImagesViewController)?.roomName = textFieldNameDevice.text ?? ""
        navigationController?.pushViewController(entrance, animated: true)
    }
    
    @IBAction func closeBtnDidTap(_ sender: Any) {
        self.dismiss(animated: true)
    }
}

extension AddRoomViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var newImage: UIImage
        if let possibleImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            newImage = possibleImage
        } else if let possibleImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            newImage = possibleImage
        } else {
            return
        }
        
        self.dismiss(animated: true, completion: nil)
        
        pushToNext(with: newImage)
    }
}

extension AddRoomViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder()
            return true
        }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        let rooms = HomeManager.shared.home?.rooms ?? []
        if !rooms.isEmpty {
            textField.resignFirstResponder()
            let alert = UIAlertController(title: "Select the room", message: nil, preferredStyle: .actionSheet)
            
            for room in rooms {
                alert.addAction(UIAlertAction(title: room.name, style: .default, handler: { _ in
                    DispatchQueue.main.async {
                        textField.text = room.name
                        self.configureText()
                    }
                }))
            }
            
            alert.addAction(UIAlertAction(title: "New room", style: .default, handler: { _ in
                DispatchQueue.main.async {
                    self.showRoomNameAlert()
                }
            }))
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            self.present(alert, animated: true)
            return false
        }
        return true
    }
    
    private func showRoomNameAlert() {
        let alertController = UIAlertController(title: "New Room", message: "Please enter a room name", preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.placeholder = "Room name..."
            textField.keyboardType = .default
            textField.autocorrectionType = .no
        }
        let okAction = UIAlertAction(title: "Save", style: .default) {
            action in guard let textField = alertController.textFields?.first,
                            let text = textField.text else {
                print("No value has been entered in email address")
                return
            }
            
            print("Entered email address value: \(text)")
            DispatchQueue.main.async {
                self.textFieldNameDevice.text = text
                self.configureText()
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }
}

