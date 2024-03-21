//
//  Endpoint.swift
//  People
//
//  Created by Roman Vakulenko on 17.03.2024.
//

import Foundation


// MARK: - Endpoint
protocol Endpoint {
    var scheme: String? { get }
    var host: String? { get }
    var path: String { get set }
    var queryItems: [URLQueryItem]? { get set }
    var url: URL? { get }

}

extension Endpoint {
    var url: URL? {
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.path = path
        components.queryItems = queryItems

        return components.url
    }
}

// MARK: - Basic implementation
struct StandardEndpoint: Endpoint {
    var scheme: String? = "https"
    var host: String? = "stoplight.io"
    var path: String = "/mocks/kode-api/trainee-test/331141861/users"
    var queryItems: [URLQueryItem]? = nil
}
