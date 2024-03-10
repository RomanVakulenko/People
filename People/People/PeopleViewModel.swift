//
//  PeopleViewModel.swift
//  People
//
//  Created by Roman Vakulenko on 10.03.2024.
//

import UIKit

protocol DownloadProtocol: AnyObject {
    func downloadAndSavePeopleInfo(at url: URL)
}

// MARK: - Enum
enum State {
    case none
    case loading
    case refreshing
    case loadedAndSaved
    case allPeople
    case sortByAlphabet
    case sortByBirthDay
    case error(alertText: String)
}

final class DownloadViewModel {

    // MARK: - Public properties
    var closureChangingState: ((State) -> Void)?
    let fManager: LocalFilesManagerProtocol

    var state: State = .none {
        didSet {
            closureChangingState?(state)
        }
    }

    var fileName: String?
    var photoURL: URL?

    // MARK: - Private properties
    private weak var coordinator: PeopleFlowCoordinatorProtocol?
    private let networkService: YTNetworkServiceProtocol


    // MARK: - Init
    init(coordinator: PeopleFlowCoordinatorProtocol, networkService: YTNetworkServiceProtocol, fManager: LocalFilesManagerProtocol) {
        self.coordinator = coordinator
        self.networkService = networkService
        self.fManager = fManager
    }

    // MARK: - Public methods
    func showSecondVC() {
        coordinator?.pushSecondVC(emptyVideoDelegate: self)
    }
}


// MARK: - DownloadProtocol
extension DownloadViewModel: DownloadProtocol {

    func downloadAndSavePeopleInfo(at url: URL) {
        state = .loading //сразу после того как нажали на download

        do {
            try self.networkService.downloadAndSaveVideo(videoIdentifier: videoID, videoURL: url)

            fManager.statusClosure = { [weak self] status in
                switch status {
                case .fileExists:
                    self?.state = .fileExists

                case .loading:
                    self?.state = .loading

                case .loadedAndSaved:
                    self?.state = .loadedAndSaved

                case .badURL(alertText: let alertTextForUser):
                    self?.state = .badURL(alertText: alertTextForUser)
//  ДОП ЗАДАНИЕ: Ошибка сетевого соединения (timeout, HTTP-статус 5xx и т.п.). В этом случае в уведомлении текст "Не могу обновить данные. Проверь соединение с интернетом"
//  Ошибка от сервера (HTTP-статус 4xx) или ошибка при парсинге данных. В этом случае в уведомлении текст "Не могу обновить данные. Что-то пошло не так".
//  Уведомление закрывает собой статус-бар. Оно должно скрываться спустя 3 секунды само, но его можно также убрать тапом.

                default: print("зашел в дефолтный кейс fManagerА")
                }
            }
        } catch let error as URLError {
            if error.networkUnavailableReason == .cellular {
                self.state = .error(alertText: "Сотовая сеть отключена")
            } else if let reason = error.networkUnavailableReason {
                self.state = .error(alertText: "Сеть недоступна: \(reason)")
            }
            switch error.code {
            case .notConnectedToInternet:
                self.state = .error(alertText: "Не могу обновить данные. Проверь соединение с интернетом")
            default:
                print("Неизвестная ошибка типа URLError")
                self.state = .error(alertText: "Некорректный URL")
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}

// MARK: - EmptyVideoDelegateProtocol
extension DownloadViewModel: EmptyVideoDelegateProtocol {

    func organizeAlertOfNoVideo() {
        self.state = .thereIsNoAnyVideo
    }

}
