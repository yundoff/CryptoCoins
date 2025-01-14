//
//  MainModel.swift
//  Test
//
//  Created by Aleksey Yundov on 13.01.2025.
//

import UIKit

enum Main {
    struct Response {
        let error: String?
        let currencies: [Currency]?

        init(error: String? = nil, currencies: [Currency]? = nil) {
            self.error = error
            self.currencies = currencies
        }

        struct Currency {
            let id: String
            let name: String
            let symbol: String
            let price: String
            let change: String
        }
    }
}
