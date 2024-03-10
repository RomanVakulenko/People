//
//  DataMapper.swift
//  People
//
//  Created by Roman Vakulenko on 10.03.2024.
//

import Foundation

enum DataMapperError: Error, CustomStringConvertible {
    case failAtMapping(reason: String)
//Ошибка от сервера (HTTP-статус 4xx) или ошибка при парсинге данных. В этом случае в уведомлении текст "Не могу обновить данные. Что-то пошло не так".
    var description: String {
        switch self {
        case .failAtMapping:
            return "Не могу обновить данные. Что-то пошло не так"
        }
    }
}

protocol DataMapperProtocol {
    func encode<T: Encodable>(from someStruct: T) throws -> Data //тут просто модель
    func decode<T: Decodable>(from data: Data, to someStruct: T.Type) throws -> T

}

// MARK: - DataMapper
final class DataMapper {

    private lazy var encoder: JSONEncoder = {
        let encoder = JSONEncoder()
        return encoder
    }()

    private lazy var decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        return decoder
    }()

}


// MARK: - DataMapperProtocol
extension DataMapper: DataMapperProtocol {
    func encode<T: Encodable>(from someStruct: T) throws -> Data {
        do {
            let modelEncodedToData = try self.encoder.encode(someStruct)
            return modelEncodedToData
        } catch {
            throw error
        }
    }

    func decode<T: Decodable>(from data: Data, to someStruct: T.Type) throws -> T {
        do {
            let decodedModel = try self.decoder.decode(someStruct, from: data)
            return decodedModel
        } catch let error as DecodingError {
            let errorLocation = "in File: \(#file), at Line: \(#line), Column: \(#column)"
            throw DataMapperError.failAtMapping(reason: "\(error), \(errorLocation)")
        } catch {
            print("Unknown error have been caught in File: \(#file), at Line: \(#line), Column: \(#column)")
            throw error
        }
    }

}
