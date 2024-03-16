//
//  PeopleViewModel.swift
//  People
//
//  Created by Roman Vakulenko on 10.03.2024.
//

import UIKit

protocol DownloadProtocol: AnyObject {
    func downloadAndSavePeopleInfo()
}



final class PeopleViewModel {

    // MARK: - Enum
    enum State {
        case none
        case loading
        case refreshing
        case loadedAndSaved
        case allPeople
        case sortByAlphabet
        case sortByBirthDay
        case error(alertText: String)
    }

    // MARK: - Public properties
    var onPersonUpdated: (()->Void)?

    // MARK: - Variables
    private var inSearchMode = false

    var personModel: [PersonInfo] {
        self.inSearchMode ? filteredPerson : allPeople
    }

    private(set) var allPeople: [PersonInfo] = [] {
        didSet {
            self.onPersonUpdated?()
        }
    }

    private(set) var filteredPerson: [PersonInfo] = []

    var closureChangingState: ((State) -> Void)?
    //    let fManager: LocalFilesManagerProtocol
    var state: State = .none {
        didSet {
            closureChangingState?(state)
        }
    }

    //    var fileName: String?
    //    var photoURL: URL?

    // MARK: - Private properties
    private weak var coordinator: PeopleFlowCoordinatorProtocol?
    //    private let networkService: NetworkServiceProtocol


    // MARK: - Init
    init(coordinator: PeopleFlowCoordinatorProtocol
         //         networkService: YTNetworkServiceProtocol, fManager: LocalFilesManagerProtocol
    ) {
        self.coordinator = coordinator
        //        self.networkService = networkService
        //        self.fManager = fManager
    }

    // MARK: - Public methods
    func didTapCell(at indexPath: IndexPath) {
        let modelAtIndexPath = personModel[indexPath.item]
        coordinator?.pushDetailViewController(withModel: modelAtIndexPath)
    }

    func isFirstLaunch() -> Bool {
        let didLaunchBefore = UserDefaults.standard.bool(forKey: "didLaunchBefore")
        if didLaunchBefore {
            return false
        } else {
            UserDefaults.standard.set(true, forKey: "didLaunchBefore")
            return true
        }
    }

}


// MARK: - DownloadProtocol
extension PeopleViewModel: DownloadProtocol {

    func downloadAndSavePeopleInfo() {
        state = .loading //сразу после того как нажали на download
        //
        //        do {
        //            try self.networkService.downloadAndSaveVideo(videoIdentifier: videoID, videoURL: url)
        //
        //            fManager.statusClosure = { [weak self] status in
        //                switch status {
        //                case .fileExists:
        //                    self?.state = .fileExists
        //
        //                case .loading:
        //                    self?.state = .loading
        //
        //                case .loadedAndSaved:
        //                    self?.state = .loadedAndSaved
        //
        //                case .badURL(alertText: let alertTextForUser):
        //                    self?.state = .badURL(alertText: alertTextForUser)
        ////  ДОП ЗАДАНИЕ: Ошибка сетевого соединения (timeout, HTTP-статус 5xx и т.п.). В этом случае в уведомлении текст "Не могу обновить данные. Проверь соединение с интернетом"
        ////  Ошибка от сервера (HTTP-статус 4xx) или ошибка при парсинге данных. В этом случае в уведомлении текст "Не могу обновить данные. Что-то пошло не так".
        ////  Уведомление закрывает собой статус-бар. Оно должно скрываться спустя 3 секунды само, но его можно также убрать тапом.
        //
        //                default: print("зашел в дефолтный кейс fManagerА")
        //                }
        //            }
        //        } catch let error as URLError {
        //            if error.networkUnavailableReason == .cellular {
        //                self.state = .error(alertText: "Сотовая сеть отключена")
        //            } else if let reason = error.networkUnavailableReason {
        //                self.state = .error(alertText: "Сеть недоступна: \(reason)")
        //            }
        //            switch error.code {
        //            case .notConnectedToInternet:
        //                self.state = .error(alertText: "Не могу обновить данные. Проверь соединение с интернетом")
        //            default:
        //                print("Неизвестная ошибка типа URLError")
        //                self.state = .error(alertText: "Некорректный URL")
        //            }
        //        } catch {
        //            print(error.localizedDescription)
        //        }
    }
}

// MARK: - Search
extension PeopleViewModel {

    func setInSearchMode(_ searchController: UISearchController) -> Bool {
        let isActive = searchController.isActive
        let searchText = searchController.searchBar.text ?? ""
        return isActive && !searchText.isEmpty
    }

    func updateSearchController(searchBarText: String?) {
        self.filteredPerson = allPeople

        if let searchText = searchBarText?.lowercased() {
            guard !searchText.isEmpty else { self.onPersonUpdated?(); return }

            self.filteredPerson = self.filteredPerson.filter({ $0.firstName.lowercased().contains(searchText) }) //то, по чему будем фильтровать
        }

        self.onPersonUpdated?()
    }
}
