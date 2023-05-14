//
//  ProfilePresenter.swift
//  ImageFeed
//
//  Created by Aleksandr Garipov on 09.05.2023.
//

import UIKit
import WebKit

final class ProfilePresenter: ProfilePresenterProtocol {
    
    var delegate: ProfilePresenterDelegate?
    
    func showLogoutAlert() {
        let alert = UIAlertController(title: "Пока, пока!", message: "Уверены, что хотите выйти?", preferredStyle: .alert)
        alert.view.accessibilityIdentifier = "logoutAlert"
        let yesAction = UIAlertAction(title: "Да", style: .default) { _ in
            OAuth2TokenStorage().deleteToken()
            self.clean()
            alert.dismiss(animated: true)
            let splashVC = SplashViewController()
            splashVC.isFirstAppear = true
            if let window = UIApplication.shared.windows.first {
                window.rootViewController = splashVC
                window.makeKeyAndVisible()
            }
        }
        yesAction.accessibilityIdentifier = "Yes"
        let noAction = UIAlertAction(title: "Нет",
                                     style: .default) {_ in
            alert.dismiss(animated: true)
            
        }
        alert.addAction(yesAction)
        alert.addAction(noAction)
        delegate?.presentAlert(alert: alert)
    }
    
    func clean() {
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record]) {}
            }
        }
        ImagesListService.shared.deletePhotos()
    }
}




