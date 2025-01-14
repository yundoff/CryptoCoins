//
//  DetailInteractorProtocol.swift
//  Test
//
//  Created by Aleksey Yundov on 13.01.2025.
//

import Foundation

protocol DetailInteractorInput: AnyObject {
    func request(_ request: Detail.Request)
}

protocol DetailInteractorOutput: AnyObject {
    func present(_ response: Detail.Response)
}
