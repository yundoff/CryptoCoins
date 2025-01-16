//
//  MainPresenter.swift
//  CryptoCoins
//
//  Created by Aleksey Yundov on 13.01.2025.
//

import UIKit

protocol MainPresenterProtocol: AnyObject {
    
    func requestInitialData()
    func requestAssets()
    
    func search(text: String)
}

final class MainPresenter {
    
    // MARK: - Properties
    
    private let networkService: NetworkServiceProtocol
    weak var controller: MainViewControllerProtocol?
    
    private var currencyData: [Main.Currency] = []
    
    // MARK: - Init
    
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    // MARK: - Private Methods
    
    private func fetchCurrencies(completion: @escaping (Result<[Main.Currency], Error>) -> Void) {
        networkService.request(.main.assets()) { [weak self] (result: Result<MainAssetsResponse?, Error>) in
            guard let self else { return }
            
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    if let data = data {
                        completion(.success(self.process(response: data)))
                    } else {
                        completion(.failure(NSError(domain: "Data is nil", code: 1)))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
    
    private func process(response: MainAssetsResponse) -> [Main.Currency] {
        response.data.compactMap { currency in
            guard
                let id = currency.id,
                let name = currency.name,
                let symbol = currency.symbol,
                let price = currency.priceUsd,
                let changes = currency.changePercent24Hr
            else { return nil }
            
            return .init(
                id: id,
                name: name,
                symbol: symbol,
                price: "$\(price)",
                change: "\(changes)%"
            )
        }
    }
}

// MARK: - MainPresenterProtocol

extension MainPresenter: MainPresenterProtocol {
    
    func requestInitialData() {
        let data = Main.InitialData(
            title: Localizable.Main.title,
            searchButtonImage: .init(resource: .search),
            searchBarPlaceholder: Localizable.Main.searchPlaceholder,
            backgroundImage: .init(resource: .background)
        )
        
        controller?.display(data)
    }
    
    func requestAssets() {
        fetchCurrencies { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let currencies):
                let configuredCurrencies = currencies.map { self.configure(model: $0) }
                currencyData = configuredCurrencies
                controller?.display(configuredCurrencies)
            case .failure(let error):
                let error = Main.Error(
                    title: "Error",
                    message: error.localizedDescription,
                    buttonTitle: "OK"
                )
                controller?.display(error)
            }
        }
    }
    
    func search(text: String) {
        guard !text.isEmpty else {
            controller?.display(currencyData)
            
            return
        }
        
        let searchedText = text.lowercased()
        let currencies = currencyData.filter {
            $0.id.lowercased().contains(searchedText) ||
            $0.symbol.lowercased().contains(searchedText)
        }
        
        controller?.display(currencies)
    }
    
    private func configure(model: Main.Currency) -> Main.Currency {
        return Main.Currency(
            id: model.id,
            name: model.name,
            symbol: model.symbol,
            price: formatValue(model.price, prefix: "$", suffix: ""),
            change: formatValue(model.change, prefix: "", suffix: "%")
        )
    }
}
