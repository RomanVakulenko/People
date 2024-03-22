//
//  PeopleViewController.swift
//  People
//
//  Created by Roman Vakulenko on 10.03.2024.
//

import UIKit

// MARK: - Enum SkeletonState
enum SkeletonState {
    case skeleton
    case not
}

// MARK: - Enum Department
enum Department: String {
    case all, design, analytics, management, android, ios, qa, back_office, frontEnd, hr, pr, backend, support

    static let dictionary: [Int: Department] = [
        0: .all,
        1: .design,
        2: .analytics,
        3: .management,
        4: .android,
        5: .ios,
        6: .qa,
        7: .back_office,
        8: .frontEnd,
        9: .hr,
        10: .pr,
        11: .backend,
        12: .support
    ]
}


// MARK: - PeopleViewController
final class PeopleViewController: UIViewController {

    // MARK: - Public properties
    let viewModel: PeopleViewModel

    // MARK: - Private properties
    private let departments = ["Все", "Designers", "Analysts", "Managers", "Android", "iOS", "QA", "Back_office", "Frontenders", "HR", "PR", "Backenders", "Support"]
    private var selectedIndexPath = IndexPath(item: 0, section: 0)
    private var skeletonState: SkeletonState = .skeleton

    // MARK: - SubTypes
    private let searchController = UISearchController(searchResultsController: nil)

    private lazy var sortController: UIViewController = {
        let sortVC = SortViewController()
        sortVC.delegate = self
        return sortVC
    }()

    private lazy var refreshControl: UIRefreshControl = {
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(refresh_valueChanged), for: .valueChanged)
        return refresh
    }()

    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .medium)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.color = UIColor(red: 0.591, green: 0.591, blue: 0.609, alpha: 1)
        return spinner
    }()

    private lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(SkeletonCell.self, forCellReuseIdentifier: SkeletonCell.ReuseId)
        tableView.register(PersonCell.self, forCellReuseIdentifier: PersonCell.ReuseId)
        tableView.register(CustomHeaderView.self, forHeaderFooterViewReuseIdentifier: CustomHeaderView.ReuseId)
        tableView.backgroundColor = .clear
        tableView.rowHeight = 84
        tableView.separatorStyle = .none
        tableView.addSubview(refreshControl)
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()

    private lazy var errorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()

    private lazy var errorImg: UIImageView = {
        var imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "errorPic")
        return imageView
    }()

    private lazy var errorBoldLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = UIColor(red: 0.02, green: 0.02, blue: 0.063, alpha: 1)
        label.font = UIFont(name: "Inter-SemiBold", size: 17)
        label.font = UIFont.boldSystemFont(ofSize: 17)
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.07
        label.attributedText = NSMutableAttributedString(
            string: "Какой-то сверхразум все сломал",
            attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
        return label
    }()

    private lazy var errorRegularLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = UIColor(red: 0.591, green: 0.591, blue: 0.609, alpha: 1)
        label.font = UIFont(name: "Inter-Regular", size: 16)
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.03
        label.attributedText = NSMutableAttributedString(
            string: "Постараемся быстро починить",
            attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
        return label
    }()

    private lazy var errorTryAgainBtn: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.backgroundColor = .clear
        btn.setTitleColor(UIColor(red: 0.396, green: 0.204, blue: 1, alpha: 1), for: .normal)
        btn.titleLabel?.font = UIFont(name: "Inter-SemiBold", size: 16)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        btn.titleLabel?.textAlignment = .center
        let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineHeightMultiple = 1.03
        let attributedString = NSMutableAttributedString(
            string: "Попробовать снова",
            attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
        btn.setAttributedTitle(attributedString, for: .normal)
        btn.addTarget(self, action: #selector(tryAgainBtn_touchUpInside(_:)), for: .touchUpInside)
        return btn
    }()

    private lazy var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        return layout
    }()

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.register(FilterCell.self, forCellWithReuseIdentifier: FilterCell.ReuseId)
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()

    private lazy var notFoundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()

    private lazy var notFoundImg: UIImageView = {
        var imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "lense")
        return imageView
    }()

    private lazy var notFoundBoldLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = UIColor(red: 0.02, green: 0.02, blue: 0.063, alpha: 1)
        label.font = UIFont(name: "Inter-SemiBold", size: 17)
        label.font = UIFont.boldSystemFont(ofSize: 17)
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.07
        label.attributedText = NSMutableAttributedString(
            string: "Мы никого не нашли",
            attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
        return label
    }()

    private lazy var notFoundRegularLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = UIColor(red: 0.591, green: 0.591, blue: 0.609, alpha: 1)
        label.font = UIFont(name: "Inter-Regular", size: 16)
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.03
        label.attributedText = NSMutableAttributedString(
            string: "Попробуй скорректировать запрос",
            attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var errorViewAtRefreshing: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .red
        view.isHidden = true
        return view
    }()

    private lazy var errorLblAtRefreshing: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()


    // MARK: - Init
    init(viewModel: PeopleViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchController()
        setupFilterAsCollectionAndTableView()
        bindViewModel()
        viewModel.downloadAndSavePeopleInfo()
        setupErrorViewAtRefreshingWith()
    }


    // MARK: - Actions
    @objc func tryAgainBtn_touchUpInside(_ sender: UIButton) {
        viewModel.downloadAndSavePeopleInfo()
    }

    @objc func refresh_valueChanged(_ sender: UIRefreshControl) {
        viewModel.refreshRequest = true
        viewModel.downloadAndSavePeopleInfo()
    }


    // MARK: - Private methods
    private func bindViewModel() {
        viewModel.closureChangingState = { [weak self] state in
            guard let strongSelf = self else { return }

            DispatchQueue.main.async {
                switch state {
                case .none:
                    ()
                case .loading:
                    strongSelf.errorView.isHidden = true
                    strongSelf.searchController.searchBar.isHidden = false

                case .refreshing:
                    //Уведомление закрывает собой статус-бар. Оно должно скрываться спустя 3 секунды само, но его можно также убрать тапом.
                    ()
                case .loadedAndSaved:
                    strongSelf.viewModel.sortByName(model: &strongSelf.viewModel.downloadedPeople)
                    strongSelf.skeletonState = .not
                    strongSelf.tableView.reloadData()
                    strongSelf.refreshControl.endRefreshing()

                case .searchResultNotEmpty:
                    strongSelf.notFoundView.isHidden = true
                    
                case .sortedByAlphabet:
                    strongSelf.searchController.searchBar.setImage(
                        UIImage(named: "sortBtn"), for: .bookmark, state: .normal)
                    strongSelf.tableView.reloadData()

                case .groupedByYear:
                    strongSelf.searchController.searchBar.setImage(
                        UIImage(named: "bookmarkBtnTapped"), for: .bookmark, state: .normal)
                    strongSelf.viewModel.groupPeopleWithEqualYearDecending()
                    strongSelf.tableView.reloadData()
                    strongSelf.refreshControl.endRefreshing()

                case .sortedByDay:
                    strongSelf.searchController.searchBar.setImage(
                        UIImage(named: "bookmarkBtnTapped"), for: .bookmark, state: .normal)
                    strongSelf.viewModel.sortPeopleByBirthday()
                    strongSelf.tableView.reloadData()
                    strongSelf.refreshControl.endRefreshing()

                case .nobodyWasFound:
                    strongSelf.setupNotFoundView()

                case .error(let error):
                    strongSelf.refreshControl.endRefreshing()

                    if strongSelf.viewModel.refreshRequest {
                        strongSelf.errorViewAtRefreshing.isHidden = false
                        strongSelf.searchController.searchBar.isHidden = true
                        strongSelf.errorLblAtRefreshing.text = error.description

                        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                            strongSelf.errorViewAtRefreshing.isHidden = true
                            strongSelf.searchController.searchBar.isHidden = false
                        }
                    } else {
                        strongSelf.setupErrorView()
                    }
                }
            }
        }
    }

    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "Введите имя, тег, почту..."

        navigationItem.searchController = searchController
        definesPresentationContext = false
        navigationItem.hidesSearchBarWhenScrolling = false

        searchController.delegate = self
        searchController.searchBar.delegate = self
        searchController.searchBar.showsBookmarkButton = true
        searchController.searchBar.setImage(
            UIImage(named: "sortBtn"), for: .bookmark, state: .normal)

        searchController.searchBar.setValue("Отмена", forKey: "cancelButtonText")
        let attributes:[NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor(red: 0.396, green: 0.204, blue: 1, alpha: 1),
            .font: UIFont.systemFont(ofSize: 15, weight: .bold)
        ]
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).setTitleTextAttributes(attributes, for: .normal)
    }

    private func setupFilterAsCollectionAndTableView() {
        view.backgroundColor = .white
        [collectionView, spinner, tableView].forEach { view.addSubview($0) }

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            collectionView.heightAnchor.constraint(equalToConstant: 44),
            //пока не уверен - возможно надо будет делать 2ой набор констрейнтов
            spinner.bottomAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 8),
            spinner.centerXAnchor.constraint(equalTo: collectionView.centerXAnchor),

            tableView.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 8),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    private func setupErrorViewAtRefreshingWith() {
        errorViewAtRefreshing.addSubview(errorLblAtRefreshing)
        view.addSubview(errorViewAtRefreshing)

        NSLayoutConstraint.activate([
            errorViewAtRefreshing.topAnchor.constraint(equalTo: view.topAnchor),
            errorViewAtRefreshing.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            errorViewAtRefreshing.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            errorViewAtRefreshing.bottomAnchor.constraint(equalTo: collectionView.topAnchor),

            errorLblAtRefreshing.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            errorLblAtRefreshing.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            errorLblAtRefreshing.heightAnchor.constraint(equalToConstant: 48),
            errorLblAtRefreshing.bottomAnchor.constraint(equalTo: errorViewAtRefreshing.bottomAnchor, constant: -12),
        ])
    }

    private func setupErrorView() {
        [errorImg, errorBoldLabel, errorRegularLabel, errorTryAgainBtn].forEach{ errorView.addSubview($0) }
        view.addSubview(errorView)
        errorView.isHidden = false
        searchController.searchBar.isHidden = true

        NSLayoutConstraint.activate([
            errorView.topAnchor.constraint(equalTo: view.topAnchor),
            errorView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            errorView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            errorView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            errorImg.centerXAnchor.constraint(equalTo: errorView.centerXAnchor),
            errorImg.centerYAnchor.constraint(equalTo: errorView.centerYAnchor),
            errorImg.heightAnchor.constraint(equalToConstant: 56),
            errorImg.widthAnchor.constraint(equalToConstant: 56),

            errorBoldLabel.topAnchor.constraint(equalTo: errorImg.bottomAnchor, constant: 8),
            errorBoldLabel.centerXAnchor.constraint(equalTo: errorImg.centerXAnchor),
            errorBoldLabel.heightAnchor.constraint(equalToConstant: 22),

            errorRegularLabel.topAnchor.constraint(equalTo: errorBoldLabel.bottomAnchor, constant: 12),
            errorRegularLabel.centerXAnchor.constraint(equalTo: errorImg.centerXAnchor),
            errorRegularLabel.heightAnchor.constraint(equalToConstant: 20),

            errorTryAgainBtn.topAnchor.constraint(equalTo: errorRegularLabel.bottomAnchor, constant: 12),
            errorTryAgainBtn.centerXAnchor.constraint(equalTo: errorImg.centerXAnchor),
            errorTryAgainBtn.heightAnchor.constraint(equalToConstant: 20)
        ])
    }

    private func setupNotFoundView() {
        [notFoundImg, notFoundBoldLabel, notFoundRegularLabel].forEach{ notFoundView.addSubview($0) }
        view.addSubview(notFoundView)
        notFoundView.isHidden = false

        NSLayoutConstraint.activate([
            notFoundView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 52),
            notFoundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            notFoundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            notFoundView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            notFoundImg.topAnchor.constraint(equalTo: view.topAnchor, constant: 256),
            notFoundImg.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            notFoundImg.heightAnchor.constraint(equalToConstant: 56),
            notFoundImg.widthAnchor.constraint(equalToConstant: 56),

            notFoundBoldLabel.topAnchor.constraint(equalTo: notFoundImg.bottomAnchor, constant: 8),
            notFoundBoldLabel.centerXAnchor.constraint(equalTo: notFoundImg.centerXAnchor),
            notFoundBoldLabel.heightAnchor.constraint(equalToConstant: 22),

            notFoundRegularLabel.topAnchor.constraint(equalTo: notFoundBoldLabel.bottomAnchor, constant: 12),
            notFoundRegularLabel.centerXAnchor.constraint(equalTo: notFoundImg.centerXAnchor),
            notFoundRegularLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
    }

}

// MARK: - UITableViewDataSource
extension PeopleViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        switch viewModel.state {
        case .groupedByYear:
            return viewModel.peopleGroupedByYear.count
        case .sortedByDay:
            return viewModel.peopleSortedByBirthday.count
        default:
            return 1
        }
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch viewModel.state {
        case .groupedByYear:
            guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: CustomHeaderView.ReuseId) as? CustomHeaderView else { return nil }
            /// Передаю текст для хедера, начиная со второй секции
            let text = String(viewModel.peopleGroupedByYear[section].first?.birthday.prefix(4) ?? "")
            header.setupHeader(text: text)
            return header
        case .sortedByDay:
            if viewModel.peopleSortedByBirthday[1].isEmpty {
                return nil
            } else {
                guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: CustomHeaderView.ReuseId) as? CustomHeaderView else { return nil }
                let currentYear = Calendar.current.component(.year, from: Date())
                let text = String(Calendar.current.component(.year, from: Date()) + 1)
                header.setupHeader(text: text)
                return header
            }
        default:
            return nil
        }
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 0 : 48 ///-20 some space between cell.bottom and header
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if skeletonState == .skeleton {
            return 10
        } else {
            switch viewModel.state {
            case .groupedByYear:
                return viewModel.peopleGroupedByYear[section].count
            case .sortedByDay:
                return viewModel.peopleSortedByBirthday[section].count
            default:
                return viewModel.personModel.count
            }
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PersonCell.ReuseId, for: indexPath) as? PersonCell,
              let skeletonCell = tableView.dequeueReusableCell(withIdentifier: SkeletonCell.ReuseId, for: indexPath) as? SkeletonCell else {
            return UITableViewCell() }

        cell.selectionStyle = .none
        skeletonCell.isUserInteractionEnabled = false

        if skeletonState == .skeleton {
            return skeletonCell
        } else {
            switch viewModel.state {
            case .groupedByYear:
                cell.birthdayLabel.isHidden = false
                let model = viewModel.peopleGroupedByYear[indexPath.section][indexPath.row]
                cell.fill(with: model)
                return cell
            case .sortedByDay:
                cell.birthdayLabel.isHidden = false
                let model = viewModel.peopleSortedByBirthday[indexPath.section][indexPath.row]
                cell.fill(with: model)
                return cell
            default:
                cell.birthdayLabel.isHidden = true
                let model = viewModel.personModel[indexPath.row]
                cell.fill(with: model)
                return cell
            }
        }
    }
}

// MARK: - UITableViewDelegate
extension PeopleViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let person: PersonInfo

        switch viewModel.state {
        case .groupedByYear:
            person = viewModel.peopleGroupedByYear[indexPath.section][indexPath.row]
        case .sortedByDay:
            person = viewModel.peopleSortedByBirthday[indexPath.section][indexPath.row]
        default:
            person = viewModel.personModel[indexPath.row]
        }
        viewModel.openPersonDetails(person)
    }
}


// MARK: - Search Controller Functions
extension PeopleViewController: UISearchResultsUpdating, UISearchControllerDelegate, UISearchBarDelegate, UISheetPresentationControllerDelegate {

    func updateSearchResults(for searchController: UISearchController) {
        viewModel.setInSearchMode(searchController)
        viewModel.updateSearchController(searchBarText: searchController.searchBar.text)
        tableView.reloadData()
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel.updateSearchController(searchBarText: nil)
        viewModel.textInSearchBar = ""
        viewModel.state = .searchResultNotEmpty
        tableView.reloadData()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.updateSearchController(searchBarText: searchText)
        if let textFieldInsideSearchBar = searchController.searchBar.value(forKey: "searchField") as? UITextField,
           let glassIconView = textFieldInsideSearchBar.leftView as? UIImageView {
            glassIconView.image = glassIconView.image?.withRenderingMode(.alwaysTemplate)
            if searchText == "" {
                glassIconView.tintColor = UIColor(red: 0.765, green: 0.765, blue: 0.776, alpha: 1)
            } else {
                glassIconView.tintColor = UIColor(red: 0.02, green: 0.02, blue: 0.063, alpha: 1)
            }
        }
        viewModel.textInSearchBar = ""
        tableView.reloadData()
    }

    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        let sheet = UISheetPresentationController(
            presentedViewController: sortController, presenting: self)
        sheet.prefersGrabberVisible = true
        sheet.prefersEdgeAttachedInCompactHeight = true
        present(sortController, animated: true, completion: nil)
    }
}

// MARK: - SortViewControllerDelegate
extension PeopleViewController: SortViewControllerDelegate {
    func sortByNameTapped() {
        viewModel.sortByName(model: &viewModel.filteredPerson)
        viewModel.sortByName(model: &viewModel.downloadedPeople)
    }
    func groupByYearTapped() {
        viewModel.setGroupByYearState()
    }
    func sortByBirthdayTapped() {
        viewModel.sortByDay(model: &viewModel.filteredPerson)
        viewModel.sortByDay(model: &viewModel.downloadedPeople)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension PeopleViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let text = self.departments[indexPath.item]
        let font = UIFont.systemFont(ofSize: 20)
        let textAttributes = [NSAttributedString.Key.font: font]
        let textSize = (text as NSString).size(withAttributes: textAttributes)
        return CGSize(width: textSize.width, height: 44)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0 // Минимальное расстояние между столбцами
    }
}


// MARK: - UICollectionViewDataSource
extension PeopleViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        departments.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FilterCell.ReuseId,for: indexPath) as? FilterCell  else { return UICollectionViewCell() }

        cell.setupFilter(text: departments[indexPath.item])

        ///Подсветить выбранную ячейку
        if indexPath == selectedIndexPath {
            cell.highlight(text: departments[indexPath.item])
        } else {
            cell.unhighlight(text: departments[indexPath.item])
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndexPath = indexPath
        collectionView.reloadData()
        viewModel.filterBy(departmentName: Department.dictionary[indexPath.item]?.rawValue ?? "")
        tableView.reloadData()
    }

}
