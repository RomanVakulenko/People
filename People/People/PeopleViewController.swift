//
//  PeopleViewController.swift
//  People
//
//  Created by Roman Vakulenko on 10.03.2024.
//

import UIKit

enum SkeletonState {
    case skeleton
    case not
}

final class PeopleViewController: UIViewController {

    // MARK: - Public properties
    let viewModel: PeopleViewModel
    let departments = ["Все", "Designers", "Analysts", "Managers", "Android", "iOS", "QA", "Back_office", "Frontenders", "HR", "PR", "Backenders", "Support"]
    var selectedIndexPath = IndexPath(item: 0, section: 0)


    // MARK: - SubTypes
    private let searchController = UISearchController(searchResultsController: nil)

    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .medium)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.color = UIColor(red: 0.591, green: 0.591, blue: 0.609, alpha: 1)
        return spinner
    }()

    private lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(SkeletonCell.self, forCellReuseIdentifier: SkeletonCell.ReuseId)
        tableView.register(PersonCell.self, forCellReuseIdentifier: PersonCell.ReuseId)
        tableView.backgroundColor = .clear
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 84
        tableView.separatorStyle = .none
        return tableView
    }()

    private lazy var errorView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var errorImg: UIImageView = {
        var imageView = UIImageView()
        imageView.image = UIImage(named: "errorPic")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private lazy var boldLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = UIColor(red: 0.02, green: 0.02, blue: 0.063, alpha: 1)
        label.font = UIFont(name: "Inter-SemiBold", size: 17)
        label.font = UIFont.boldSystemFont(ofSize: 17)
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.07
        label.attributedText = NSMutableAttributedString(string: "Какой-то сверхразум все сломал", attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var regularLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = UIColor(red: 0.591, green: 0.591, blue: 0.609, alpha: 1)
        label.font = UIFont(name: "Inter-Regular", size: 16)
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.03
        label.attributedText = NSMutableAttributedString(string: "Постараемся быстро починить", attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var tryAgainBtn: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .clear
        btn.setTitleColor(UIColor(red: 0.396, green: 0.204, blue: 1, alpha: 1), for: .normal)
        btn.titleLabel?.font = UIFont(name: "Inter-SemiBold", size: 16)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        btn.titleLabel?.textAlignment = .center
        let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineHeightMultiple = 1.03
        let attributedString = NSMutableAttributedString(string: "Попробовать снова", attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
        btn.setAttributedTitle(attributedString, for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
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

    private var skeletonState: SkeletonState = .skeleton

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
        view.backgroundColor = .white
        setupSearchController()
        setupFilterAsCollectionAndTableView()
        bindViewModel()
        viewModel.downloadAndSavePeopleInfo()
    }


    // MARK: - Actions
    @objc func tryAgainBtn_touchUpInside(_ sender: UIButton) {
        viewModel.downloadAndSavePeopleInfo()
    }

    // MARK: - Private methods
    private func bindViewModel() {
        viewModel.closureChangingState = { [weak self] state in
            guard let strongSelf = self else { return }

            switch state {
            case .none:
                ()
            case .loading:
                ()
            case .refreshing:
                ()
            case .loadedAndSaved:
                strongSelf.skeletonState = .not
                strongSelf.tableView.reloadData()
            case .allPeople:
                ()
            case .sortByAlphabet:
                ()
            case .sortByBirthDay:
                ()
            case .error(alertText: _):
                strongSelf.setupErrorView()
            }
        }
    }

    private func setupSearchController() {
           self.searchController.searchResultsUpdater = self
           self.searchController.obscuresBackgroundDuringPresentation = false
           self.searchController.hidesNavigationBarDuringPresentation = false
           self.searchController.searchBar.placeholder = "Введите имя, тег, почту..."

           self.navigationItem.searchController = searchController
           self.definesPresentationContext = false
           self.navigationItem.hidesSearchBarWhenScrolling = false

           searchController.delegate = self
           searchController.searchBar.delegate = self
           searchController.searchBar.showsBookmarkButton = true
           searchController.searchBar.setImage(UIImage(systemName: "line.horizontal.3.decrease"), for: .bookmark, state: .normal)
       }

    private func setupFilterAsCollectionAndTableView() {
        [collectionView, spinner, tableView].forEach { view.addSubview($0) }

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            collectionView.heightAnchor.constraint(equalToConstant: 44),
            //пока не уверен - возможно надо будет делать 2ой набор констрейнтов
            spinner.bottomAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 8),
            spinner.centerXAnchor.constraint(equalTo: collectionView.centerXAnchor),

            tableView.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    private func setupErrorView() {
        [errorImg, boldLabel, regularLabel, tryAgainBtn].forEach{ errorView.addSubview($0) }
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

            boldLabel.topAnchor.constraint(equalTo: errorImg.bottomAnchor, constant: 8),
            boldLabel.centerXAnchor.constraint(equalTo: errorView.centerXAnchor),
            boldLabel.heightAnchor.constraint(equalToConstant: 22),

            regularLabel.topAnchor.constraint(equalTo: boldLabel.bottomAnchor, constant: 12),
            regularLabel.centerXAnchor.constraint(equalTo: errorView.centerXAnchor),
            regularLabel.heightAnchor.constraint(equalToConstant: 20),

            tryAgainBtn.topAnchor.constraint(equalTo: regularLabel.bottomAnchor, constant: 12),
            tryAgainBtn.centerXAnchor.constraint(equalTo: errorView.centerXAnchor),
            tryAgainBtn.heightAnchor.constraint(equalToConstant: 20)
        ])
    }

}

// MARK: - UITableViewDataSource
extension PeopleViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if viewModel.state != .loadedAndSaved {
            return 10
        } else {
            return self.viewModel.personModel.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PersonCell.ReuseId, for: indexPath) as? PersonCell,
              let skeletonCell = tableView.dequeueReusableCell(withIdentifier: SkeletonCell.ReuseId, for: indexPath) as? SkeletonCell else {
            return UITableViewCell() }

        if skeletonState == .skeleton {
            return skeletonCell
        } else {
            let model = viewModel.personModel[indexPath.item]
            cell.fill(with: model)
            return cell
        }
    }
}

// MARK: - UITableViewDelegate
extension PeopleViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didTapCell(at: indexPath)
    }
}


// MARK: - Search Controller Functions
extension PeopleViewController: UISearchResultsUpdating, UISearchControllerDelegate, UISearchBarDelegate  {

    func updateSearchResults(for searchController: UISearchController) {
        self.viewModel.setInSearchMode(searchController)
        self.viewModel.updateSearchController(searchBarText: searchController.searchBar.text)
        tableView.reloadData()
    }

    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        print("Search bar button called!") //тут можно вызвать фильтр
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension PeopleViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let text = departments[indexPath.item]
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
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FilterCell.ReuseId,for: indexPath) as? FilterCell else { return UICollectionViewCell() }

        cell.setupFilter(text: self.departments[indexPath.item])

        //Подсветить выбранную ячейку
        if indexPath == selectedIndexPath {
            cell.highlight(text: self.departments[indexPath.item])
        } else {
            cell.unhighlight(text: self.departments[indexPath.item])
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedIndexPath = indexPath
        collectionView.reloadData()
        //написать логику фильтрации
    }

}
