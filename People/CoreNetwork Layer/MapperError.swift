//
//  MapperError.swift
//  People
//
//  Created by Roman Vakulenko on 17.03.2024.
//

import Foundation

enum MapperError: Error, CustomStringConvertible {
    case failAtMapping

    var description: String {
        switch self {
        case .failAtMapping:
            return "Не могу обновить данные. Что-то пошло не так"
        }
    }
}
