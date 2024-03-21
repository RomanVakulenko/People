//
//  DataMapper.swift
//  People
//
//  Created by Roman Vakulenko on 10.03.2024.
//

import Foundation

typealias MapperCompletion<T: Decodable> = (Result<T, MapperError>) -> Void

protocol DataMapperProtocol {
   func decode<T: Decodable> (from data: Data,
                              toStruct: T.Type,
                              completion: @escaping MapperCompletion<T>)
}


final class DataMapper {
   private lazy var decoder: JSONDecoder = {
       let decoder = JSONDecoder()
       return decoder
   }()

   private let concurrentQueque = DispatchQueue(label: "concurrentForParsing",
                                                qos: .userInitiated,
                                                attributes: .concurrent)
}


//MARK: - Extensions
extension DataMapper: DataMapperProtocol {
   func decode<T>(from data: Data,
                  toStruct: T.Type,
                  completion: @escaping MapperCompletion<T>) where T : Decodable {
       concurrentQueque.async {
           do {
               let parsedTickets = try self.decoder.decode(toStruct, from: data)
               DispatchQueue.main.async {
                   completion(.success(parsedTickets))
               }
           }
           catch {
               DispatchQueue.main.async {
                   completion(.failure(.failAtMapping))
               }
           }
       }
   }

}




// для async await варианта
//protocol DataMapperProtocol {
//    func encode<T: Encodable>(from someStruct: T) throws -> Data
//    func decode<T: Decodable>(from data: Data, to someStruct: T.Type) throws -> T
//}
//
//// MARK: - DataMapper
//final class DataMapper {
//    private lazy var encoder: JSONEncoder = {
//        let encoder = JSONEncoder()
//        return encoder
//    }()
//
//    private lazy var decoder: JSONDecoder = {
//        let decoder = JSONDecoder()
//        return decoder
//    }()
//}
//
//
//// MARK: - DataMapperProtocol
//extension DataMapper: DataMapperProtocol {
//    func encode<T: Encodable>(from someStruct: T) throws -> Data {
//        do {
//            return try self.encoder.encode(someStruct)
//        } catch {
//            throw error
//        }
//    }
//
//    func decode<T: Decodable>(from data: Data, to someStruct: T.Type) throws -> T {
//        do {
//            return try self.decoder.decode(someStruct, from: data)
//        } catch _ as DecodingError {
//            throw MapperError.failAtMapping
//        } catch {
//            print("Unknown error have been caught in File: \(#file), at Line: \(#line), Column: \(#column)")
//            throw error
//        }
//    }
//
//}

