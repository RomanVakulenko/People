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
            ///Ошибка сетевого соединения (timeout, HTTP-статус 5xx и т.п.).
        case .badInternetConnection:
            return """
                    Не могу обновить данные.
                    Проверь соединение с интернетом
                    """
            ///Ошибка от сервера (HTTP-статус 4xx) или ошибка при парсинге данных.
        case .badStatusCode:
            return """
                    Не могу обновить данные.
                    Что-то пошло не так
                    """
        }
    }
}


