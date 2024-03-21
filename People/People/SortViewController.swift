//
//  SortViewController.swift
//  People
//
//  Created by Roman Vakulenko on 19.03.2024.
//

import UIKit


protocol SortViewControllerDelegate: AnyObject {
    func sortByName()
    func sortByDate()
}

class SortViewController: UIViewController {

    // MARK: - Public properties
    weak var delegate: SortViewControllerDelegate?
    var sortState: SortState = .sortedByName

    // MARK: - SubTypes
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(red: 0.02, green: 0.02, blue: 0.063, alpha: 1)
        label.font = UIFont(name: "Inter-SemiBold", size: 20)
        label.font = UIFont.boldSystemFont(ofSize: 20)
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 0.99
        label.textAlignment = .center
        label.attributedText = NSMutableAttributedString(string: "Сортировка", attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
        return label
    }()

    private lazy var backBtn: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.backgroundColor = .clear
        btn.setTitleColor(UIColor(red: 0.02, green: 0.02, blue: 0.063, alpha: 1), for: .normal)
        btn.addTarget(self, action: #selector(backBtn_touchUpInside(_:)), for: .touchUpInside)
        btn.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        btn.tintColor = UIColor(red: 0.02, green: 0.02, blue: 0.063, alpha: 1)
        return btn
    }()

    private lazy var radioBntByName: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.backgroundColor = .clear
        btn.setTitleColor(UIColor(red: 0.396, green: 0.204, blue: 1, alpha: 1), for: .normal)
        btn.addTarget(self, action: #selector(radioBnt_touchUpInside(_:)), for: .touchUpInside)
        btn.setImage(UIImage(named: "radio_off"), for: .normal)
        btn.setImage(UIImage(named: "radio_on"), for: .selected)
        return btn
    }()

    private lazy var radioBntByDate: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.backgroundColor = .clear
        btn.setTitleColor(UIColor(red: 0.396, green: 0.204, blue: 1, alpha: 1), for: .normal)
        btn.addTarget(self, action: #selector(radioBnt_touchUpInside(_:)), for: .touchUpInside)
        btn.setImage(UIImage(named: "radio_off"), for: .normal)
        btn.setImage(UIImage(named: "radio_on"), for: .selected)
        return btn
    }()

    private lazy var sortLblName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.textColor = UIColor(red: 0.02, green: 0.02, blue: 0.063, alpha: 1)
        label.font = UIFont(name: "Inter-Medium", size: 16)
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.03
        label.attributedText = NSMutableAttributedString(string: "По алфавиту", attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
        return label
    }()

    private lazy var sortLblDay: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.textColor = UIColor(red: 0.02, green: 0.02, blue: 0.063, alpha: 1)
        label.font = UIFont(name: "Inter-Medium", size: 16)
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.03
        label.attributedText = NSMutableAttributedString(string: "По дню рождения", attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
        return label
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupView()
        setupLayout()
        setSortBtnDueToState()
    }

    // MARK: - Actions
    @objc func radioBnt_touchUpInside(_ sender: UIButton) {
        if sender == radioBntByName {
            radioBntByName.isSelected = true
            radioBntByDate.isSelected = false
            delegate?.sortByName()
            backBtn_touchUpInside(sender)
        } else {
            radioBntByName.isSelected = false
            radioBntByDate.isSelected = true
            delegate?.sortByDate()
            backBtn_touchUpInside(sender)
        }
    }

    @objc func backBtn_touchUpInside(_ sender: UIButton)  {
        self.dismiss(animated: true, completion: nil)
    }

    // MARK: - Private methods

    private func setSortBtnDueToState() {
        if sortState == .sortedByName {
            radioBntByName.isSelected = true
            radioBntByDate.isSelected = false
        } else {
            radioBntByName.isSelected = false
            radioBntByDate.isSelected = true
        }
    }

    private func setupView() {
        [titleLabel, backBtn, radioBntByName, radioBntByDate, sortLblName, sortLblDay].forEach { view.addSubview($0) }
    }

    private func setupLayout() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 16),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 24),
            
            backBtn.topAnchor.constraint(equalTo: view.topAnchor, constant: 16),
            backBtn.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 18),
            backBtn.heightAnchor.constraint(equalToConstant: 24),
            backBtn.widthAnchor.constraint(equalToConstant: 24),

            radioBntByName.topAnchor.constraint(equalTo: view.topAnchor, constant: 84),
            radioBntByName.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            radioBntByName.heightAnchor.constraint(equalToConstant: 24),
            radioBntByName.widthAnchor.constraint(equalToConstant: 24),

            sortLblName.centerYAnchor.constraint(equalTo: radioBntByName.centerYAnchor, constant: -1),
            sortLblName.leadingAnchor.constraint(equalTo: radioBntByName.trailingAnchor, constant: 20),
            sortLblName.heightAnchor.constraint(equalToConstant: 20),

            radioBntByDate.topAnchor.constraint(equalTo: radioBntByName.topAnchor, constant: 36),
            radioBntByDate.leadingAnchor.constraint(equalTo: radioBntByName.leadingAnchor),
            radioBntByDate.heightAnchor.constraint(equalToConstant: 24),
            radioBntByDate.widthAnchor.constraint(equalToConstant: 24),

            sortLblDay.centerYAnchor.constraint(equalTo: radioBntByDate.centerYAnchor, constant: -1),
            sortLblDay.leadingAnchor.constraint(equalTo: radioBntByDate.trailingAnchor, constant: 20),
            sortLblDay.heightAnchor.constraint(equalToConstant: 20),
        ])
    }
}
