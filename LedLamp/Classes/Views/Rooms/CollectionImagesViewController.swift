//
//  CollectionImagesViewController.swift
//  LedLamp
//
//  Created by Valeriya Chernyak on 04.03.2024.
//

import UIKit


class CollectionImagesViewController: UIViewController {
   
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionLabel: UILabel!
    
    var roomName: String!
    
    var images = [ImageResource.livingRoom, .bedroom, .bathroom, .kitchen, .livingRoom2, .bedroom2, .livingRoom3, .bedroom3]
    
    let sizeScale = [0.594, 0.382, 0.382, 0.594, 0.594, 0.382, 0.382, 0.594]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        preferredContentSize = .init(width: view.frame.width, height: 751)
        collectionLabel.text = "collection".localized
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: "CollectionImageCell", bundle: nil),forCellWithReuseIdentifier: "CollectionImageCell")
        
    }
    

    @IBAction func closeBtnDidTap(_ sender: Any) {
        self.dismiss(animated: true)
    }
    

}

extension CollectionImagesViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
   
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let entrance = UIStoryboard(name: "RoomBottomSheets", bundle: nil).instantiateViewController(identifier: "ChoosenRoomViewController")
        let image = images[indexPath.row]
        (entrance as? ChoosenRoomViewController)?.roomsName = roomName
        (entrance as? ChoosenRoomViewController)?.imageRoom = UIImage(resource: image)
        navigationController?.pushViewController(entrance, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let scale = sizeScale[indexPath.row]
        return CGSize(width: collectionView.frame.width * scale, height: 150)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionImageCell", for: indexPath)
        let image = UIImage(resource: images[indexPath.row])
        (cell as? CollectionImageCell)?.configure(imageRooms: image)
        return cell
    }
}
