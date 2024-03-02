//
//  SelectAccessoryViewController.swift
//  LedLamp
//
//  Created by Valeriya Chernyak on 02.03.2024.
//

import UIKit

class SelectAccessoryViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var makeSureDeviceCloseLabel: UILabel!
    @IBOutlet weak var selectAccessoryLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        preferredContentSize = .init(width: view.frame.width, height: 641)
        makeSureDeviceCloseLabel.text = "makeSure".localized
        selectAccessoryLabel.text = "selectAccesory".localized
       
    }
    

    @IBAction func closeBtnDidTap(_ sender: Any) {
        self.dismiss(animated: true)
    }
}
