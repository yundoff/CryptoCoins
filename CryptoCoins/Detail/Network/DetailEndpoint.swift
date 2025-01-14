//
//  DetailEndpoint.swift
//  Test
//
//  Created by Aleksey Yundov on 14.01.2025.
//

import Foundation

struct DetailEndpoint: EndpointProtocol {
    var scheme: String {
        "https"
    }

    var host: String {
        "api.coincap.io"
    }

    var method: RequestMethod {
        .GET
    }

    var path: String {
        "\(basePath)assets"
    }

    var parameters: [URLQueryItem]? {
        nil
    }

    private var basePath: String {
        "/v2/"
    }
}