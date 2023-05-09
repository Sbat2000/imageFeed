//
//  PrifleViewControllerProtocol.swift
//  ImageFeed
//
//  Created by Aleksandr Garipov on 09.05.2023.
//

import Foundation

protocol ProfileViewControllerProtocol {
    var presenter: ProfilePresenterProtocol? { get set }
    func didTapLogoutButton()
}
