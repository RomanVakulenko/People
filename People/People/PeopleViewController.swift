//
//  PeopleViewController.swift
//  People
//
//  Created by Roman Vakulenko on 10.03.2024.
//

import UIKit

final class PeopleViewController: UIViewController {

    let viewModel: DownloadViewModel
    let departments = ["Все", "Designers", "Analytics", "Managers", "Android", "iOS", "Qa", "Back_office", "Frontender", "HR", "PR", "Backend", "Support"]
    var selectedIndexPath = IndexPath(item: 0, section: 0)


    // MARK: - Private properties
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
        collectionView.register(FilterCell.self, forCellWithReuseIdentifier: FilterCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()


    // MARK: - Init
    init(viewModel: DownloadViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupFilterAsCollection()
        view.backgroundColor = .white
    }


    // MARK: - Private methods

    private func setupFilterAsCollection() {
        view.addSubview(collectionView)

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 52),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            collectionView.heightAnchor.constraint(equalToConstant: 44)
        ])
    }

}

// MARK: - UICollectionViewDataSource
extension PeopleViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        departments.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FilterCell.identifier,for: indexPath) as? FilterCell else { return UICollectionViewCell() }

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


