//
//  SessionRequest+Main.swift
//  CryptoCoins
//
//  Created by Aleksey Yundov on 13.01.2025.
//

extension SessionRequest {
    
    enum main {
        
        static func assets() -> SessionRequest {
            .baseRequest(path: "/v2/assets")
        }
    }
}
