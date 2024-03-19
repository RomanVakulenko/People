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

// MARK: - Enum
enum State: Equatable {
    case none
    case loading
    case refreshing
    case loadedAndSaved
    case allPeople
    case sortByAlphabet
    case sortByBirthDay
    case error(alertText: String)
}


final class PeopleViewModel {

    // MARK: - Public properties
    var personModel: [PersonInfo] {
        self.inSearchMode ? filteredPerson : allPeople
    }
    var closureChangingState: ((State) -> Void)?
    var state: State = .none {
        didSet {
            closureChangingState?(state)
        }
    }

    // MARK: - Private properties
    private var inSearchMode = false
    private var onPersonUpdated: (()->Void)?
    private(set) var allPeople: [PersonInfo] = []
//    {
//        didSet {
//            self.onPersonUpdated?()
//        }
//    }
    private(set) var filteredPerson: [PersonInfo] = []

    private weak var coordinator: PeopleFlowCoordinatorProtocol?
    private let networkService: NetworkServiceProtocol
//    private let fileManager = FileManager.default
    private let userDefaults: UserDefaults

    // MARK: - Init
    init(coordinator: PeopleFlowCoordinatorProtocol,
         networkService: NetworkServiceProtocol,
         userDefaults: UserDefaults = UserDefaults.standard) {
        self.coordinator = coordinator
        self.networkService = networkService
        self.userDefaults = userDefaults
    }

    // MARK: - Public methods
    func didTapCell(at indexPath: IndexPath) {
        let modelAtIndexPath = personModel[indexPath.item]
        coordinator?.pushDetailViewController(withModel: modelAtIndexPath)
    }

    func isFirstLaunch() -> Bool {
        let didLaunchBefore = userDefaults.bool(forKey: "didLaunchBefore")
        if didLaunchBefore {
            return false
        } else {
            userDefaults.set(true, forKey: "didLaunchBefore")
            return true
        }
    }
}


// MARK: - DownloadProtocol
extension PeopleViewModel: DownloadProtocol {

    func downloadAndSavePeopleInfo() {
        state = .loading

        networkService.loadData { [weak self] result in
            guard let strongSelf = self else {return} // гарантирует, что код кложуры выполнится и, даже если мы в процессе выполнения кложуры уйдем с экрана, то контроллер высвободится после отработки кложуры!
            switch result {
            case .success(let personInfoArr):
                strongSelf.allPeople = personInfoArr
                strongSelf.state = .loadedAndSaved
            case .failure(let error):
                strongSelf.state = .error(alertText: error.localizedDescription)
            }
        }
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
        filteredPerson = allPeople
        inSearchMode = true

        if let searchText = searchBarText?.lowercased() {
            guard !searchText.isEmpty else { onPersonUpdated?(); return }

            filteredPerson = filteredPerson.filter({ person in
                let filterByFullName = (person.firstName + " " + person.lastName).lowercased().contains(searchText)
                let filterByNickname = person.userTag.lowercased().contains(searchText)
                return filterByFullName || filterByNickname
            })
        }
        //        self.onPersonUpdated?()
    }
}
