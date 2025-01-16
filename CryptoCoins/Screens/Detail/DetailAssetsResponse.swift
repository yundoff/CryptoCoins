//
//  DetailAssetsResponse.swift
//  CryptoCoins
//
//  Created by Aleksey Yundov on 13.01.2025.
//

import Foundation

struct DetailAssetsResponse: Decodable {
    
    let data: CurrencyData
    
    struct CurrencyData: Decodable {
        
        let id: String?
        let name: String?
        let priceUsd:  String?
        let changePercent24Hr: String?
        let marketCapUsd: String?
        let supply: String?
        let volumeUsd24Hr: String?
    }
}
