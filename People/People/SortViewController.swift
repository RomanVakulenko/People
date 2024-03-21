//
//  SortViewController.swift
//  People
//
//  Created by Roman Vakulenko on 19.03.2024.
//

import UIKit


protocol SortViewControllerDelegate: AnyObject {
    func sortByNameTapped()
    func groupByYearTapped()
    func sortByBirthdayTapped()
}

class SortViewController: UIViewController {

    // MARK: - Public properties
    weak var delegate: SortViewControllerDelegate?
    var sortState: SortState = .sortByNameChoosen

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

    private lazy var radioBtnByName: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.backgroundColor = .clear
        btn.setTitleColor(UIColor(red: 0.396, green: 0.204, blue: 1, alpha: 1), for: .normal)
        btn.addTarget(self, action: #selector(radioBnt_touchUpInside(_:)), for: .touchUpInside)
        btn.setImage(UIImage(named: "radio_off"), for: .normal)
        btn.setImage(UIImage(named: "radio_on"), for: .selected)
        return btn
    }()

    private lazy var sortLblBirthDay: UILabel = {
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

    private lazy var radioBntByBirthday: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.backgroundColor = .clear
        btn.setTitleColor(UIColor(red: 0.396, green: 0.204, blue: 1, alpha: 1), for: .normal)
        btn.addTarget(self, action: #selector(radioBnt_touchUpInside(_:)), for: .touchUpInside)
        btn.setImage(UIImage(named: "radio_off"), for: .normal)
        btn.setImage(UIImage(named: "radio_on"), for: .selected)
        return btn
    }()

    private lazy var sortLblGroupByYear: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.textColor = UIColor(red: 0.02, green: 0.02, blue: 0.063, alpha: 1)
        label.font = UIFont(name: "Inter-Medium", size: 16)
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.03
        label.attributedText = NSMutableAttributedString(string: "Группировка по году, убывание", attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
        return label
    }()

    private lazy var radioBtnGroupByYear: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.backgroundColor = .clear
        btn.setTitleColor(UIColor(red: 0.396, green: 0.204, blue: 1, alpha: 1), for: .normal)
        btn.addTarget(self, action: #selector(radioBnt_touchUpInside(_:)), for: .touchUpInside)
        btn.setImage(UIImage(named: "radio_off"), for: .normal)
        btn.setImage(UIImage(named: "radio_on"), for: .selected)
        return btn
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
        if sender == radioBtnByName {
            radioBtnByName.isSelected = true
            radioBtnGroupByYear.isSelected = false
            radioBntByBirthday.isSelected = false
            delegate?.sortByNameTapped()
        }
        if sender == radioBtnGroupByYear {
            radioBtnByName.isSelected = false
            radioBtnGroupByYear.isSelected = true
            radioBntByBirthday.isSelected = false
            delegate?.groupByYearTapped()
        }
        if sender == radioBntByBirthday {
            radioBtnByName.isSelected = false
            radioBtnGroupByYear.isSelected = false
            radioBntByBirthday.isSelected = true
            delegate?.sortByBirthdayTapped()
        }
        backBtn_touchUpInside(sender)
    }

    @objc func backBtn_touchUpInside(_ sender: UIButton)  {
        self.dismiss(animated: true, completion: nil)
    }

    // MARK: - Private methods

    private func setSortBtnDueToState() {
        if sortState == .sortByNameChoosen {
            radioBtnByName.isSelected = true
            radioBtnGroupByYear.isSelected = false
            radioBntByBirthday.isSelected = false
        }
        if sortState == .groupByYearChoosen {
            radioBtnByName.isSelected = false
            radioBtnGroupByYear.isSelected = true
            radioBntByBirthday.isSelected = false
        }
        if sortState == .sortByBirthdayChoosen {
            radioBtnByName.isSelected = false
            radioBtnGroupByYear.isSelected = false
            radioBntByBirthday.isSelected = true
        }
    }

    private func setupView() {
        [titleLabel, backBtn, radioBtnByName, radioBtnGroupByYear, sortLblName, sortLblGroupByYear, sortLblBirthDay, radioBntByBirthday].forEach { view.addSubview($0) }
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

            radioBtnByName.topAnchor.constraint(equalTo: view.topAnchor, constant: 84),
            radioBtnByName.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            radioBtnByName.heightAnchor.constraint(equalToConstant: 24),
            radioBtnByName.widthAnchor.constraint(equalToConstant: 24),

            sortLblName.centerYAnchor.constraint(equalTo: radioBtnByName.centerYAnchor, constant: -1),
            sortLblName.leadingAnchor.constraint(equalTo: radioBtnByName.trailingAnchor, constant: 20),
            sortLblName.heightAnchor.constraint(equalToConstant: 20),

            radioBtnGroupByYear.topAnchor.constraint(equalTo: radioBtnByName.topAnchor, constant: 36),
            radioBtnGroupByYear.leadingAnchor.constraint(equalTo: radioBtnByName.leadingAnchor),
            radioBtnGroupByYear.heightAnchor.constraint(equalToConstant: 24),
            radioBtnGroupByYear.widthAnchor.constraint(equalToConstant: 24),

            sortLblGroupByYear.centerYAnchor.constraint(equalTo: radioBtnGroupByYear.centerYAnchor, constant: -1),
            sortLblGroupByYear.leadingAnchor.constraint(equalTo: radioBtnGroupByYear.trailingAnchor, constant: 20),
            sortLblGroupByYear.heightAnchor.constraint(equalToConstant: 20),

            radioBntByBirthday.topAnchor.constraint(equalTo: radioBtnGroupByYear.topAnchor, constant: 36),
            radioBntByBirthday.leadingAnchor.constraint(equalTo: radioBtnGroupByYear.leadingAnchor),
            radioBntByBirthday.heightAnchor.constraint(equalToConstant: 24),
            radioBntByBirthday.widthAnchor.constraint(equalToConstant: 24),

            sortLblBirthDay.centerYAnchor.constraint(equalTo: radioBntByBirthday.centerYAnchor, constant: -1),
            sortLblBirthDay.leadingAnchor.constraint(equalTo: radioBntByBirthday.trailingAnchor, constant: 20),
            sortLblBirthDay.heightAnchor.constraint(equalToConstant: 20),

        ])
    }
}
