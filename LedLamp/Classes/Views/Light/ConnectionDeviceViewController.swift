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
    @IBOutlet weak var nativeProgressView: UIProgressView!
    var currentProgress: Float = 0.0
    var timer: Timer?
    
    var scannedValue: String!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        connectionLabel.text = "connectionToLightingDevice".localized
        ensureLabel.text = "ensureThatAccessoryPlugged".localized
        preferredContentSize = .init(width: view.frame.width, height: 403)
        
        let timer = Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(updateProgress), userInfo: nil, repeats: true)
        RunLoop.main.add(timer, forMode: .common)
        self.timer = timer
      
    }
    
    @objc
    private func updateProgress() {
        nativeProgressView.progress += 0.1
        currentProgress += 0.1
        procentLabel.text = Int(nativeProgressView.progress * Float(100)).description + "%"
        guard currentProgress > 1.1 else { return }
        let storyboard = UIStoryboard(name: "ScanDeviceView", bundle: nil)
        timer?.invalidate()
        timer = nil
        let vc = storyboard.instantiateViewController(withIdentifier: "DeviceNameLocationViewController")
        (vc as? DeviceNameLocationViewController)?.scannedValue = scannedValue
        navigationController?.pushViewController(vc, animated: true)
    }
    

    @IBAction func closeBtnDidTap(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
}
