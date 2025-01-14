//
//  MainDTO.swift
//  Test
//
//  Created by Aleksey Yundov on 13.01.2025.
//

import Foundation

struct MainDTO: Decodable {
    let data: [CurrencyData]
    
    struct CurrencyData: Decodable {
        let id: String?
        let name: String?
        let symbol: String?
        let priceUsd:  String?
        let changePercent24Hr: String?
    }
}