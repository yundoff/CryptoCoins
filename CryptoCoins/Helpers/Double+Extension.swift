//
//  Double+Extension.swift
//  CryptoCoins
//
//  Created by Aleksey Yundov on 14.01.2025.
//

import Foundation

extension Double {
    func formattedWithSuffix() -> String {
        let sign = (self < 0) ? "-" : ""
        let num = abs(self)

        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = " "
        formatter.decimalSeparator = "."
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        
        switch num {
        case 1_000_000_000_000...:
            return "\(sign)\(formatter.string(for: num / 1_000_000_000_000) ?? "\(num / 1_000_000_000_000)")t"
        case 1_000_000_000...:
            return "\(sign)\(formatter.string(for: num / 1_000_000_000) ?? "\(num / 1_000_000_000)")b"
        case 1_000_000...:
            return "\(sign)\(formatter.string(for: num / 1_000_000) ?? "\(num / 1_000_000)")m"
        default:
            return "\(sign)\(formatter.string(for: num) ?? "\(num)")"
        }
    }
}
