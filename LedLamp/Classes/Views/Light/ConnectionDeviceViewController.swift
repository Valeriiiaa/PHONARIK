//
//  ConnectionDeviceViewController.swift
//  LedLamp
//
//  Created by Valeriya Chernyak on 29.02.2024.
//

import UIKit

class ConnectionDeviceViewController: UIViewController {
    @IBOutlet weak var connectionLabel: UILabel!
    @IBOutlet weak var ensureLabel: UILabel!
    @IBOutlet weak var progressView: UIView!
    @IBOutlet weak var procentLabel: UILabel!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        connectionLabel.text = "connectionToLightingDevice".localized
        ensureLabel.text = "ensureThatAccessoryPlugged".localized
        
        preferredContentSize = .init(width: view.frame.width, height: 403)
      
    }
    

    @IBAction func closeBtnDidTap(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
}
