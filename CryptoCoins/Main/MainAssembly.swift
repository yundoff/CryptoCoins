//
//  MainAssembly.swift
//  Test
//
//  Created by Aleksey Yundov on 13.01.2025.
//

import UIKit

enum MainAssembly {
    static func assembly() -> UIViewController {
        let networkService = NetworkService()
        let router = MainRouter()
        let interactor = MainInteractor(networkService: networkService)
        let presenter = MainPresenter(interactor: interactor, router: router)
        let viewController = MainViewController(presenter: presenter)

        presenter.controller = viewController
        router.controller = viewController
        interactor.presenter = presenter
        
        return viewController
    }
}
