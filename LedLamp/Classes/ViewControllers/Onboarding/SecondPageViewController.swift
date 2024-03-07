//
//  SecondPageViewController.swift
//  LedLamp
//
//  Created by Valeriya Chernyak on 07.03.2024.
//

import UIKit

class SecondPageViewController: UIViewController {
    @IBOutlet weak var discriptionLabel: UILabel!
    @IBOutlet weak var yourFeedbackLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        discriptionLabel.text = "discription2".localized
        yourFeedbackLabel.text = "yourFeedback".localized
 
       
    }
    

    @IBAction func aheadBtnDidTap(_ sender: Any) {
    }
    
}
