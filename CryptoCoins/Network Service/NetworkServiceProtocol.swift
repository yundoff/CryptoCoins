//
//  NetworkServiceProtocol.swift
//  Test
//
//  Created by Aleksey Yundov on 13.01.2025.
//

protocol NetworkServiceProtocol: AnyObject {
    func performRequest<T: Decodable>(endpoint: EndpointProtocol, completion: @escaping (Result<T, Error>) -> Void)
}
