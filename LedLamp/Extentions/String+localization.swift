//
//  String+localization.swift
//  LedLamp
//
//  Created by Valeriya Chernyak on 26.02.2024.
//

import Foundation

extension String {
    var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }
}
