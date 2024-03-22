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
///для переклчения радиоБаттон о сортировке и чтобы запомнить состояние до refresh
enum SortState {
    case sortByNameChoosen
    case groupByYearChoosen
    case sortByBirthdayChoosen
}


// MARK: - Enum
enum State: Equatable {
    case none
    case loading
    case refreshing
    case loadedAndSaved
    case searchResultNotEmpty
    case sortedByAlphabet
    case groupedByYear
    case sortedByDay
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
    var peopleSortedByBirthday: [[PersonInfo]] = []
    var personModel: [PersonInfo] {
        self.isSearching || self.isDepartmentChoosen ? filteredPerson : downloadedPeople
    }
    var tabFilteredPerson: [PersonInfo] = []
    var downloadedPeople: [PersonInfo] = []
    var textInSearchBar = ""
    var sortState: SortState = .sortByNameChoosen
    var departmentBeforeRefresh = Department.all.rawValue ///для refresh

    // MARK: - Private properties
    var filteredPerson: [PersonInfo] = []
    private var isSearching = false
    private var isDepartmentChoosen = false

    private weak var coordinator: PeopleFlowCoordinatorProtocol?
    private let networkService: NetworkServiceProtocol
    private let userDefaults: UserDefaults

    private lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter
    }()

    // MARK: - Init
    init(coordinator: PeopleFlowCoordinatorProtocol,
         networkService: NetworkServiceProtocol,
         userDefaults: UserDefaults = UserDefaults.standard) {
        self.coordinator = coordinator
        self.networkService = networkService
        self.userDefaults = userDefaults
    }

    // MARK: - Public methods
    func openPersonDetails(_ person: PersonInfo) {
        coordinator?.pushDetailViewController(withModel: person)
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

    func groupPeopleWithEqualYearDecending() {
        let currentYear = Calendar.current.component(.year, from: Date())
        var tempDict: [String: [PersonInfo]] = [:]

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

        ///сортируем ДР по убыванию внутри группы
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

    func sortPeopleByBirthday() {
        let currentMonth = Calendar.current.component(.month, from: Date())
        let currentDay = Calendar.current.component(.day, from: Date())

        var futureBirthdaysThisYear: [PersonInfo] = []
        var nextYearBirthdays: [PersonInfo] = []

        for person in personModel {
            if let birthDate = dateFormatter.date(from: person.birthday) {
                let birthMonth = Calendar.current.component(.month, from: birthDate)
                let birthDay = Calendar.current.component(.day, from: birthDate)

                if currentMonth < birthMonth || (currentMonth == birthMonth && currentDay < birthDay) {
                    futureBirthdaysThisYear.append(person)
                } else {
                    nextYearBirthdays.append(person)
                }
            }
        }

        futureBirthdaysThisYear.sort { person1, person2 in
            guard let date1 = dateFormatter.date(from: person1.birthday),
                  let date2 = dateFormatter.date(from: person2.birthday) else {
                return false
            }
            let day1 = Calendar.current.component(.day, from: date1)
            let day2 = Calendar.current.component(.day, from: date2)
            let month1 = Calendar.current.component(.month, from: date1)
            let month2 = Calendar.current.component(.month, from: date2)
            return (month1, day1) < (month2, day2)
        }

        nextYearBirthdays.sort { person1, person2 in
            guard let date1 = dateFormatter.date(from: person1.birthday),
                  let date2 = dateFormatter.date(from: person2.birthday) else {
                return false
            }
            let day1 = Calendar.current.component(.day, from: date1)
            let day2 = Calendar.current.component(.day, from: date2)
            let month1 = Calendar.current.component(.month, from: date1)
            let month2 = Calendar.current.component(.month, from: date2)

            return (month1, day1) < (month2, day2) || (month1, day1) > (month2, day2) && month1 < month2
        }
        peopleSortedByBirthday = [futureBirthdaysThisYear, nextYearBirthdays]
    }
}


// MARK: - DownloadProtocol
extension PeopleViewModel: DownloadProtocol {

    func downloadAndSavePeopleInfo() {
        state = .loading

        networkService.loadData { [weak self] result in
            guard let strongSelf = self else {return} /// гарантирует, что код кложуры выполнится и, даже если мы в процессе выполнения кложуры уйдем с экрана, то контроллер высвободится после отработки кложуры!
            switch result {
            case .success(let personInfoArr):
                strongSelf.downloadedPeople = personInfoArr
                strongSelf.tabFilteredPerson = strongSelf.downloadedPeople ///старт для сортировки
                
                if strongSelf.sortState == .sortByBirthdayChoosen {
                    strongSelf.filterBy(departmentName: strongSelf.departmentBeforeRefresh)
                    strongSelf.state = .sortedByDay
                } else if strongSelf.sortState == .groupByYearChoosen {
                    strongSelf.filterBy(departmentName: strongSelf.departmentBeforeRefresh)
                    strongSelf.state = .groupedByYear
                } else {
                    strongSelf.state = .loadedAndSaved
                }
            case .failure(let error):
                strongSelf.state = .error(alertText: error.localizedDescription)
            }
        }
    }
}

// MARK: - Search & Filter
extension PeopleViewModel {

    ///cортировка при первом запуске
    func sortByName(model: inout [PersonInfo]) {
        model.sort {
            let fullName1 = $0.firstName + " " + $0.lastName
            let fullName2 = $1.firstName + " " + $1.lastName
            return fullName1 < fullName2
        }
        sortState = .sortByNameChoosen
        state = .sortedByAlphabet
    }

    func setGroupByYearState() {
        sortState = .groupByYearChoosen
        state = .groupedByYear
    }

    func sortByDay(model: inout [PersonInfo]) {
        sortState = .sortByBirthdayChoosen
        state = .sortedByDay
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
            if sortState == .groupByYearChoosen {
                state = .groupedByYear
            }
            if sortState == .sortByBirthdayChoosen {
                state = .sortedByDay
            }
        }
    }

    func filterBy(departmentName: String) {
        filteredPerson = downloadedPeople
        isDepartmentChoosen = true
        departmentBeforeRefresh = departmentName

        if departmentName == "all" {
            filteredPerson = downloadedPeople
            isDepartmentChoosen = false
            updateSearchController(searchBarText: textInSearchBar)
        }
        tabFilteredPerson = filteredPerson.filter({ person in
            let filterByDepartment = person.department.lowercased().contains(departmentName)
            return filterByDepartment
        })
        updateSearchController(searchBarText: textInSearchBar)
    }
}
