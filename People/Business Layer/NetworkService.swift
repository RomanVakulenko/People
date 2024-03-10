//
//  NetworkService.swift
//  People
//
//  Created by Roman Vakulenko on 10.03.2024.
//

import Foundation

protocol NetworkServiceProtocol: AnyObject {
    func downloadAndSavePeopleInfo(at url: URL) throws

}


final class NetworkService {
    
}


extension NetworkService: NetworkServiceProtocol {
    func downloadAndSavePeopleInfo(at url: URL) throws {

    }
}

