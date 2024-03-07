//
//  FourthPageViewController.swift
//  LedLamp
//
//  Created by Valeriya Chernyak on 07.03.2024.
//

import UIKit

class FourthPageViewController: UIViewController {
    @IBOutlet weak var notNowBtn: UIButton!
    @IBOutlet weak var restoreBtn: UIButton!
    @IBOutlet weak var privacyBtn: UIButton!
    @IBOutlet weak var termsBtn: UIButton!
    @IBOutlet weak var tryFreeTrialLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var startUseLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tryFreeTrialLabel.text = "tryFreeTrial".localized
        descriptionLabel.text = "discription4".localized
        startUseLabel.text = "startUse".localized
        notNowBtn.setTitle("notNow".localized, for: .normal)
        restoreBtn.setTitle("restore".localized, for: .normal)
        privacyBtn.setTitle("privacy".localized, for: .normal)
        termsBtn.setTitle("terms".localized, for: .normal)
        
    }
  
    @IBAction func notNowBtnDidTap(_ sender: Any) {
    }
   
    @IBAction func restoreBtnDidTap(_ sender: Any) {
    }
    
    @IBAction func privacyBtnDidTap(_ sender: Any) {
    }
   
    @IBAction func termsBtnDidTap(_ sender: Any) {
    }
    
   
    @IBAction func aheadBtnDidTap(_ sender: Any) {
    }
    
}
