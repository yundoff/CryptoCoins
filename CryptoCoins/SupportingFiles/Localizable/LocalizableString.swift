//
//  LocalizableString.swift
//  CryptoCoins
//
//  Created by Aleksey Yundov on 14.01.2025.
//

import Foundation

enum Localizable {
    
    enum Main {
        
        static let title = "main_screen_title".localizedString
        static let searchPlaceholder = "main_screen_search_placeholder".localizedString
    }
    
    enum Detail {
        
        static let marketCapTitle = "detail_screen_market_cap_title".localizedString
        static let supplyTitle = "detail_screen_supply_title".localizedString
        static let volumeTitle = "detail_screen_volume_title".localizedString
    }
}

// MARK: - Helpers

private extension String {
    
    var localizedString: String { .init(NSLocalizedString(self, comment: "")) }
}
