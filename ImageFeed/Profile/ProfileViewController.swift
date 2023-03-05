//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Aleksandr Garipov on 03.03.2023.
//

import UIKit

final class ProfileViewController: UIViewController {
    
    
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func didTapLogoutButton(_ sender: UIButton) {
    }
    
}

