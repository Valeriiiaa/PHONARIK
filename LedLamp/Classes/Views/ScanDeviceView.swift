//
//  ScanDeviceView.swift
//  LedLamp
//
//  Created by Valeriya Chernyak on 27.02.2024.
//

import UIKit
import BottomSheet

class ScanDeviceView: UIViewController {
    
    @IBOutlet weak var backgroundMoreOptionView: UIView!
    @IBOutlet weak var moreOptionLabel: UILabel!
    @IBOutlet weak var youCanAlsoPlaceLabel: UILabel!
    @IBOutlet weak var bringIphoneCloseLabel: UILabel!
    @IBOutlet weak var locateQrCodeLabel: UILabel!
    @IBOutlet weak var scanSetupLabel: UILabel!
    @IBOutlet weak var qrCodeView: UIView!
    @IBOutlet weak var scanCodeLabel: UILabel!
    @IBOutlet weak var addDeviceLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        moreOptionLabel.text = "moreOptions".localized
        youCanAlsoPlaceLabel.text = "youCanPlaceIphone".localized
        bringIphoneCloseLabel.text = "bringIphoneClose".localized
        scanSetupLabel.text = "scanSetupCode".localized
        scanCodeLabel.text = "scanCode".localized
        addDeviceLabel.text = "addDevice".localized
        locateQrCodeLabel.text = "locateQRCode".localized
        
        backgroundMoreOptionView.layer.cornerRadius = 30
        backgroundMoreOptionView.layer.masksToBounds = true
        
        preferredContentSize = .init(width: view.frame.width, height: 641)
       
    }
   
    @IBAction func closeButtonDidTap(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func moreOptionBtnDidTap(_ sender: Any) {
    }
    
    

}
