//
//  NetworkService.swift
//  CryptoCoins
//
//  Created by Aleksey Yundov on 13.01.2025.
//

import Foundation

protocol NetworkServiceProtocol: AnyObject {
    
    func request<T: Decodable>(_ request: SessionRequest, completion: @escaping (Result<T, Error>) -> Void)
}

final class NetworkService: NetworkServiceProtocol {
    
    func request<T: Decodable>(_ request: SessionRequest, completion: @escaping (Result<T, Error>) -> Void) {
        guard let urlRequest = request.urlRequest else { return completion(.failure(ResponseError.invalidURL)) }
        
        URLSession.shared.dataTask(with: urlRequest) { data, _, error in
            if let error = error {
                completion(.failure(error))
                
                return
            }
            
            do {
                if let data = data {
                    let obj = try JSONDecoder().decode(T.self, from: data)
                    completion(.success(obj))
                }
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
