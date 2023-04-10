//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Aleksandr Garipov on 03.03.2023.
//

import UIKit
import Kingfisher

final class ProfileViewController: UIViewController {

    let profileService = ProfileService.shared
    let authToken = OAuth2TokenStorage().token ?? "nil"
    private var profileImageServiceObserver: NSObjectProtocol?
    
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
        super.viewDidLoad()
        
        setupUI()
        layout()
        setupProfile()
        
        profileImageServiceObserver = NotificationCenter.default.addObserver(
            forName: ProfileImageService.DidChangeNotification,
            object: nil,
            queue: .main
            ) { [weak self] _ in
                guard let self = self else { return }
                self.updateAvatar()
            }
        updateAvatar()
        
        
    }
    
    
    
    func setupUI() {
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
    
    @objc private func didTapLogoutButton() {
        OAuth2TokenStorage().deleteToken()
    }
    
    func setupProfile() -> Void {
        if let firstNameText = profileService.profile?.firstName,
           let lastNameText = profileService.profile?.lastName,
           let loginLabelText = profileService.profile?.username {
            nameLabel.text = ("\(firstNameText) \(lastNameText)")
            loginLabel.text = loginLabelText
        }
        descriptionLabel.text = "\(profileService.profile?.bio ?? "")"
    }
    
    private func updateAvatar() {
        guard
            let profileImageUrl = ProfileImageService.shared.avatarURL,
            let url = URL(string: profileImageUrl)
        else { return }
        avatarImage.kf.setImage(with: url,
                                placeholder: Resources.Images.Profile.defaultAvatar,
                                options: [])
        print("A VOT I URL: \(url)")
    }
}

