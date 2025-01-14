//
//  MainInteracrorProtocol.swift
//  Test
//
//  Created by Aleksey Yundov on 13.01.2025.
//

import Foundation

protocol MainInteractorInput: AnyObject {
    func request()
}

protocol MainInteractorOutput: AnyObject {
    func present(_ response: Main.Response)
}
