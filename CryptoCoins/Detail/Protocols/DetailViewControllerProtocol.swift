//
//  DetailViewControllerProtocol.swift
//  Test
//
//  Created by Aleksey Yundov on 13.01.2025.
//

import Foundation

protocol DetailViewControllerProtocol: AnyObject {
    func display(models: [Detail.Response.Currency])
    func displayError(message: String)
}
