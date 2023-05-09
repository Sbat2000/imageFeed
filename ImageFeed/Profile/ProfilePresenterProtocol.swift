//
//  ProfilePresenterProtocol.swift
//  ImageFeed
//
//  Created by Aleksandr Garipov on 09.05.2023.
//

import Foundation

protocol ProfilePresenterProtocol {
    var delegate: ProfilePresenterDelegate? { get set }
    func showLogoutAlert()
    func clean()
}
