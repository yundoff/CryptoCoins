//
//  DetailPresenter.swift
//  Test
//
//  Created by Aleksey Yundov on 13.01.2025.
//

import UIKit

final class DetailPresenter: DetailPresenterProtocol {
    
    // MARK: - Properties
    weak var controller: DetailViewControllerProtocol?
    
    private let id: String
    private let interactor: DetailInteractorInput

    // MARK: - Initialization
    init(id: String, interactor: DetailInteractorInput) {
        self.id = id
        self.interactor = interactor
    }
    
    // MARK: - DetailPresenterProtocol
    func requestDetailCurrencyData() {
        interactor.request(Detail.Request(id: id))
    }
}

// MARK: - DetailInteractorOutput
extension DetailPresenter: DetailInteractorOutput {
    func present(_ response: Detail.Response) {
        if let models = response.currencies {
            controller?.display(models: models)
        } else if let error = response.error {
            controller?.displayError(message: error)
        }
    }
}
