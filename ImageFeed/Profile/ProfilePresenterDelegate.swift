//
//  ProfilePresenterDelegate.swift
//  ImageFeed
//
//  Created by Aleksandr Garipov on 09.05.2023.
//

import UIKit

protocol ProfilePresenterDelegate: AnyObject {
    func presentAlert(alert: Alert)
    func showSplashVC()
    func updateAvatar(url: URL)
    func setupProfile(profile: Profile)
}
