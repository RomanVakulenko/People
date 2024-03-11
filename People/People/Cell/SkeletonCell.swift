//
//  SkeletonCell.swift
//  People
//
//  Created by Roman Vakulenko on 11.03.2024.
//

import UIKit

final class SkeletonCell: UITableViewCell {

    private let circleView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = false
        view.layer.shadowOpacity = 0.25
        view.layer.shadowOffset = CGSize(width: 1, height: 2)
        view.layer.shadowRadius = 2

        view.frame = CGRect(x: 0, y: 0, width: 72, height: 72)
        let layer0 = CAGradientLayer()
        layer0.colors = [
            UIColor(red: 0.955, green: 0.955, blue: 0.965, alpha: 1).cgColor,
            UIColor(red: 0.979, green: 0.979, blue: 0.981, alpha: 1).cgColor
        ]
        layer0.locations = [0, 1]
        layer0.startPoint = CGPoint(x: 0.25, y: 0.5)
        layer0.endPoint = CGPoint(x: 0.75, y: 0.5)
        layer0.transform = CATransform3DMakeAffineTransform(
            CGAffineTransform(a: 1, b: 0, c: 0, d: 3.08, tx: 0, ty: -1.54))
        layer0.bounds = view.bounds.insetBy(dx: -0.5*view.bounds.size.width, dy: -0.5*view.bounds.size.height)
        layer0.position = view.center
        view.layer.addSublayer(layer0)
        view.layer.cornerRadius = 50

        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()


    var insteadOfNameView: UIView = {
        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: 144, height: 16)
        let layer0 = CAGradientLayer()
        layer0.colors = [
            UIColor(red: 0.955, green: 0.955, blue: 0.965, alpha: 1).cgColor,
            UIColor(red: 0.979, green: 0.979, blue: 0.981, alpha: 1).cgColor
        ]
        layer0.locations = [0, 1]
        layer0.startPoint = CGPoint(x: 0.25, y: 0.5)
        layer0.endPoint = CGPoint(x: 0.75, y: 0.5)
        layer0.transform = CATransform3DMakeAffineTransform(
            CGAffineTransform(a: 1, b: 0, c: 0, d: 3.08, tx: 0, ty: -1.54))
        layer0.bounds = view.bounds.insetBy(dx: -0.5*view.bounds.size.width, dy: -0.5*view.bounds.size.height)
        layer0.position = view.center
        view.layer.addSublayer(layer0)
        view.layer.cornerRadius = 50

        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()


    var insteadOfPositionView: UIView = {
        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: 80, height: 12)
        let layer0 = CAGradientLayer()
        layer0.colors = [
            UIColor(red: 0.955, green: 0.955, blue: 0.965, alpha: 1).cgColor,
            UIColor(red: 0.979, green: 0.979, blue: 0.981, alpha: 1).cgColor
        ]
        layer0.locations = [0, 1]
        layer0.startPoint = CGPoint(x: 0.25, y: 0.5)
        layer0.endPoint = CGPoint(x: 0.75, y: 0.5)
        layer0.transform = CATransform3DMakeAffineTransform(
            CGAffineTransform(a: 1, b: 0, c: 0, d: 3.08, tx: 0, ty: -1.54))
        layer0.bounds = view.bounds.insetBy(dx: -0.5*view.bounds.size.width, dy: -0.5*view.bounds.size.height)
        layer0.position = view.center
        view.layer.addSublayer(layer0)
        view.layer.cornerRadius = 50

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

    // MARK: - Private methods
    private func setupView() {
        [circleView, insteadOfNameView, insteadOfPositionView].forEach { contentView.addSubview($0) }
        contentView.backgroundColor = .clear
    }

    private func layout() {
        NSLayoutConstraint.activate([
            circleView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            circleView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 78), //152+12+6-52-44
            circleView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
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



