//
//  CustomHeaderView.swift
//  People
//
//  Created by Roman Vakulenko on 20.03.2024.
//

import UIKit

final class CustomHeaderView: UITableViewHeaderFooterView {

    // MARK: - SubTypes

    private lazy var baseView: UIView = {
        let base = UIView()
        base.translatesAutoresizingMaskIntoConstraints = false
        base.backgroundColor = .clear
        return base
    }()

    lazy var yearLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = UIColor(red: 0.765, green: 0.765, blue: 0.776, alpha: 1)
        label.backgroundColor = .white
        label.font = UIFont(name: "Inter-Medium", size: 15)
        return label
    }()

    private lazy var lineView: UIView = {
        let line = UIView()
        line.translatesAutoresizingMaskIntoConstraints = false
        line.layer.borderWidth = 1
        line.layer.borderColor =  UIColor(red: 0.765, green: 0.765, blue: 0.776, alpha: 1).cgColor
        return line
    }()

    // MARK: - Init
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupView()
        setupLayout()
    }
    

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private methods
     func setupHeader(text: String) {
        yearLabel.text = text
    }

    private func setupView() {
        baseView.addSubview(lineView)
        addSubview(baseView)
        addSubview(yearLabel)
    }

    private func setupLayout() {
        NSLayoutConstraint.activate([
            baseView.leadingAnchor.constraint(equalTo: leadingAnchor),
            baseView.trailingAnchor.constraint(equalTo: trailingAnchor),
            baseView.topAnchor.constraint(equalTo: topAnchor),
            baseView.bottomAnchor.constraint(equalTo: bottomAnchor),

            lineView.leadingAnchor.constraint(equalTo: baseView.leadingAnchor, constant: 24),
            lineView.trailingAnchor.constraint(equalTo: baseView.trailingAnchor, constant: -24),
            lineView.heightAnchor.constraint(equalToConstant: 1),
            lineView.centerYAnchor.constraint(equalTo: baseView.centerYAnchor, constant: -8),

            yearLabel.centerYAnchor.constraint(equalTo: lineView.centerYAnchor),
            yearLabel.centerXAnchor.constraint(equalTo: baseView.centerXAnchor),
            yearLabel.heightAnchor.constraint(equalToConstant: 20),
            yearLabel.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/2)
        ])
    }
}
