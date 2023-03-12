//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Aleksandr Garipov on 03.03.2023.
//

import UIKit

final class ProfileViewController: UIViewController {
    
    let avatarImage: UIImageView = {
        let image = UIImageView()
        image.image = Resources.Images.Profile.defaultAvatar
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    let logoutButton: UIButton = {
        let imageButton = Resources.Images.Profile.logoutButtonImage
        let button = UIButton.systemButton(
            with: imageButton!,
            target: self,
            action: #selector(Self.didTapLogoutButton))
        button.tintColor = Resources.Colors.YPRed
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Екатерина Новикова"
        label.textColor = Resources.Colors.YPWhite
        label.font = UIFont.systemFont(ofSize: 23, weight: UIFont.Weight.bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let loginLabel: UILabel = {
        let label = UILabel()
        label.text = "@ekaterina_nov"
        label.textColor = Resources.Colors.YPGray
        label.font = UIFont.systemFont(ofSize: 13, weight: UIFont.Weight.regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let textLabel: UILabel = {
        let label = UILabel()
        label.text = "Hello, world!"
        label.textColor = Resources.Colors.YPWhite
        label.font = UIFont.systemFont(ofSize: 13, weight: UIFont.Weight.regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        layout()
    }
    
    
    
    func setupUI() {
        [avatarImage, logoutButton, nameLabel, loginLabel, textLabel].map {view.addSubview($0)}
    }
    
    func layout() {
        
        avatarImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 76).isActive = true
        avatarImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        avatarImage.heightAnchor.constraint(equalToConstant: 70).isActive = true
        avatarImage.widthAnchor.constraint(equalToConstant: 70).isActive = true
        
        logoutButton.centerYAnchor.constraint(equalTo: avatarImage.centerYAnchor).isActive = true
        logoutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -26).isActive = true
        
        nameLabel.leadingAnchor.constraint(equalTo: avatarImage.leadingAnchor).isActive = true
        nameLabel.topAnchor.constraint(equalTo: avatarImage.bottomAnchor, constant: 8).isActive = true
        
        loginLabel.leadingAnchor.constraint(equalTo: avatarImage.leadingAnchor).isActive = true
        loginLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8).isActive = true
        
        textLabel.leadingAnchor.constraint(equalTo: avatarImage.leadingAnchor).isActive = true
        textLabel.topAnchor.constraint(equalTo: loginLabel.bottomAnchor, constant: 8).isActive = true
        
        
    }
    
    @objc func didTapLogoutButton() {
        print("button tapped")
    }
    
}

