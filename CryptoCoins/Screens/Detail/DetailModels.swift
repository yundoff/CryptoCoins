//
//  DetailModels.swift
//  CryptoCoins
//
//  Created by Aleksey Yundov on 13.01.2025.
//

import UIKit

enum Detail {

    struct InitialData {

        let backButtonImage: UIImage
        let separatorImage: UIImage
        let backgroundImage: UIImage
    }

    struct Currency {

        let id: String
        let name: String
        let price: String
        let change: String
        let marketCap: String
        let supply: String
        let volume: String
    }

    struct Error {

        let title: String
        let message: String
        let buttonTitle: String
    }
}
