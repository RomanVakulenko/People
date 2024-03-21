//
//  NetworkService.swift
//  People
//
//  Created by Roman Vakulenko on 10.03.2024.
//


import UIKit

typealias NetworkServiceCompletion = (Result<[PersonInfo], NetworkServiceErrors>) -> Void

protocol NetworkServiceProtocol: AnyObject {
   func loadData(completion: @escaping NetworkServiceCompletion)
}


final class NetworkService {
    // MARK: - Private properties
    private let networkRouter: NetworkRouterProtocol
    private let mapper: DataMapperProtocol

    // MARK: - Init
    init(networkRouter: NetworkRouterProtocol, mapper: DataMapper) {
        self.networkRouter = networkRouter
        self.mapper = mapper
    }

    // MARK: - Public methods
    private func createURLRequest(with url: URL) -> URLRequest? {
        let successHeaders = ["Content-Type": "application/json", "Prefer": "code=200, example=success"]
        let errorHeaders = ["Content-Type": "application/json", "Prefer": "code=500, example=error-500"]

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

//        let headersVariant = [successHeaders, errorHeaders]
//        let randomHeaders = headersVariant.randomElement() ?? successHeaders
        request.allHTTPHeaderFields = successHeaders
        return request
    }
}

// MARK: - NetworkServiceProtocol
extension NetworkService: NetworkServiceProtocol {

    func loadData(completion: @escaping NetworkServiceCompletion) {
        guard let url = StandardEndpoint().url else {
            print("Не удалось создать url")
            return
        }
        guard let urlRequest = createURLRequest(with: url) else {
            print("Не удалось создать urlRequest")
            return
        }

        networkRouter.requestDataWith(urlRequest) { [weak self] result in
           switch result {
           case .success(let data):
               self?.mapper.decode(from: data, toStruct: PersonModel.self, completion: { result in

                   switch result {
                   case .success(let decodedPeopleInfo):
                       let peopleArr = decodedPeopleInfo.items
                       let photoDowloader = PhotoServiceDownloader(peopleInfoWithPhoto: peopleArr)
                       photoDowloader.makePeopleModelWithPhoto(for: peopleArr) { result in
                           switch result {
                           case .success(let peopleModelWithPhoto):
                               completion(.success(peopleModelWithPhoto))
                           case .failure(let error):
                               completion(.failure(error as! NetworkServiceErrors))
                           }
                       }

                   case .failure:
                       completion(.failure(.mapperError(error: .failAtMapping)))
                   }
               })

           case .failure(let error):
               completion(.failure(.networkRouterError(error: error)))
           }
       }
   }
}


