//
//  AddLightViewController.swift
//  LedLamp
//
//  Created by Valeriya Chernyak on 03.03.2024.
//

import UIKit

class AddLightViewController: UIViewController {

    @IBOutlet weak var youDontHaveAnyLightLabel: UILabel!
    @IBOutlet weak var lampImage: UIImageView!
    @IBOutlet weak var roomNameLabel: UILabel!
    @IBOutlet weak var devicesConnectedLabel: UILabel!
  
    override func viewDidLoad() {
        super.viewDidLoad()
        youDontHaveAnyLightLabel.text = "youDontHaveLight".localized
        roomNameLabel.text = "".localized
        devicesConnectedLabel.text = "".localized
        
       
    }
    @IBAction func addLightBtnDidTap(_ sender: Any) {
    }
   
    @IBAction func menuBtnDidTap(_ sender: Any) {
    }
    

    @IBAction func backBtnDidTap(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
}
