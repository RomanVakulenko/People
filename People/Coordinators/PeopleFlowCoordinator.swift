//
//  PeopleFlowCoordinator.swift
//  People
//
//  Created by Roman Vakulenko on 10.03.2024.
//

import UIKit

protocol PeopleFlowCoordinatorProtocol: AnyObject {
    func pushDetailViewController(withModel model: PersonInfo)
    func popToRootVC()
}


final class PeopleFlowCoordinator {

    // MARK: - Private properties
    private var navigationController: UINavigationController

    // MARK: - Init
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    // MARK: - Private methods
    private func createPeopleViewController() -> UIViewController {
        let mapper = DataMapper()
        let networkRouter = NetworkRouter()
        let networkService = NetworkService(networkRouter: networkRouter, mapper: mapper)
        let viewModel = PeopleViewModel(coordinator: self, networkService: networkService)
        let peopleViewController = PeopleViewController(viewModel: viewModel)
        let navController = UINavigationController(rootViewController: peopleViewController)
        navigationController = navController
        return navigationController
    }

    private func createDetailViewController(withModel model: PersonInfo) -> UIViewController {

//        let mapper = DataMapper()
//        let fileManager = LocalFilesManager(mapper: mapper)
//        let networkService = YTNetworkService(manager: fileManager, mapper: mapper)
        let viewModel = DetailViewModel(detailViewModel: model
//                                        mapper: mapper,
//                                        ytNetworkService: networkService
        )
        let detailViewController = DetailViewController(viewModel: viewModel)
        return detailViewController
    }

}


// MARK: - CoordinatorProtocol
extension PeopleFlowCoordinator: CoordinatorProtocol {
    func start() -> UIViewController {
        let vc = createPeopleViewController()
        return vc
    }
}


// MARK: - FlowCoordinatorProtocol
extension PeopleFlowCoordinator: PeopleFlowCoordinatorProtocol {

    func pushDetailViewController(withModel model: PersonInfo) {
        let detailViewController = createDetailViewController(withModel: model)
        navigationController.pushViewController(detailViewController, animated: true)
    }

    func popToRootVC() {
        navigationController.popToRootViewController(animated: true)
    }
}
