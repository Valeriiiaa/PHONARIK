//
//  SecondPageViewController.swift
//  LedLamp
//
//  Created by Valeriya Chernyak on 07.03.2024.
//

import UIKit

class SecondPageViewController: UIViewController {
    @IBOutlet weak var stackViews: UIStackView!
    @IBOutlet weak var discriptionLabel: UILabel!
    @IBOutlet weak var yourFeedbackLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        discriptionLabel.text = "discription2".localized
        yourFeedbackLabel.text = "yourFeedback".localized
        stackViews.arrangedSubviews.forEach({ item in
            item.layer.cornerRadius = 6
            item.layer.masksToBounds = true
        })
       
    }
    

    @IBAction func aheadBtnDidTap(_ sender: Any) {
        let entrance = UIStoryboard(name: "Onboarding", bundle: nil).instantiateViewController(identifier: "ThirdPageViewController")
        present(entrance, animated: true)
    }
    
}
