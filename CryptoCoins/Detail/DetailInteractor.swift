//
//  DetailInteractor.swift
//  Test
//
//  Created by Aleksey Yundov on 13.01.2025.
//

import UIKit

final class DetailInteractor {
    // MARK: - Properties
    private let networkService: NetworkServiceProtocol
    private let id: String
    weak var presenter: DetailInteractorOutput?
    
    // MARK: - Initialization
    init(networkService: NetworkServiceProtocol, id: String) {
        self.networkService = networkService
        self.id = id
    }
    
    // MARK: - Private Methods
    private func fetchCurrencies(completion: @escaping (Result<Detail.Response, Error>) -> Void) {
        networkService.performRequest(endpoint: DetailEndpoint()) { [weak self] (result: Result<DetailDTO?, Error>) in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    guard let data = data else {
                        print("Error: Data is nil")
                        completion(.failure(NSError(domain: "Data is nil", code: 1)))
                        return
                    }
                    
                    let filteredData = data.data.filter { $0.id == self.id }
                    if filteredData.isEmpty {
                        print("Error: No data for id \(self.id)")
                    }
                    
                    let response = self.process(dto: filteredData)
                    completion(.success(response))
                    
                case .failure(let error):
                    print("Network error: \(error.localizedDescription)")
                    completion(.failure(error))
                }
            }
        }
    }
    
    private func process(dto: [DetailDTO.CurrencyData]) -> Detail.Response {
        let currencies: [Detail.Response.Currency] = dto.compactMap { currency in
            guard let name = currency.name, let symbol = currency.symbol else { return nil }
            
            let price = currency.priceUsd ?? "0"
            let changes = currency.changePercent24Hr ?? "0"
            let supply = currency.maxSupply ?? "0"
            let marketCapUsd = currency.marketCapUsd ?? "0"
            let volumeUsd24Hr = currency.volumeUsd24Hr ?? "0"
            
            return Detail.Response.Currency(
                name: name,
                symbol: symbol,
                price: "$\(price)",
                change: "\(changes)%",
                supply: "\(supply)m",
                marketCap: "$\(marketCapUsd)b",
                volume24Hr: "$\(volumeUsd24Hr)b"
            )
        }
        return Detail.Response(currencies: currencies)
    }
}

// MARK: - DetailInteractorInput
extension DetailInteractor: DetailInteractorInput {
    func request(_ request: Detail.Request) {
        fetchCurrencies { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                self.presenter?.present(response)
            case .failure(let error):
                let errorResponse = Detail.Response(error: error.localizedDescription)
                self.presenter?.present(errorResponse)
            }
        }
    }
}
