//
//  DeatailModel.swift
//  Test
//
//  Created by Aleksey Yundov on 13.01.2025.
//

import UIKit

enum Detail {
    struct Request {
        let id: String
    }
    struct Response {
        let error: String?
        let currencies: [Currency]?

        init(error: String? = nil, currencies: [Currency]? = nil) {
            self.error = error
            self.currencies = currencies
        }

        struct Currency {
            let name: String
            let symbol: String
            let price: String
            let change: String
            let supply: String
            let marketCap: String
            let volume24Hr: String
        }
    }
}
