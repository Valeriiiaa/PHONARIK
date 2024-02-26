//
//  SettingsModel.swift
//  LedLamp
//
//  Created by Valeriya Chernyak on 26.02.2024.
//

import Foundation

enum SettingsModel: CaseIterable {
    case contactUs
    case privacyPolicy
    case temsOfUse
    case share
    case microphoneAcess
    case cameraAcess
    case homeAccess
    
    var title: String {
        switch self {
        case .contactUs:
            return "contactUs".localized
        case .privacyPolicy:
            return "privacyPolicy".localized
        case .temsOfUse:
            return "termsUse".localized
        case .share:
            return "share".localized
        case .microphoneAcess:
            return "microphoneAccess".localized
        case .cameraAcess:
            return "cameraAccess".localized
        case .homeAccess:
            return "homeAccess".localized
        }
    }
    
    var image: String {
        switch self {
        case .contactUs:
            return "contactUs"
        case .privacyPolicy:
            return "privacyPolicy"
        case .temsOfUse:
            return "termsOfUse"
        case .share:
            return "share"
        case .microphoneAcess:
            return "microphone"
        case .cameraAcess:
            return "cameraAccess"
        case .homeAccess:
            return "homeAccess"
        }
    }
}
