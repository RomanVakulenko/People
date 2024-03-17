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
    private(set) var allPeople: [PersonInfo] = [] {
        didSet {
            self.onPersonUpdated?()
        }
    }
    private(set) var filteredPerson: [PersonInfo] = []
    private weak var coordinator: PeopleFlowCoordinatorProtocol?
    private let networkService: NetworkServiceProtocol
    private let fileManager = FileManager.default
    private let userDefaults = UserDefaults.standard


    // MARK: - Init
    init(coordinator: PeopleFlowCoordinatorProtocol,
         networkService: NetworkServiceProtocol) {
        self.coordinator = coordinator
        self.networkService = networkService
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
        state = .loading

        networkService.getPeopleData { [weak self] result in
            guard let strongSelf = self else {return} // гарантирует, что код кложуры выполнится и, даже если мы в процессе выполнения кложуры уйдем с экрана, то контроллер высвободится после отработки кложуры!
            switch result {
            case .success(let personInfoArr):
                strongSelf.allPeople = personInfoArr
                strongSelf.state = .loadedAndSaved
                print(strongSelf.allPeople)
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
        self.filteredPerson = allPeople

        if let searchText = searchBarText?.lowercased() {
            guard !searchText.isEmpty else { self.onPersonUpdated?(); return }

            self.filteredPerson = self.filteredPerson.filter({ $0.firstName.lowercased().contains(searchText) }) //то, по чему будем фильтровать
        }

        self.onPersonUpdated?()
    }
}
