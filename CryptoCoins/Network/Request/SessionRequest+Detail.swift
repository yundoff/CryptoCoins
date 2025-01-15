//
//  SessionRequest+Main.swift
//  CryptoCoins
//
//  Created by Aleksey Yundov on 13.01.2025.
//

extension SessionRequest {
    
    enum detail {
        
        static func assets(id: String) -> SessionRequest {
            .baseRequest(path: "/v2/assets/\(id)")
        }
    }
}
