//
//  PhotoServiceDownloader.swift
//  People
//
//  Created by Roman Vakulenko on 18.03.2024.
//

import UIKit

protocol MenuServiceProtocol: AnyObject {
    func makePeopleModelWithPhoto(for people: [PersonInfo],
                                 completion: @escaping (Result<[PersonInfo], Error>) -> Void)
}

final class PhotoServiceDownloader: MenuServiceProtocol {

    // MARK: - Private properties
    private var peopleInfoWithPhoto: [PersonInfo]
    private let networkRouter: NetworkRouterProtocol

    // MARK: - Init
    init(peopleInfoWithPhoto: [PersonInfo], networkRouter: NetworkRouterProtocol = NetworkRouter()) {
        self.peopleInfoWithPhoto = peopleInfoWithPhoto
        self.networkRouter = networkRouter
    }

    func makePeopleModelWithPhoto(for people: [PersonInfo], completion: @escaping (Result<[PersonInfo], Error>) -> Void) {
        let group = DispatchGroup()

        for (index, person) in people.enumerated() {
            group.enter()

            guard let imageURL = URL(string: person.avatarUrl) else {
                group.leave()
                continue
            }

            let request = URLRequest(url: imageURL)
            networkRouter.requestDataWith(request) { [weak self] result in
                switch result {
                case .success(let data):
                    if let image = UIImage(data: data), let imageData = image.pngData() {
                        if let fileURL = self?.saveImageToDocumentsDirectory(imageData, imageName: person.id) {
                            self?.peopleInfoWithPhoto[index].avatarUrl = fileURL.path
                        } else {
                            return
                        }
                    }
                case .failure(let error):
                    completion(.failure(error))
                }

                group.leave()
            }
        }

        group.notify(queue: .main) {
            completion(.success(self.peopleInfoWithPhoto))
        }
    }

    // MARK: - Private methods
    private func saveImageToDocumentsDirectory(_ imageData: Data, imageName: String) -> URL? {
        do {
            let documentDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let fileName = "\(imageName).png"
            let fileURL = documentDir.appendingPathComponent(fileName)
            try imageData.write(to: fileURL)
            return fileURL
        } catch {
            return nil
        }
    }
}
