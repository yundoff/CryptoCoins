//
//  MainModels.swift
//  CryptoCoins
//
//  Created by Aleksey Yundov on 13.01.2025.
//

import UIKit

enum Main {
    
    struct InitialData {
        
        let title: String
        let searchButtonImage: UIImage
        let searchBarPlaceholder: String
        let backgroundImage: UIImage
    }
    
    struct Currency {
        
        let id: String
        let name: String
        let symbol: String
        let price: String
        let change: String
    }
    
    struct Error {
        
        let title: String
        let message: String
        let buttonTitle: String
    }
}
