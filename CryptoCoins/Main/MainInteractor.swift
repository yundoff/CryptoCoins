//
//  MainInteractor.swift
//  Test
//
//  Created by Aleksey Yundov on 13.01.2025.
//

import UIKit

final class MainInteractor {
    // MARK: - Properties
    private let networkService: NetworkServiceProtocol
    weak var presenter: MainInteractorOutput?
    
    // MARK: - Initialization
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    // MARK: - Private Methods
    private func fetchCurrencies(completion: @escaping (Result<Main.Response, Error>) -> Void) {
        networkService.performRequest(endpoint: MainEndpoint()) { [weak self] (result: Result<MainDTO?, Error>) in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    if let data = data {
                        let response = self.process(dto: data)
                        completion(.success(response))
                    } else {
                        completion(.failure(NSError(domain: "Data is nil", code: 1)))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
    
    private func process(dto: MainDTO) -> Main.Response {
        let currencies: [Main.Response.Currency] = dto.data.compactMap { currency in
            guard
                let id = currency.id,
                let name = currency.name,
                let symbol = currency.symbol,
                let price = currency.priceUsd,
                let changes = currency.changePercent24Hr
            else { return nil }
            
            return Main.Response.Currency(
                id: id,
                name: name,
                symbol: symbol,
                price: "$\(price)",
                change: "\(changes)%"
            )
        }
        
        return Main.Response(currencies: currencies)
    }
}

// MARK: - MainInteractorInput
extension MainInteractor: MainInteractorInput {
    func request() {
        fetchCurrencies { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                self.presenter?.present(response)
            case .failure(let error):
                let errorResponse = Main.Response(error: error.localizedDescription)
                self.presenter?.present(errorResponse)
            }
        }
    }
}
