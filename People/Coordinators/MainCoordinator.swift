//
//  MainCoordinator.swift
//  People
//
//  Created by Roman Vakulenko on 10.03.2024.
//

import UIKit

final class MainCoordinator {

    // MARK: - Private properties
    /// Ххранит ссылки на координаторы, иначе, при выходе за область видимости функции start, потеряем ссылки на координаторов (когда main создает дочерние или дочерние создают еще свои дочерние)
    private var childCoordinators = [CoordinatorProtocol]()

    // MARK: - Private methods
    private func makePeopleCoordinator() -> CoordinatorProtocol {
        let coordinator = PeopleFlowCoordinator(navigationController: UINavigationController())
        return coordinator
    }
    /// Сравниваем адреса памяти, ссылается ли объект на тот же адрес памяти (т.е. до тех пор пока координаторов нет - добавляй их)
    private func addChildCoordinator(_ coordinator: CoordinatorProtocol) {
        guard !childCoordinators.contains(where: { $0 === coordinator }) else { return }
        childCoordinators.append(coordinator)
    }

}

// MARK: - Extension
extension MainCoordinator: CoordinatorProtocol {
    /// Этот VC возвращаем в sceneDelegate
    func start() -> UIViewController {
        let peopleScreenCoordinator = makePeopleCoordinator()
        addChildCoordinator(peopleScreenCoordinator)
        return peopleScreenCoordinator.start()
    }
}
