//
//  RouterError.swift
//  People
//
//  Created by Roman Vakulenko on 10.03.2024.
//

import Foundation

//Ошибка сетевого соединения (timeout, HTTP-статус 5xx и т.п.). В этом случае в уведомлении текст "Не могу обновить данные. Проверь соединение с интернетом"
enum RouterError: Error, CustomStringConvertible {
    case noInternetConnection
    case serverErrorWith(_ statusCode: Int)

    var description: String {
        switch self {
        case .noInternetConnection:
            return "Нет соединения с интернетом"
        case .serverErrorWith(let statusCode):
            print(statusCode)
            return "Bad status code - \(statusCode)"
        }
    }
}
