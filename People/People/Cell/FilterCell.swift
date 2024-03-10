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
        return label
    }()

    let underlineView: UIView = {
        let view = UIView()
        view.backgroundColor = Constants.underlineViewColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(titleLabel)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])

       addSubview(underlineView)

       NSLayoutConstraint.activate([
           underlineView.heightAnchor.constraint(equalToConstant: Constants.underlineViewHeight),
           underlineView.leadingAnchor.constraint(equalTo: leadingAnchor),
           underlineView.trailingAnchor.constraint(equalTo: trailingAnchor),
           underlineView.bottomAnchor.constraint(equalTo: bottomAnchor),
           underlineView.isHidden = true // Initially hidden until selected
       ])
   }

   required init?(coder aDecoder: NSCoder) {
       fatalError("init(coder:) has not been implemented")
   }
}
