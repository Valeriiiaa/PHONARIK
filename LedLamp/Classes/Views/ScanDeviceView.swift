//
//  ScanDeviceView.swift
//  LedLamp
//
//  Created by Valeriya Chernyak on 27.02.2024.
//

import UIKit
import BottomSheet
import AVFoundation

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
        qrCodeView.layer.cornerRadius = 32
        qrCodeView.layer.masksToBounds = true
        backgroundMoreOptionView.layer.cornerRadius = 30
        backgroundMoreOptionView.layer.masksToBounds = true
        
        preferredContentSize = .init(width: view.frame.width, height: 641)
       }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AVCaptureDevice.requestAccess(for: .video) { success in
                if success {
                    // Access granted, set up the camera
                    self.setupCamera()
                } else {
                    // Access denied, handle accordingly (show alert, etc.)
                    print("Camera access denied")
                }
            }
    }
    
    func setupCamera() {
        let captureSession = AVCaptureSession()
        
        guard let captureDevice = AVCaptureDevice.default(for: .video) else {
            print("Failed to get the camera device")
            return
        }
        
        guard let input = try? AVCaptureDeviceInput(device: captureDevice) else {
            print("Failed to create input device")
            return
        }
        
        captureSession.addInput(input)
        
        let metadataOutput = AVCaptureMetadataOutput()
        if captureSession.canAddOutput(metadataOutput) {
            captureSession.addOutput(metadataOutput)
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]
        } else {
            print("Failed to add metadata output")
            return
        }
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        DispatchQueue.main.async {
            previewLayer.frame = self.qrCodeView.layer.bounds
            previewLayer.videoGravity = .resizeAspectFill
            self.qrCodeView.layer.addSublayer(previewLayer)
            
    }
        captureSession.startRunning()
    }
   
    @IBAction func closeButtonDidTap(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func moreOptionBtnDidTap(_ sender: Any) {
    }
    
    

}

extension ScanDeviceView: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if let metadataObject = metadataObjects.first as? AVMetadataMachineReadableCodeObject {
            if metadataObject.type == .qr, let qrCode = metadataObject.stringValue {
                // Handle the QR code (e.g., print or display it)
                print("QR Code: \(qrCode)")
            }
        }
    }
}
