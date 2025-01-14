//
//  MainPresenter.swift
//  Test
//
//  Created by Aleksey Yundov on 13.01.2025.
//

import UIKit

final class MainPresenter: MainPresenterProtocol {
    
    // MARK: - Properties
    weak var controller: MainViewControllerProtocol?
    private let interactor: MainInteractorInput
    private let router: MainRouterInput
    
    // MARK: - Initialization
    init(interactor: MainInteractorInput, router: MainRouterInput) {
        self.interactor = interactor
        self.router = router
    }
    
    // MARK: - MainPresenterProtocol
    func requestCurrencyData() {
        interactor.request()
    }
}

// MARK: - MainInteractorOutput
extension MainPresenter: MainInteractorOutput {
    func cellTapped(id: String) {
        router.routeToDetailScreen(id: id)
    }
    
    func present(_ response: Main.Response) {
        if let models = response.currencies {
            controller?.display(models: models)
        } else if let error = response.error {
            controller?.displayError(message: error)
        }
    }
}
