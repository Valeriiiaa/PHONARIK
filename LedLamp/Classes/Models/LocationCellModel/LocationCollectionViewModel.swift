//
//  LocationCollectionViewModel.swift
//  LedLamp
//
//  Created by Valeriya Chernyak on 29.02.2024.
//

import Foundation
import SwiftUI

protocol SelectableRoom {
    var titel: String { get }
}

enum LocationCollectionViewModel: CaseIterable, SelectableRoom {
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
    
    var image: ImageResource {
        switch self {
        case .livingroom:
            ImageResource.livingRoom
            
        case .bedroom:
            ImageResource.bedroom
            
        case .kitchen:
            ImageResource.kitchen
            
        case .bathroom:
            ImageResource.bathroom
        }
    }
}
