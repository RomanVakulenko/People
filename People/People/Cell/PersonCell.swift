//
//  PersonCell.swift
//  People
//
//  Created by Roman Vakulenko on 11.03.2024.
//

import UIKit

final class PersonCell: UITableViewCell {

    // MARK: - SubTypes
    private lazy var avatarView: UIImageView = {
        var imageView = UIImageView()
        imageView.layer.cornerRadius = 35
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 4
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(nickNameLabel)
        return stackView
    }()

    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = UIColor(red: 0.02, green: 0.02, blue: 0.063, alpha: 1)
        label.font = UIFont(name: "Inter-Medium", size: 16)
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var nickNameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = UIColor(red: 0.591, green: 0.591, blue: 0.609, alpha: 1)
        label.font = UIFont(name: "Inter-Medium", size: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var positionLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = UIColor(red: 0.333, green: 0.333, blue: 0.361, alpha: 1)
        label.font = UIFont(name: "Inter-Regular", size: 13)
        label.baselineAdjustment = .alignCenters
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var birthdayLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.textColor = UIColor(red: 0.333, green: 0.333, blue: 0.361, alpha: 1)
        label.font = UIFont(name: "Inter-Regular", size: 15)
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()


    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        setupLayout()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }


    // MARK: - Public methods
    func fill(with model: PersonInfo) {
        avatarView.image = UIImage(named: model.avatarUrl) //cкачивать, сохранять и показывать
        nameLabel.text = model.firstName + " " + model.lastName
        nickNameLabel.text = model.userTag.lowercased()
        positionLabel.text = model.position
        birthdayLabel.text = model.birthday

        layoutIfNeeded()
    }


    // MARK: - Private methods
    private func setupView() {
        [avatarView, stackView, positionLabel, birthdayLabel].forEach { contentView.addSubview($0) }
    }

    private func setupLayout() {

        NSLayoutConstraint.activate([
            avatarView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            avatarView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            avatarView.heightAnchor.constraint(equalToConstant: 72),
            avatarView.widthAnchor.constraint(equalToConstant: 72),

            stackView.leadingAnchor.constraint(equalTo: avatarView.leadingAnchor, constant: 88),
            stackView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 20),

            positionLabel.leadingAnchor.constraint(equalTo: avatarView.leadingAnchor, constant: 88),
            positionLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 44),
            positionLabel.heightAnchor.constraint(equalToConstant: 20),
            positionLabel.trailingAnchor.constraint(equalTo: birthdayLabel.leadingAnchor, constant: -48),

            birthdayLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            birthdayLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            birthdayLabel.heightAnchor.constraint(equalToConstant: 48),
            birthdayLabel.widthAnchor.constraint(equalToConstant: 64)
        ])
    }

}
