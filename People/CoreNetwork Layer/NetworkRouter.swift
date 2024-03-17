//
//  NetworkRouter.swift
//  People
//
//  Created by Roman Vakulenko on 17.03.2024.
//

import Foundation


typealias NetworkRouterCompletion = (Result<Data, RouterError>) -> Void

protocol NetworkRouterProtocol: AnyObject {
    func requestDataWith(_ urlRequest: URLRequest,
                         completion: @escaping NetworkRouterCompletion)
}


final class NetworkRouter { }


// MARK: - Extensions
extension NetworkRouter: NetworkRouterProtocol {

    func requestDataWith(_ urlRequest: URLRequest, completion: @escaping NetworkRouterCompletion) {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 10// if сервер не ответит
        configuration.timeoutIntervalForResource = 20// if загрузка data не завершится

        let session = URLSession(configuration: configuration)
        session.dataTask(with: urlRequest) { data, response, error in
            
            guard error == nil else {
                if let error = error as NSError? {
                    if error.domain == NSURLErrorDomain && error.code == NSURLErrorTimedOut {
                        DispatchQueue.main.async { completion(.failure(RouterError.badInternetConnection)) }
                        return
                    }
                }
                DispatchQueue.main.async { completion(.failure(RouterError.badInternetConnection)) }
                return
            }

            if let httpResponse = response as? HTTPURLResponse {
                let statusCode = httpResponse.statusCode
                if statusCode < 200 && statusCode > 299 {
                    DispatchQueue.main.async { completion(.failure(RouterError.badStatusCode)) }
                    return
                }
            }

            guard let data = data else {
                DispatchQueue.main.async { completion(.failure(RouterError.badInternetConnection)) }
                return
            }
            DispatchQueue.main.async { completion(.success(data)) }

        }.resume()
    }
}
