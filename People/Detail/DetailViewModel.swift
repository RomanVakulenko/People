//
//  DetailViewModel.swift
//  People
//
//  Created by Roman Vakulenko on 10.03.2024.
//

import Foundation

final class DetailViewModel {

    // MARK: - Public properties
    var personModel: PersonModel

    init(detailViewModel: PersonModel) {
        self.personModel = detailViewModel
    }

    // MARK: - Private properties
    private weak var coordinator: PeopleFlowCoordinatorProtocol?
//    private let networkService: NetworkServiceProtocol
}
