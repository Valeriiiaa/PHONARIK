//
//  SubscriptionViewController.swift
//  LedLamp
//
//  Created by Valeriya Chernyak on 07.03.2024.
//

import UIKit

class SubscriptionViewController: UIViewController {
   
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
        
        [yearView, weekView, monthView].forEach({ item in
            item?.layer.cornerRadius = 24
            item?.layer.masksToBounds = true
        })
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
        if let viewController = navigationController?.viewControllers.first(where: { $0 is MainViewController }) {
            navigationController?.popToViewController(viewController, animated: true)
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
