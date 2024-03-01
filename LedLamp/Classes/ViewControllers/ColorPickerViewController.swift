//
//  ColorPickerViewController.swift
//  LedLamp
//
//  Created by Valeriya Chernyak on 01.03.2024.
//

import UIKit

class ColorPickerViewController: UIViewController {

    @IBOutlet weak var roomLabel: UILabel!
    @IBOutlet weak var lightSamartLabel: UILabel!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var lampImage: UIImageView!
    @IBOutlet weak var colorPickerView: UIView!
    @IBOutlet weak var intensityLabel: UILabel!
    @IBOutlet weak var intensityView: UIView!
    @IBOutlet weak var plinthLabel: UILabel!
    @IBOutlet weak var plinthView: UIView!
    @IBOutlet weak var hexLabel: UILabel!
    @IBOutlet weak var hexView: UIView!
    @IBOutlet weak var offButton: UIButton!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        saveButton.setTitle("save".localized, for: .normal)
        lightSamartLabel.text = "lightSmartLulb".localized
        plinthLabel.text = "plinth".localized
        intensityLabel.text = "intensity".localized
        
        [hexView, plinthView, intensityView].forEach( { item in
            item?.layer.cornerRadius =  10
            item?.layer.masksToBounds = true
        })
    }
    @IBAction func saveBtnDidTap(_ sender: Any) {
    }
    
    @IBAction func offBtnDidTap(_ sender: Any) {
    }
  
    @IBAction func backBtnDidTap(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func menuBtnDidTap(_ sender: Any) {
        
    }
    
}
