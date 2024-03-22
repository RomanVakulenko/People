//
//  DetailViewController.swift
//  People
//
//  Created by Roman Vakulenko on 10.03.2024.
//

import UIKit


// MARK: - DetailViewController
final class DetailViewController: UIViewController {

    // MARK: - Public properties
    let viewModel: DetailsViewModelProtocol

    // MARK: - SubTypes
    private lazy var baseview: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.backgroundColor = UIColor(red: 0.969, green: 0.969, blue: 0.973, alpha: 1)
    return view
    }()

    private lazy var avatarView: UIImageView = {
        var imageView = UIImageView()
        imageView.layer.cornerRadius = 50
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = UIColor(red: 0.02, green: 0.02, blue: 0.063, alpha: 1)
        label.font = UIFont(name: "Inter-Bold", size: 24)
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var nickNameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = UIColor(red: 0.591, green: 0.591, blue: 0.609, alpha: 1)
        label.font = UIFont(name: "Inter-Regular", size: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var positionLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = UIColor(red: 0.333, green: 0.333, blue: 0.361, alpha: 1)
        label.font = UIFont(name: "Inter-Regular", size: 13)
        label.baselineAdjustment = .alignCenters
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var starImg: UIImageView = {
        var imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "star")
        return imageView
    }()

    private lazy var birthdayLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = UIColor(red: 0.02, green: 0.02, blue: 0.063, alpha: 1)
        label.font = UIFont(name: "Inter-Medium", size: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var ageLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.textColor = UIColor(red: 0.591, green: 0.591, blue: 0.609, alpha: 1)
        label.font = UIFont(name: "Inter-Medium", size: 17)
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var phoneImg: UIImageView = {
        var imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "phone")
        return imageView
    }()

    private lazy var phoneNumberBtn: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        button.setTitleColor(UIColor(red: 0.02, green: 0.02, blue: 0.063, alpha: 1), for: .normal)
        button.addTarget(self, action: #selector(phoneNumberBtn_touchUpInside(_:)), for: .touchUpInside)
        button.titleLabel?.font = UIFont(name: "Inter-Medium", size: 20)
        return button
    }()

    private lazy var fadeView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.6)
        view.isHidden = true
        
        let blurEffect = UIBlurEffect(style: .light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(blurEffectView)
        return view
    }()

    private var number = ""

    private lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter
    }()

    // MARK: - Init
    init(viewModel: DetailsViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupLayout()
        setupNavItem()
        fillDetailsFor(viewModel.personModel)
    }

    // MARK: - Actions
    @objc func barBtnBack_touchUpInside(_ sender: UIBarButtonItem) {
        viewModel.popViewController()
    }

    @objc func phoneNumberBtn_touchUpInside(_ sender: UIButton) {
        fadeView.isHidden = false
        let actionSheet = UIAlertController(title: nil,
                                            message: nil,
                                            preferredStyle: .actionSheet)
        let callPhoneNumber = UIAlertAction(title: "\(number)", style: .default) { _ in
            self.callNumber(phoneNumber: self.number)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            self.fadeView.isHidden = true
        }
        actionSheet.addAction(callPhoneNumber)
        actionSheet.addAction(cancel)
        present(actionSheet, animated: true)
    }

    // MARK: - Public methods
    func fillDetailsFor(_ model: PersonInfo) {
        avatarView.image =  UIImage(named: model.avatarUrl)
        nameLabel.text = model.firstName + " " + model.lastName
        nickNameLabel.text = model.userTag.lowercased()
        positionLabel.text = model.position

        birthdayLabel.text = formatBirthDate(model.birthday)
        ageLabel.text = calculateAgeString(from: model.birthday)
        number = formatPhoneNumber(model.phone)
        phoneNumberBtn.setTitle(number, for: .normal)
    }

    // MARK: - Private methods
    ///telprompt:// позволяет отобразить предупреждение пользователю прямо перед звонком и по завершению возвращает в приложение, а не на homescreen, если использовать "tel://" - как пишут в habr
    private func callNumber(phoneNumber: String) {
        guard let url = URL(string: "telprompt://\(phoneNumber)"),
              UIApplication.shared.canOpenURL(url) else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }


    private func formatBirthDate(_ birthDayString: String) -> String {
        let components = makeDateComponents(birthDayString)

        var dateFormatted = ""
        if let day = components.day, let month = components.month, let year = components.year {
            let monthSymbols = dateFormatter.monthSymbols
            if let monthSymbols = monthSymbols?[month - 1] {
                dateFormatted = "\(day) \(monthSymbols) \(year)"
            }
            return dateFormatted
        }
        return dateFormatted
    }

    private func formatPhoneNumber(_ phoneNumber: String) -> String {
        let onlyDigits = phoneNumber.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        var formattedPhoneNumber = "+7"

        if onlyDigits.count == 10 {
            let countryCode = onlyDigits.prefix(3)
            let firstPart = onlyDigits.dropFirst(3).prefix(3)
            let secondPart = onlyDigits.dropFirst(6).prefix(2)
            let lastPart = onlyDigits.suffix(2)

            formattedPhoneNumber += " (\(countryCode)) \(firstPart) \(secondPart) \(lastPart)"
        }
        return formattedPhoneNumber
    }

    func calculateAgeString(from dateAsString: String) -> String {
        let components = makeDateComponents(dateAsString)
        let componentsForCurrentYear = Calendar.current.dateComponents([.day, .month, .year], from: Date())

        var ageString = ""
        if let currentYear = componentsForCurrentYear.year, let birthYear = components.year {
            let age = currentYear - birthYear
            print(age)

            let lastDigit = abs(age) % 10
            ageString = "\(age)"

            switch lastDigit {
            case 1:
                ageString += " год"
            case 2...4:
                ageString += " года"
            case 0, 5...9:
                ageString += " лет"
            default:
                break
            }
            print(ageString)
        }
        return ageString
    }

    private func makeDateComponents(_ dateAsString: String) -> DateComponents {
        guard let date = dateFormatter.date(from: dateAsString) else { return DateComponents() }
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day, .month, .year], from: date)
        return components

    }

    private func setupNavItem() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "chevron.backward"),
            style: .plain,
            target: self,
            action: #selector(barBtnBack_touchUpInside))
        navigationController?.navigationBar.tintColor = UIColor(red: 0.02, green: 0.02, blue: 0.063, alpha: 1)
    }

    private func setupView() {
        view.backgroundColor = .white
        [nameLabel, nickNameLabel].forEach { stackView.addSubview($0) }
        [avatarView, stackView, positionLabel].forEach { baseview.addSubview($0) }
        [baseview, starImg, birthdayLabel, ageLabel, phoneImg, phoneNumberBtn, fadeView].forEach { view.addSubview($0) }
    }

    private func setupLayout() {
        NSLayoutConstraint.activate([
            baseview.topAnchor.constraint(equalTo: view.topAnchor),
            baseview.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            baseview.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            baseview.heightAnchor.constraint(equalToConstant: 280),

            avatarView.topAnchor.constraint(equalTo: baseview.topAnchor, constant: 72),
            avatarView.centerXAnchor.constraint(equalTo: baseview.centerXAnchor),
            avatarView.heightAnchor.constraint(equalToConstant: 104),
            avatarView.widthAnchor.constraint(equalToConstant: 104),

            nameLabel.centerXAnchor.constraint(equalTo: avatarView.centerXAnchor, constant: -18),
            nameLabel.heightAnchor.constraint(equalToConstant: 28),

            nickNameLabel.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: 4),
            nickNameLabel.centerYAnchor.constraint(equalTo: nameLabel.centerYAnchor),

            stackView.topAnchor.constraint(equalTo: avatarView.bottomAnchor, constant: 24),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 16),
            stackView.heightAnchor.constraint(equalToConstant: 28),

            positionLabel.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 12),
            positionLabel.centerXAnchor.constraint(equalTo: avatarView.centerXAnchor),
            positionLabel.heightAnchor.constraint(equalToConstant: 20),

            starImg.topAnchor.constraint(equalTo: baseview.bottomAnchor, constant: 26),
            starImg.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            starImg.heightAnchor.constraint(equalToConstant: 24),

            birthdayLabel.centerYAnchor.constraint(equalTo: starImg.centerYAnchor),
            birthdayLabel.leadingAnchor.constraint(equalTo: starImg.trailingAnchor, constant: 16),
            birthdayLabel.heightAnchor.constraint(equalToConstant: 20),

            ageLabel.centerYAnchor.constraint(equalTo: starImg.centerYAnchor),
            ageLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            ageLabel.heightAnchor.constraint(equalToConstant: 20),

            phoneImg.topAnchor.constraint(equalTo: starImg.bottomAnchor, constant: 48),
            phoneImg.centerXAnchor.constraint(equalTo: starImg.centerXAnchor),
            phoneImg.heightAnchor.constraint(equalToConstant: 22),

            phoneNumberBtn.centerYAnchor.constraint(equalTo: phoneImg.centerYAnchor),
            phoneNumberBtn.leadingAnchor.constraint(equalTo: phoneImg.trailingAnchor, constant: 16),
            phoneNumberBtn.heightAnchor.constraint(equalToConstant: 24),

            fadeView.topAnchor.constraint(equalTo: view.topAnchor),
            fadeView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            fadeView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            fadeView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }



}
