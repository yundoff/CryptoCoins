//
//  DetailAssembly.swift
//  CryptoCoins
//
//  Created by Aleksey Yundov on 13.01.2025.
//

import UIKit

enum DetailAssembly {
    
    static func assembly(id: String, name: String) -> UIViewController {
        let networkService = NetworkService()
        let presenter = DetailPresenter(networkService: networkService, id: id, name: name)
        let viewController = DetailViewController(presenter: presenter)
        
        presenter.controller = viewController
        
        return viewController
    }
}
