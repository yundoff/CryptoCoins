//
//  MainViewControllerProtocol.swift
//  Test
//
//  Created by Aleksey Yundov on 13.01.2025.
//

import Foundation

protocol MainViewControllerProtocol: AnyObject {
    func display(models: [Main.Response.Currency])
    func displayError(message: String)
}
