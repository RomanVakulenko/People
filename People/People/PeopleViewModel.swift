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
///для переклчения радиоБаттон о сортировке
enum SortState {
    case sortedByName
    case sortedByDate
}


// MARK: - Enum
enum State: Equatable {
    case none
    case loading
    case refreshing
    case loadedAndSaved
    case searchResultNotEmpty
    case sortedByAlphabet
    case sortedByBirthDay
    case nobodyWasFound
    case error(alertText: String)
}


final class PeopleViewModel {

    // MARK: - Public properties
    var closureChangingState: ((State) -> Void)?
    var state: State = .none {
        didSet {
            closureChangingState?(state)
        }
    }
    var peopleGroupedByYear: [[PersonInfo]] = []
    var personModel: [PersonInfo] {
        self.isSearching || self.isDepartmentChoosen ? filteredPerson : downloadedPeople
    }
    var tabFilteredPerson: [PersonInfo] = []
    var downloadedPeople: [PersonInfo] = []
    var textInSearchBar = ""
    var sortState: SortState = .sortedByName

    // MARK: - Private properties
    var filteredPerson: [PersonInfo] = []
    private var isSearching = false
    private var isDepartmentChoosen = false

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

    func groupPeopleByCurrentYear() {
        let currentYear = Calendar.current.component(.year, from: Date())
        var tempDict: [String: [PersonInfo]] = [:]

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        for person in personModel {
            if let birthDate = dateFormatter.date(from: person.birthday) {
                let birthYear = Calendar.current.component(.year, from: birthDate)
                if currentYear > birthYear {
                    let key = "\(birthYear)"
                    if tempDict[key] == nil {
                        tempDict[key] = [person]
                    } else {
                        tempDict[key]?.append(person)
                    }
                }
            }
        }

        peopleGroupedByYear = tempDict.values.map { $0 }

        ///сортируем ДР по убыванию
        for index in peopleGroupedByYear.indices {
            peopleGroupedByYear[index].sort { person1, person2 in
                guard let date1 = dateFormatter.date(from: person1.birthday),
                      let date2 = dateFormatter.date(from: person2.birthday) else {
                    return false
                }
                return date1 > date2
            }
        }
        ///сортируем группы по убыванию года
        peopleGroupedByYear.sort { group1, group2 in
            guard let year1 = Int(group1.first?.birthday.prefix(4) ?? ""),
                  let year2 = Int(group2.first?.birthday.prefix(4) ?? "") else {
                return false
            }
            return year1 > year2
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
                strongSelf.downloadedPeople = personInfoArr
                strongSelf.sortByName(model: &strongSelf.downloadedPeople)
                strongSelf.tabFilteredPerson = strongSelf.downloadedPeople ///чтобы был наполнен для сортировки
                strongSelf.state = .loadedAndSaved
            case .failure(let error):
                strongSelf.state = .error(alertText: error.localizedDescription)
            }
        }
    }
}

// MARK: - Search & Filter
extension PeopleViewModel {

    func sortByName(model: inout [PersonInfo]) {
        model.sort { //Метод sorted() возвращает отсортированную копию массива, в то время как sort() изменяет исходный массив.
            let fullName1 = $0.firstName + " " + $0.lastName
            let fullName2 = $1.firstName + " " + $1.lastName
            return fullName1 < fullName2
        }
        sortState = .sortedByName
        state = .sortedByAlphabet
    }

    func sortByDate(model: inout [PersonInfo]) {
        sortState = .sortedByDate
        state = .sortedByBirthDay
    }

    func setInSearchMode(_ searchController: UISearchController) -> Bool {
        let isActive = searchController.isActive
        let searchText = searchController.searchBar.text ?? ""
        return isActive && !searchText.isEmpty
    }

    func updateSearchController(searchBarText: String?) {
        isSearching = true
        if isDepartmentChoosen == true {
            filteredPerson = tabFilteredPerson
        } else {
            filteredPerson = downloadedPeople ///для .all
        }

        if let searchText = searchBarText?.lowercased(),
           !searchText.isEmpty {
            filteredPerson = filteredPerson.filter({ person in //возвращает новую коллекцию
                let filterByFullName = (person.firstName + " " + person.lastName).lowercased().contains(searchText)
                let filterByNickname = person.userTag.lowercased().contains(searchText)
                return filterByFullName || filterByNickname
            })
            textInSearchBar = searchText
        }

        if filteredPerson.isEmpty {
            state = .nobodyWasFound
        }
        else {
            state = .searchResultNotEmpty
            if sortState == .sortedByDate {
                state = .sortedByBirthDay
            }
        }
    }

    func filterBy(departmentName: String) {
        filteredPerson = downloadedPeople
        isDepartmentChoosen = true

        if departmentName == "all" {
            filteredPerson = downloadedPeople
            isDepartmentChoosen = false
            updateSearchController(searchBarText: textInSearchBar)
        }
        tabFilteredPerson = filteredPerson.filter({ person in
            let filterByDepartment = person.department.lowercased().contains(departmentName)
            return filterByDepartment
        })
        print("\(departmentName) = \(tabFilteredPerson.count)")
        updateSearchController(searchBarText: textInSearchBar)
    }
}
