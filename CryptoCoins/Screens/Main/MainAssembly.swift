//
//  MainAssembly.swift
//  CryptoCoins
//
//  Created by Aleksey Yundov on 13.01.2025.
//

import UIKit

enum MainAssembly {
    
    static func assembly() -> UIViewController {
        let networkService = NetworkService()
        let presenter = MainPresenter(networkService: networkService)
        let viewController = MainViewController(presenter: presenter)
        
        presenter.controller = viewController
        
        return viewController
    }
}
