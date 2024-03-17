//
//  RouterError.swift
//  People
//
//  Created by Roman Vakulenko on 10.03.2024.
//

import Foundation


enum RouterError: Error, CustomStringConvertible {
    case badInternetConnection
    case badStatusCode

    var description: String {
        switch self {
        case .badInternetConnection:
            return "Не могу обновить данные. Проверь соединение с интернетом"
        case .badStatusCode:
            return "Не могу обновить данные. Что-то пошло не так"
        }
    }
}
