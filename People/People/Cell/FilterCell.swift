//
//  FilterCell.swift
//  People
//
//  Created by Roman Vakulenko on 10.03.2024.
//

import UIKit

final class FilterCell: UICollectionViewCell {

    let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let underlineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.384, green: 0.211, blue: 1, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = false
        return view
    }()


    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupLayout()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }


    // MARK: - Public methods

    func setupFilter(text: String) {
        titleLabel.text = text
    }

    func highlight(text: String) {
        titleLabel.textColor = UIColor(red: 0.02, green: 0.02, blue: 0.063, alpha: 1)
        titleLabel.font = UIFont(name: "Inter-SemiBold", size: 16)
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        underlineView.isHidden = false
    }

    func unhighlight(text: String) {
        titleLabel.font = UIFont(name: "Inter-Medium", size: 16)
        titleLabel.textColor = UIColor(red: 0.591, green: 0.591, blue: 0.609, alpha: 1)
        underlineView.isHidden = true
    }



    // MARK: - Private methods
    private func setupView() {
        [titleLabel, underlineView].forEach { contentView.addSubview($0) }
    }

    private func setupLayout() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
//            titleLabel.bottomAnchor.constraint(equalTo: titleLabel.topAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -2),//44 height of collection, 8 отступ до

            underlineView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            underlineView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            underlineView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            underlineView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }

}
