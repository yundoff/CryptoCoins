//
//  MainPresenterProtocol.swift
//  Test
//
//  Created by Aleksey Yundov on 13.01.2025.
//

import Foundation

protocol MainPresenterProtocol: AnyObject {
    func requestCurrencyData()
    func cellTapped(id: String)
}
