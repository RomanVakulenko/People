//
//  DetailViewModel.swift
//  People
//
//  Created by Roman Vakulenko on 10.03.2024.
//

import Foundation

// MARK: - Protocols
protocol DetailsViewModelProtocol: AnyObject {
    var personModel: PersonInfo { get set }
    func popViewController()
}

// MARK: - DetailViewModel
final class DetailViewModel: DetailsViewModelProtocol {

    // MARK: - Public properties
    var personModel: PersonInfo

    // MARK: - Private properties
    private weak var coordinator: PeopleFlowCoordinatorProtocol?

    // MARK: - Init
    init(detailViewModel: PersonInfo, coordinator: PeopleFlowCoordinatorProtocol) {
        self.personModel = detailViewModel
        self.coordinator = coordinator
    }

    // MARK: - Private methods

    func popViewController() {
        coordinator?.popViewController()
    }

}
