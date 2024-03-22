//
//  NetworkServiceErrors.swift
//  People
//
//  Created by Roman Vakulenko on 17.03.2024.
//

import Foundation

enum NetworkServiceErrors: Error, CustomStringConvertible {
    case networkRouterError(error: RouterError)
    case mapperError(error: MapperError)

    var description: String {
        switch self {
        case .networkRouterError(let error):
            return error.description
        case .mapperError(let error):
            return error.description
        }
    }
}
