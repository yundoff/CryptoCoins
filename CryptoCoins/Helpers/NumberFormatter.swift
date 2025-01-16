//
//  Double+Extension.swift
//  CryptoCoins
//
//  Created by Aleksey Yundov on 14.01.2025.
//

import Foundation

func formatValue(_ value: String, prefix: String = "", suffix: String = "") -> String {
    let cleanedValue = value
        .replacingOccurrences(of: "$", with: "")
        .replacingOccurrences(of: "%", with: "")
        .replacingOccurrences(of: ",", with: "")
        .replacingOccurrences(of: "-", with: "")
    
    guard let doubleValue = Double(cleanedValue) else { return value }
    
    let signPrefix = value.contains("-") || doubleValue < 0 ? "- " : (prefix.isEmpty ? "+ " : "\(prefix) ")
    let absoluteValue = abs(doubleValue)
    
    return "\(signPrefix)\(formatLargeNumber(absoluteValue))\(suffix)"
}

func formatLargeNumber(_ number: Double) -> String {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    formatter.groupingSeparator = " "
    formatter.minimumFractionDigits = 2
    formatter.maximumFractionDigits = 2
    
    let absNumber = abs(number)
    switch absNumber {
    case 1_000_000_000_000...:
        return "\(formatter.string(from: NSNumber(value: absNumber / 1_000_000_000_000)) ?? "0")t"
    case 1_000_000_000...:
        return "\(formatter.string(from: NSNumber(value: absNumber / 1_000_000_000)) ?? "0")b"
    case 1_000_000...:
        return "\(formatter.string(from: NSNumber(value: absNumber / 1_000_000)) ?? "0")m"
    default:
        return formatter.string(from: NSNumber(value: absNumber)) ?? "0"
    }
}
