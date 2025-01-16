//
//  DetailPresenter.swift
//  CryptoCoins
//
//  Created by Aleksey Yundov on 13.01.2025.
//

import UIKit

protocol DetailPresenterProtocol: AnyObject {
    
    func requestInitialData()
    func requestAssets()
}

final class DetailPresenter {
    
    // MARK: - Properties

    private let networkService: NetworkServiceProtocol
    weak var controller: DetailViewControllerProtocol?
    
    private let id: String
    private let name: String
    private var currencyData: Detail.Currency?
    
    // MARK: - Init
    
    init(networkService: NetworkServiceProtocol, id: String, name: String) {
        self.networkService = networkService
        self.id = id
        self.name = name
    }
    
    // MARK: - Private Methods
    
    private func process(response: DetailAssetsResponse) -> Detail.Currency? {
        let currency = response.data
        guard
            let id = currency.id,
            let name = currency.name,
            let price = currency.priceUsd,
            let changes = currency.changePercent24Hr,
            let marketCap = currency.marketCapUsd,
            let supply = currency.supply,
            let volume = currency.volumeUsd24Hr
        else { return nil }
        
        return Detail.Currency(
            id: id,
            name: name,
            price: price,
            change: changes,
            marketCap: marketCap,
            supply: supply,
            volume: volume
        )
    }
    
    private func configure(model: Detail.Currency) -> Detail.Currency {
        return Detail.Currency(
            id: model.id,
            name: model.name,
            price: formatValue(model.price, prefix: "$", suffix: ""),
            change: formatValue(model.change, prefix: "", suffix: "%"),
            marketCap: formatValue(model.marketCap, prefix: "$", suffix: ""),
            supply: formatValue(model.supply, prefix: "", suffix: ""),
            volume: formatValue(model.volume, prefix: "$", suffix: "")
        )
    }
}

// MARK: - DetailPresenterProtocol

extension DetailPresenter: DetailPresenterProtocol {
    
    func requestInitialData() {
        let data = Detail.InitialData(
            backButtonImage: .init(resource: .back),
            separatorImage: .init(resource: .separator),
            backgroundImage: .init(resource: .background)
        )
        controller?.display(data)
        controller?.setupCustomNavigationBar(name: name)
    }
    
    func requestAssets() {
        fetchCurrencies { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let currency):
                self.currencyData = self.configure(model: currency)
                if let currencyData = self.currencyData {
                    self.controller?.display([currencyData])
                }
            case .failure(let error):
                let error = Detail.Error(
                    title: "Error",
                    message: error.localizedDescription,
                    buttonTitle: "OK"
                )
                self.controller?.display(error)
            }
        }
    }
    
    private func fetchCurrencies(completion: @escaping (Result<Detail.Currency, Error>) -> Void) {
        networkService.request(.detail.assets(id: id)) { [weak self] (result: Result<DetailAssetsResponse?, Error>) in
            guard let self else { return }
            
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    if let data = data, let currency = self.process(response: data) {
                        completion(.success(currency))
                    } else {
                        completion(.failure(NSError(domain: "Data is nil", code: 1)))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
}
