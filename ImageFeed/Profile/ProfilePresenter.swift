//
//  ProfilePresenter.swift
//  ImageFeed
//
//  Created by Aleksandr Garipov on 09.05.2023.
//

import Foundation
import WebKit

final class ProfilePresenter: ProfilePresenterProtocol {
    
    private weak var delegate: ProfilePresenterDelegate?
    private var profileImageServiceObserver: NSObjectProtocol?
    private let profileService = ProfileService.shared
    private let authToken = OAuth2TokenStorage().token ?? "nil"
    
    init(delegate: ProfilePresenterDelegate) {
        self.delegate = delegate
        setupObserver()
        setupProfile()
        setupAvatar()
    }
    
    func logoutButtonPressed() {
        let alert = Alert(id: "logoutAlert", title: "Пока, пока!",
                          message: "Уверены, что хотите выйти?",
                          buttons: [
                            .default(text: "Да", id: "Yes", action: { [weak self] in
                                guard let self else { return }
                                OAuth2TokenStorage().deleteToken()
                                self.clean()
                                delegate?.showSplashVC()
                                
        }),
                            .cancel(text: "Нет", action: nil)
                          ])
        delegate?.presentAlert(alert: alert)
    }
    
    private func clean() {
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record]) {}
            }
        }
        ImagesListService.shared.deletePhotos()
    }
    
    private func setupObserver() {
        profileImageServiceObserver = NotificationCenter.default.addObserver(
            forName: ProfileImageService.DidChangeNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            guard let self = self else { return }
            self.setupAvatar()
        }
    }
    
    private func setupProfile() {
        guard let profile = profileService.profile else { return }
        delegate?.setupProfile(profile: profile)
    }
    
    private func setupAvatar() {
        guard
            let profileImageUrl = ProfileImageService.shared.avatarURL,
            let url = URL(string: profileImageUrl)
        else { return }
        delegate?.updateAvatar(url: url)
    }
}




