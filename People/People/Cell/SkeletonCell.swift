//
//  SkeletonCell.swift
//  People
//
//  Created by Roman Vakulenko on 11.03.2024.
//

import UIKit

final class SkeletonCell: UITableViewCell {
    
    // MARK: - SubTypes
    private let circleView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 35
        view.backgroundColor = UIColor(red: 0.955, green: 0.955, blue: 0.965, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    var insteadOfNameView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        view.backgroundColor = UIColor(red: 0.955, green: 0.955, blue: 0.965, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    var insteadOfPositionView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 6
        view.backgroundColor = UIColor(red: 0.955, green: 0.955, blue: 0.965, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        layout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    // MARK: - Public methods
    func configure() {
    }

    // MARK: - Private methods
    private func setupView() {
        [circleView, insteadOfNameView, insteadOfPositionView].forEach { contentView.addSubview($0) }
        contentView.backgroundColor = .clear
    }

    private func layout() {
        NSLayoutConstraint.activate([
            circleView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            circleView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            circleView.heightAnchor.constraint(equalToConstant: 72),
            circleView.widthAnchor.constraint(equalToConstant: 72),

            insteadOfNameView.leadingAnchor.constraint(equalTo: circleView.leadingAnchor, constant: 88),
            insteadOfNameView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 25),
            insteadOfNameView.heightAnchor.constraint(equalToConstant: 16),
            insteadOfNameView.widthAnchor.constraint(equalToConstant: 144),

            insteadOfPositionView.leadingAnchor.constraint(equalTo: circleView.leadingAnchor, constant: 88),
            insteadOfPositionView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 47),
            insteadOfPositionView.heightAnchor.constraint(equalToConstant: 12),
            insteadOfPositionView.widthAnchor.constraint(equalToConstant: 80),
        ])

    }
}



