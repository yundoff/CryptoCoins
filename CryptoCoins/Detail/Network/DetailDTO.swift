//
//  DetailDTO.swift
//  Test
//
//  Created by Aleksey Yundov on 14.01.2025.
//

import Foundation

struct DetailDTO: Decodable {
    let data: [CurrencyData]
    
    struct CurrencyData: Decodable {
        let id: String?
        let name: String?
        let symbol: String?
        let priceUsd:  String?
        let changePercent24Hr: String?
        let maxSupply: String?
        let marketCapUsd: String?
        let volumeUsd24Hr: String?
    }
}
