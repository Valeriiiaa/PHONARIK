//
//  ThirdPageViewController.swift
//  LedLamp
//
//  Created by Valeriya Chernyak on 07.03.2024.
//

import UIKit

class ThirdPageViewController: UIViewController {
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var adjustLabel: UILabel!
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        adjustLabel.text = "adjustLight".localized
        descriptionLabel.text = "discription3".localized
       
    }
    

    @IBAction func aheadBtnDidTap(_ sender: Any) {
    }
    
}
