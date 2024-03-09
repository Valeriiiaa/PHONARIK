//
//  SubscriptionViewController.swift
//  LedLamp
//
//  Created by Valeriya Chernyak on 07.03.2024.
//

import UIKit
import SwiftUI

class SubscriptionViewController: UIViewController {
    @IBOutlet weak var yearButton: UIButton!
    
    @IBOutlet weak var backgorund85OffView: UIView!
    @IBOutlet weak var perWeekThirdLabel: UILabel!
    @IBOutlet weak var yearlyLabel: UILabel!
    @IBOutlet weak var bestDialLabel: UILabel!
    @IBOutlet weak var yearAmountLabel: UILabel!
    @IBOutlet weak var monthAmountLabel: UILabel!
    @IBOutlet weak var weekLabel: UILabel!
    @IBOutlet weak var daysFreeTrial: UILabel!
    @IBOutlet weak var perWeekSecondLabel: UILabel!
    @IBOutlet weak var weeklyLabel: UILabel!
    @IBOutlet weak var perWeekFirstLabel: UILabel!
    @IBOutlet weak var monthlyLabel: UILabel!
    @IBOutlet weak var popularLabel: UILabel!
    @IBOutlet weak var bestDealView: UIView!
    @IBOutlet weak var freeTrialView: UIView!
    @IBOutlet weak var popularView: UIView!
    @IBOutlet weak var backgroundNextView: UIView!
    @IBOutlet weak var subscriptionStack: UIStackView!
    @IBOutlet weak var yearView: UIView!
    @IBOutlet weak var weekView: UIView!
    @IBOutlet weak var monthView: UIView!
    @IBOutlet weak var notNowButton: UIButton!
    @IBOutlet weak var restoreButton: UIButton!
    @IBOutlet weak var privacyButton: UIButton!
    @IBOutlet weak var termButton: UIButton!
    @IBOutlet weak var tryFreeTrialLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var unrestrictedLabel: UILabel!
    
    private var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundNextView.layer.cornerRadius = 30
        backgroundNextView.layer.masksToBounds = true
        unrestrictedLabel.text = "unrestrictedLed".localized
        descriptionLabel.text = "choosingOptimal".localized
        tryFreeTrialLabel.text = "startTrialThen".localized
        termButton.setTitle("terms".localized, for: .normal)
        privacyButton.setTitle("privacy".localized, for: .normal)
        restoreButton.setTitle("restore".localized, for: .normal)
        notNowButton.setTitle("notNow".localized, for: .normal)
        popularLabel.text = "popular".localized
        monthlyLabel.text = "monthly".localized
        daysFreeTrial.text = "3dayFree".localized
        perWeekFirstLabel.text = "perWeek4".localized
        monthAmountLabel.text = "19month".localized
        perWeekSecondLabel.text = "perWeek5".localized
        bestDialLabel.text = "bestDeal".localized
        yearlyLabel.text = "yearly".localized
        perWeekThirdLabel.text = "perWeek0,7".localized
        yearAmountLabel.text = "39year".localized
        weekLabel.text = "5week".localized
        weeklyLabel.text = "weekly".localized
        backgorund85OffView.layer.cornerRadius = 9
        backgorund85OffView.layer.borderWidth = 1.85
        backgorund85OffView.layer.borderColor = UIColor.black.cgColor

        
        [ weekView, monthView].forEach({ item in
            item?.layer.cornerRadius = 24
            item?.layer.masksToBounds = true
        })
        
        notNowButton.titleLabel?.numberOfLines = 0
        notNowButton.titleLabel?.textAlignment = .center
        restoreButton.titleLabel?.numberOfLines = 0
        restoreButton.titleLabel?.textAlignment = .center
        privacyButton.titleLabel?.numberOfLines = 0
        privacyButton.titleLabel?.textAlignment = .center
        termButton.titleLabel?.numberOfLines = 0
        termButton.titleLabel?.textAlignment = .center
        
        bestDealView.layer.cornerRadius = 15
        bestDealView.layer.masksToBounds = true
        popularView.layer.cornerRadius = 15
        popularView.layer.masksToBounds = true
        freeTrialView.layer.cornerRadius = 25
        freeTrialView.layer.masksToBounds = true
        
//        yearView.layer.cornerRadius = 24
//        yearView.layer.shadowColor = UIColor(red: 231/255, green: 254/255, blue: 85/255, alpha: 1).cgColor
//        yearView.layer.shadowOpacity = 0.5
//        yearView.layer.shadowOffset = CGSize(width: 2, height: 0)
//        yearView.layer.shadowRadius = 4
        

        yearView.layer.cornerRadius = 24
        yearView.layer.shadowColor = UIColor(red: 231/255, green: 254/255, blue: 85/255, alpha: 1).cgColor
        yearView.layer.shadowOpacity = 1
        yearView.layer.shadowOffset = .zero
        yearView.layer.shadowRadius = 10
        
//        yearView.layer.masksToBounds = false
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setTimer()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer?.invalidate()
        timer = nil
        
    }
    
    private func setTimer() {
        if timer != nil {
            return
        }
        fireTimer()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(fireTimer), userInfo: nil, repeats: true)
        RunLoop.main.add(timer!, forMode: .common)
    }
    
    @objc private func fireTimer() {
        self.backgroundNextView.btnAnimation()
    }
    
    @IBAction func notNowBtnDidTap(_ sender: Any) {
        if let viewController = navigationController?.viewControllers.first(where: { $0 is FirstPageViewController }) {
            let main = CustomTabBarView()
            navigationController?.setViewControllers([UIHostingController(rootView: main)], animated: true)
        }
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
