//
//  MyCustomTabBarViewModel.swift
//  Example
//
//  Created by Behrad Kazemi on 12/24/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
struct MyCustomTabBarViewModel: BEKTabBarViewModelType {
    let heightRatio: CGFloat = 80
    let containerColor: UIColor = UIColor(red: 34/255, green: 34/255, blue: 34/255, alpha: 0.25)
    let hideTitle: Bool = false
    let animationDuration: CGFloat = 0.3
    let animated: Bool = true
    let shadowColor: UIColor = .clear//UIColor(red: 0.353, green: 0.784, blue: 1, alpha: 1.0)
    let shadowRadius: CGFloat = 0
    let containerBorderWidth: CGFloat = 0
    let containerBorderColor: UIColor = .clear
    let selectedTextColor: UIColor = .black
    let selectedTextFont: UIFont = .systemFont(ofSize: 13)
    let normalTextColor: UIColor = .white
    let normalTextFont: UIFont = .systemFont(ofSize: 11)
    let topCornerRadius: CGFloat = 43
    let bottomCornerRadius: CGFloat = 43
    let containerInsets: UIEdgeInsets = .init(top: 3, left: 56, bottom: 26, right: 56)
    let selectionCircleRadius: CGFloat = 31
    let selectionCircleBorderWidth: CGFloat = 0.0
    let selectionCircleBorderColor: UIColor = .clear
    let selectionCircleBackgroundColor: UIColor = UIColor(red: 231/255, green: 254/255, blue: 85/255, alpha: 1.0)
    let textOffset: CGFloat = 0
    init() {}
}
