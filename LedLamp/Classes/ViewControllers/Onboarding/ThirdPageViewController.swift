//
//  ThirdPageViewController.swift
//  LedLamp
//
//  Created by Valeriya Chernyak on 07.03.2024.
//

import UIKit

class ThirdPageViewController: UIViewController {
    @IBOutlet weak var stackViews: UIStackView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var adjustLabel: UILabel!
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        adjustLabel.text = "adjustLight".localized
        descriptionLabel.text = "discription3".localized
        stackViews.arrangedSubviews.forEach({ item in
            item.layer.cornerRadius = 6
            item.layer.masksToBounds = true
    })
}
    @IBAction func aheadBtnDidTap(_ sender: Any) {
        let entrance = UIStoryboard(name: "Onboarding", bundle: nil).instantiateViewController(identifier: "FourthPageViewController")
        present(entrance, animated: true)
    }
}

