//
//  DetailAssembly.swift
//  Test
//
//  Created by Aleksey Yundov on 13.01.2025.
//

import UIKit

enum DetailAssembly {
    static func assembly(id: String) -> UIViewController {
        let networkService = NetworkService()
        let interactor = DetailInteractor(networkService: networkService, id: id)
        let presenter = DetailPresenter(id: id, interactor: interactor)
        let controller = DetailViewController(presenter: presenter)

        presenter.controller = controller
        interactor.presenter = presenter

        return controller
    }
}
