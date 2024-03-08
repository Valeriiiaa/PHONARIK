//
//  SelectAccessoryViewController.swift
//  LedLamp
//
//  Created by Valeriya Chernyak on 02.03.2024.
//

import UIKit

class SelectAccessoryViewController: UIViewController {
    
    @IBOutlet weak var accessoryNotListedButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var makeSureDeviceCloseLabel: UILabel!
    @IBOutlet weak var selectAccessoryLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        preferredContentSize = .init(width: view.frame.width, height: 641)
        makeSureDeviceCloseLabel.text = "makeSure".localized
        selectAccessoryLabel.text = "selectAccesory".localized
        accessoryNotListedButton.setTitle("accessoryNotListed".localized, for: .normal)
    }
    
    @IBAction func accessoryNotListedBtnDidTap(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func closeBtnDidTap(_ sender: Any) {
        self.dismiss(animated: true)
    }
}
