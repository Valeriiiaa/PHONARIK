//
//  FirstPageViewController.swift
//  LedLamp
//
//  Created by Valeriya Chernyak on 07.03.2024.
//

import UIKit

class FirstPageViewController: UIViewController {

    @IBOutlet weak var stackViews: UIStackView!
    @IBOutlet weak var discriptionLabel: UILabel!
    @IBOutlet weak var welcomeLabel: UILabel!
   
    override func viewDidLoad() {
        super.viewDidLoad()
       
        discriptionLabel.text = "discription1".localized
        welcomeLabel.text = "welcomeLedLamp".localized
        stackViews.arrangedSubviews.forEach({ item in
            item.layer.cornerRadius = 6
            item.layer.masksToBounds = true
        })
    }
    

    @IBAction func buttonAheadDidTap(_ sender: Any) {
        let entrance = UIStoryboard(name: "Onboarding", bundle: nil).instantiateViewController(identifier: "SecondPageViewController")
        present(entrance, animated: true)
    }
    

}
