//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Aleksandr Garipov on 03.03.2023.
//

import UIKit
import Kingfisher
import WebKit

final class ProfileViewController: UIViewController, ProfileViewControllerProtocol {

    var presenter: ProfilePresenterProtocol?
    
    private lazy var avatarImage: UIImageView = {
        let image = UIImageView()
        image.image = Resources.Images.Profile.defaultAvatar
        image.translatesAutoresizingMaskIntoConstraints = false
        image.layer.cornerRadius = 35
        image.layer.masksToBounds = true
        return image
    }()
    
    private lazy var logoutButton: UIButton = {
        let imageButton = Resources.Images.Profile.logoutButtonImage
        let button = UIButton.systemButton(
            with: imageButton!,
            target: self,
            action: #selector(Self.didTapLogoutButton))
        button.tintColor = Resources.Colors.ypRed
        button.accessibilityIdentifier = "logoutButton"
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Екатерина Новикова"
        label.textColor = Resources.Colors.ypWhite
        label.font = UIFont.systemFont(ofSize: 23, weight: UIFont.Weight.bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var loginLabel: UILabel = {
        let label = UILabel()
        label.text = "@ekaterina_nov"
        label.textColor = Resources.Colors.ypGray
        label.font = UIFont.systemFont(ofSize: 13, weight: UIFont.Weight.regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Hello, world!"
        label.textColor = Resources.Colors.ypWhite
        label.font = UIFont.systemFont(ofSize: 13, weight: UIFont.Weight.regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        let profilePresenter = ProfilePresenter(delegate: self)
        self.presenter = profilePresenter
        super.viewDidLoad()
        setupUI()
        layout()
    }
    
    func setupUI() {
        view.backgroundColor = Resources.Colors.ypBlack
        [avatarImage, logoutButton, nameLabel, loginLabel, descriptionLabel].forEach {view.addSubview($0)}
    }
    
    func layout() {
        NSLayoutConstraint.activate([
            avatarImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 76),
            avatarImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            avatarImage.heightAnchor.constraint(equalToConstant: 70),
            avatarImage.widthAnchor.constraint(equalToConstant: 70),
            
            logoutButton.centerYAnchor.constraint(equalTo: avatarImage.centerYAnchor),
            logoutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -26),
            
            nameLabel.leadingAnchor.constraint(equalTo: avatarImage.leadingAnchor),
            nameLabel.topAnchor.constraint(equalTo: avatarImage.bottomAnchor, constant: 8),
            
            loginLabel.leadingAnchor.constraint(equalTo: avatarImage.leadingAnchor),
            loginLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            
            descriptionLabel.leadingAnchor.constraint(equalTo: avatarImage.leadingAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: loginLabel.bottomAnchor, constant: 8),
        ])
    }
    
    @objc internal func didTapLogoutButton() {
        presenter?.logoutButtonPressed()
    }
    
}

extension ProfileViewController: ProfilePresenterDelegate {
    
    func showSplashVC() {
        let splashVC = SplashViewController()
        splashVC.isFirstAppear = true
        if let window = UIApplication.shared.windows.first {
            window.rootViewController = splashVC
            window.makeKeyAndVisible()
        }
    }
    
    func presentAlert(alert: Alert) {
        let alertController = UIAlertController(title: alert.title,
                                                message: alert.message,
                                                preferredStyle: .alert)
        alertController.view.accessibilityIdentifier = alert.id
        
        alert.buttons.forEach{
            switch $0 {
            case .cancel(let text, let id, let action):
                let action = UIAlertAction(title: text, style: .cancel, handler: { _ in
                    action?()
                })
                action.accessibilityIdentifier = id
                alertController.addAction(action)
            case .default(let text, let id, let action):
                let action = UIAlertAction(title: text, style: .default, handler: { _ in
                    action?()
                })
                action.accessibilityIdentifier = id
                alertController.addAction(action)
            }
        }
        present(alertController, animated: true)
    }
    
    func updateAvatar(url: URL) {
        avatarImage.kf.setImage(with: url,
                                placeholder: Resources.Images.Profile.defaultAvatar,
                                options: [])
    }
    
    func setupProfile(profile: Profile) -> Void {
        loginLabel.text = "@\(profile.username)"
        if let lastName = profile.lastName {
            nameLabel.text = "\(profile.firstName) \(lastName)"
        } else {
            nameLabel.text = profile.firstName
        }
        descriptionLabel.text = "\(profile.bio ?? "")"
    }
}


