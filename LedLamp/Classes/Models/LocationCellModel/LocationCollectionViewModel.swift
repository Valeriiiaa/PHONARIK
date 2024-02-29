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
        return "Living room"
        case .bedroom:
            return "Bedroom"
        case .kitchen:
            return "Kitchen"
        case .bathroom:
            return "Bathroom"
        }
    }
}
