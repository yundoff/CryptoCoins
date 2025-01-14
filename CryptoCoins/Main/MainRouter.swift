//
//  MainRouter.swift
//  Test
//
//  Created by Aleksey Yundov on 13.01.2025.
//

import UIKit

final class MainRouter {
    // MARK: - Properties
    weak var controller: UIViewController?
}

// MARK: - MainRouterInput
extension MainRouter: MainRouterInput {
    func routeToDetailScreen(id: String) {
        let screen = DetailAssembly.assembly(id: id)
        controller?.navigationController?.pushViewController(screen, animated: true)
    }
}
