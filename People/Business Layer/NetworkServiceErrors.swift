//
//  NetworkServiceErrors.swift
//  People
//
//  Created by Roman Vakulenko on 17.03.2024.
//

import Foundation
//Ошибка сетевого соединения (timeout, HTTP-статус 5xx и т.п.). В этом случае в уведомлении текст "Не могу обновить данные. Проверь соединение с интернетом"
//Ошибка от сервера (HTTP-статус 4xx) или ошибка при парсинге данных. В этом случае в уведомлении текст "Не могу обновить данные. Что-то пошло не так".
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
