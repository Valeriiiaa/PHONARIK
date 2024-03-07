//
//  SubscriptionViewController.swift
//  LedLamp
//
//  Created by Valeriya Chernyak on 07.03.2024.
//

import UIKit

class SubscriptionViewController: UIViewController {
   
    @IBOutlet weak var subscriptionStack: UIStackView!
    @IBOutlet weak var yearView: UIView!
    @IBOutlet weak var weekView: UIView!
    @IBOutlet weak var monthView: UIView!
    @IBOutlet weak var notNowButton: UIButton!
    @IBOutlet weak var restoreButton: UIButton!
    @IBOutlet weak var privacyButton: UIButton!
    @IBOutlet weak var termButton: UIButton!
    @IBOutlet weak var tryFreeTrialLabel: UILabel!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var unrestrictedLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    @IBAction func notNowBtnDidTap(_ sender: Any) {
    }
    
    @IBAction func restoreBtnDidTap(_ sender: Any) {
    }
   
    @IBAction func termsBtnDidTap(_ sender: Any) {
    }
   
    @IBAction func privacyBtnDidTap(_ sender: Any) {
    }
    
    @IBAction func aheadBtnDidTap(_ sender: Any) {
    }
   
    @IBAction func monthBtnDidTap(_ sender: Any) {
    }
    
    @IBAction func weekBtnDidTap(_ sender: Any) {
    }
  
    @IBAction func yearBtnDidTap(_ sender: Any) {
    }
}
