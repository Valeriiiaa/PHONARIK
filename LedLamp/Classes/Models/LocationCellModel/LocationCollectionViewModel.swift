//
//  LocationCollectionViewModel.swift
//  LedLamp
//
//  Created by Valeriya Chernyak on 29.02.2024.
//

import Foundation

enum LocationCollectionViewModel: CaseIterable {
    case livingroom
    case bedroom
    case kitchen
    case bathroom
    
    var titel: String {
        switch self {
        case .livingroom:
            return "livingRoom".localized
        case .bedroom:
            return "bedroom".localized
        case .kitchen:
            return "kitchen".localized
        case .bathroom:
            return "bathroom".localized
        }
    }
}
