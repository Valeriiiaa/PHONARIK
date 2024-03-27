//
//  FourthPageViewController.swift
//  LedLamp
//
//  Created by Valeriya Chernyak on 07.03.2024.
//

import UIKit
import SwiftUI
import Adapty

class FourthPageViewController: UIViewController {
    @IBOutlet weak var activityIndicatorFourthScreen: UIActivityIndicatorView!
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
    
    private func toRoot() {
        if let viewController = navigationController?.viewControllers.first(where: { $0 is FirstPageViewController }) {
            let main = CustomTabBarView()
            navigationController?.setViewControllers([UIHostingController(rootView: main)], animated: true)
        }
    }
  
    @IBAction func notNowBtnDidTap(_ sender: Any) {
        toRoot()
    }
   
    @IBAction func restoreBtnDidTap(_ sender: Any) {
        activityIndicatorFourthScreen.startAnimating()
        Task {
            do {
                let result = try await Adapty.restorePurchases()

                DispatchQueue.main.async { [unowned self] in
                    showAlert(alertText: "Success", alertMessage: "", okAction: {
                        self.toRoot()
                    })
                }
            } catch {
                DispatchQueue.main.async { [unowned self] in
                    activityIndicatorFourthScreen.stopAnimating()
                    showAlert(alertText: "Error", alertMessage: error.localizedDescription, okAction: { })
                }
            }
        }
    }
    
    @IBAction func privacyBtnDidTap(_ sender: Any) {
        UIApplication.shared.open(URL(string: "https://docs.google.com/document/d/1J7QEWnqOrWbCNo41SZPp5FoBCdx0J8er__fLSTX-w88/edit")!)
    }
   
    @IBAction func termsBtnDidTap(_ sender: Any) {
        UIApplication.shared.open(URL(string: "https://docs.google.com/document/d/1p9pe0SMlWYQReQl1ldBXwcAr2-uBq4ncmcwTwc_T6io/edit")!)
    }
   
    @IBAction func aheadBtnDidTap(_ sender: Any) {
        activityIndicatorFourthScreen.startAnimating()
        Task { [weak self] in
            guard let self else { return }
            do {
                let paywall = try await Adapty.getPaywall(placementId: "main")
                let products = try await Adapty.getPaywallProducts(paywall: paywall)
                guard let product = products.first(where: { $0.vendorProductId == "week.trial.phonarik" }) else {
                    return
                }
                let infp = try await Adapty.makePurchase(product: product)
                UserDefaultsService().set(key: LocalStorageKey.isPremium, value: true)
                showAlert(alertText: "Success", alertMessage: "", okAction: { [unowned self] in
                    self.toRoot()
                })
            } catch {
                DispatchQueue.main.async {
                    self.activityIndicatorFourthScreen.stopAnimating()
                    self.showAlert(alertText: "Error", alertMessage: error.localizedDescription, okAction: {})
                }
            }
        }
    }
}
