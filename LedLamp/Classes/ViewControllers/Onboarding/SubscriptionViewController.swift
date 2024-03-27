//
//  SubscriptionViewController.swift
//  LedLamp
//
//  Created by Valeriya Chernyak on 07.03.2024.
//

import UIKit
import Combine
import SwiftUI
import Adapty

enum SubType {
    case weekly
    case monthly
    case yearly
    
    var id: String {
        switch self {
        case .weekly:
            return "week.phonarik"
            
        case .monthly:
            return "month.phonarik"
            
        case .yearly:
            return "year.phonarik"
        }
    }
}

class SubscriptionViewController: UIViewController {
    @IBOutlet weak var activityIndicatorSub: UIActivityIndicatorView!
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
    var cancellabel = Set<AnyCancellable>()
    @Published var selectedSubType = SubType.weekly
    
    weak var selectedTitle: UILabel?
    weak var selectedBackgroundMainView: UIView?
    weak var selectedSubbackgroundView: UIView?
    weak var periodTitle: UILabel?
    weak var perPeriodTitle: UILabel?
    
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
        freeTrialView.layer.cornerRadius = 15
        freeTrialView.layer.masksToBounds = true
        
        yearView.layer.cornerRadius = 24
        yearView.layer.shadowColor = UIColor(red: 231/255, green: 254/255, blue: 85/255, alpha: 1).cgColor
        yearView.layer.shadowOpacity = 1
        yearView.layer.shadowOffset = .zero
        yearView.layer.shadowRadius = 10
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setTimer()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer?.invalidate()
        timer = nil
        
    }
    
    func bind() {
        $selectedSubType.sink(receiveValue: { [unowned self] value in
            switch value {
            case .monthly:
                configureMonthly()
                
            case .weekly:
                configureWeekly()
                
            case .yearly:
                configureYearly()
            }
        }).store(in: &cancellabel)
    }
    
    func configureMonthly() {
        resetPrevious()
        
        selectedTitle = popularLabel
        selectedSubbackgroundView = popularView
        selectedBackgroundMainView = monthView
        periodTitle = monthlyLabel
        perPeriodTitle = monthAmountLabel
        
        activateState()
    }
    
    func configureYearly() {
        resetPrevious()
        
        selectedTitle = bestDialLabel
        selectedSubbackgroundView = bestDealView
        selectedBackgroundMainView = yearView
        periodTitle = yearAmountLabel
        perPeriodTitle = yearlyLabel
        
        activateState()
    }
    
    func configureWeekly() {
        resetPrevious()
        
        selectedTitle = daysFreeTrial
        selectedSubbackgroundView = freeTrialView
        selectedBackgroundMainView = weekView
        periodTitle = weeklyLabel
        perPeriodTitle = weekLabel
        
        activateState()
    }
    
    func activateState() {
        selectedTitle?.textColor = .white
        selectedSubbackgroundView?.backgroundColor = UIColor(hex: 0x151515)
        selectedBackgroundMainView?.backgroundColor = UIColor(hex: 0xE7FE55)
        periodTitle?.textColor = UIColor(hex: 0x151515)
        perPeriodTitle?.textColor = UIColor(hex: 0x151515)
    }
    
    func resetPrevious() {
        selectedTitle?.textColor = UIColor(hex: 0x222222)
        selectedSubbackgroundView?.backgroundColor = .white
        selectedBackgroundMainView?.backgroundColor = UIColor(hex: 0x434343)
        periodTitle?.textColor = .white
        perPeriodTitle?.textColor = .white
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
    
    func goAway() {
        if let viewController = navigationController?.viewControllers.first(where: { $0 is FirstPageViewController }) {
            let main = CustomTabBarView()
            navigationController?.setViewControllers([UIHostingController(rootView: main)], animated: true)
        } else if navigationController?.viewControllers.first is SubscriptionViewController {
            let main = CustomTabBarView()
            navigationController?.setViewControllers([UIHostingController(rootView: main)], animated: true)
        } else {
            dismiss(animated: true)
        }
    }
    
    @IBAction func notNowBtnDidTap(_ sender: Any) {
        goAway()
    }
    
    @IBAction func restoreBtnDidTap(_ sender: Any) {
        activityIndicatorSub.startAnimating()
        Task {
            do {
                let paywall = try await Adapty.getPaywall(placementId: "main")
                let products = try await Adapty.getPaywallProducts(paywall: paywall)
                let profile = try await Adapty.restorePurchases()
                DispatchQueue.main.async { [unowned self] in
                    showAlert(alertText: "Success", alertMessage: "", okAction: { [unowned self] in
                        goAway()
                    })
                }
            } catch {
                DispatchQueue.main.async { [unowned self] in
                    showAlert(alertText: "Error", alertMessage: error.localizedDescription, okAction: { [unowned self] in
                        activityIndicatorSub.stopAnimating()
                    })
                }
            }
        }
    }
   
    @IBAction func termsBtnDidTap(_ sender: Any) {
        UIApplication.shared.open(URL(string: "https://docs.google.com/document/d/1p9pe0SMlWYQReQl1ldBXwcAr2-uBq4ncmcwTwc_T6io/edit")!)
    }
   
    @IBAction func privacyBtnDidTap(_ sender: Any) {
        UIApplication.shared.open(URL(string: "https://docs.google.com/document/d/1J7QEWnqOrWbCNo41SZPp5FoBCdx0J8er__fLSTX-w88/edit")!)
    }
    
    @IBAction func aheadBtnDidTap(_ sender: Any) {
        Task { [unowned self] in
            do {
                let paywall = try await Adapty.getPaywall(placementId: "main")
                let products = try await Adapty.getPaywallProducts(paywall: paywall)
                DispatchQueue.main.async {
                    self.activityIndicatorSub.startAnimating()
                }
                guard let product = products.first(where: { $0.vendorProductId == selectedSubType.id }) else {
                    return
                }
                let result = try await Adapty.makePurchase(product: product)
                UserDefaultsService().set(key: LocalStorageKey.isPremium, value: true)
                DispatchQueue.main.async { [unowned self] in
                    showAlert(alertText: "Success", alertMessage: "", okAction: { [unowned self] in
                        goAway()
                    })
                }
            } catch {
                DispatchQueue.main.async {
                    self.showAlert(alertText: "Error", alertMessage: error.localizedDescription, okAction: {})
                }
            }
        }
    }
   
    @IBAction func monthBtnDidTap(_ sender: Any) {
        selectedSubType = .monthly
    }
    
    @IBAction func weekBtnDidTap(_ sender: Any) {
        selectedSubType = .weekly
    }
  
    @IBAction func yearBtnDidTap(_ sender: Any) {
        selectedSubType = .yearly
    }
}

extension UIViewController {
    //Show a basic alert
    func showAlert(alertText : String, alertMessage : String, okAction: @escaping() -> Void) {
        let alert = UIAlertController(title: alertText, message: alertMessage, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { _ in
            okAction()
        }))
        //Add more actions as you see fit
        self.present(alert, animated: true, completion: nil)
    }
}
