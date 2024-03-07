//
//  Animation Button.swift
//  LedLamp
//
//  Created by Valeriya Chernyak on 07.03.2024.
//

import UIKit

extension UIView {
    
    func btnAnimation() {
        UIViewPropertyAnimator(duration: 0.5, curve: .easeInOut) {
            self.transform = CGAffineTransform(scaleX: 1.06, y: 1.06)
        }.startAnimation()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            UIViewPropertyAnimator(duration: 0.5, curve: .easeInOut) {
            self.transform = CGAffineTransform.identity
            }.startAnimation()
        }
    }
}
