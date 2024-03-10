//
//  FourthPageViewController.swift
//  LedLamp
//
//  Created by Valeriya Chernyak on 07.03.2024.
//

import UIKit
import SwiftUI

class FourthPageViewController: UIViewController {
   
    @IBOutlet weak var backgroundNextView: UIView!
    @IBOutlet weak var notNowBtn: UIButton!
    @IBOutlet weak var restoreBtn: UIButton!
    @IBOutlet weak var privacyBtn: UIButton!
    @IBOutlet weak var termsBtn: UIButton!
    @IBOutlet weak var tryFreeTrialLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var startUseLabel: UILabel!
    
    private var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundNextView.layer.cornerRadius = 30
        backgroundNextView.layer.masksToBounds = true
        tryFreeTrialLabel.text = "tryFreeTrial".localized
        descriptionLabel.text = "discription4".localized
        startUseLabel.text = "startUse".localized
        notNowBtn.setTitle("notNow".localized, for: .normal)
        restoreBtn.setTitle("restore".localized, for: .normal)
        privacyBtn.setTitle("privacy".localized, for: .normal)
        termsBtn.setTitle("terms".localized, for: .normal)
        
        notNowBtn.titleLabel?.numberOfLines = 0
        notNowBtn.titleLabel?.textAlignment = .center
        restoreBtn.titleLabel?.numberOfLines = 0
        restoreBtn.titleLabel?.textAlignment = .center
        privacyBtn.titleLabel?.numberOfLines = 0
        privacyBtn.titleLabel?.textAlignment = .center
        termsBtn.titleLabel?.numberOfLines = 0
        termsBtn.titleLabel?.textAlignment = .center
        
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
    
    @IBAction func privacyBtnDidTap(_ sender: Any) {
    }
   
    @IBAction func termsBtnDidTap(_ sender: Any) {
    }
    
   
    @IBAction func aheadBtnDidTap(_ sender: Any) {
//        let entrance = UIStoryboard(name: "Onboarding", bundle: nil).instantiateViewController(withIdentifier: "SubscriptionViewController")
//        navigationController?.pushViewController(entrance, animated: true)
    }
    
}
