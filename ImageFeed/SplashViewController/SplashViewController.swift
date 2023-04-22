//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Aleksandr Garipov on 22.03.2023.
//

import UIKit

private let ShowAuthenticationScreenSegueIdentifier = "ShowAuthenticationScreenSegueIdentifier"

final class SplashViewController: UIViewController {
    
    private let oAuth2TokenStorage = OAuth2TokenStorage()
    private let oAuth2Service = OAuth2Service()
    private let profileService = ProfileService.shared
    var isFirstAppear = true
    
    private lazy var logoImageView: UIImageView = {
        let logoImage = UIImageView()
        logoImage.image = Resources.Images.splashLogoImage
        logoImage.translatesAutoresizingMaskIntoConstraints = false
        return logoImage
    }()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //oAuth2TokenStorage.deleteToken()
        print("TOKEN: \(oAuth2Service.authToken)")
        if isFirstAppear {
            if oAuth2TokenStorage.token != nil {
                fetchProfile(token: oAuth2TokenStorage.token!)
            } else {
                guard let authViewController =
                        UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "AuthController") as? AuthViewController else { return }
                authViewController.delegate = self
                authViewController.modalPresentationStyle = .fullScreen
                present(authViewController, animated: true)
                isFirstAppear = false
            }
        }
    }
    
    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else { assertionFailure("Invalid Configuration")
            return
        }
        
        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "TabBarViewController")
        
        window.rootViewController = tabBarController
    }
    
    private func setupUI() {
        view.backgroundColor = Resources.Colors.ypBlack
        view.addSubview(logoImageView)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}

extension SplashViewController: AuthViewControllerDelegate {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        UIBlockingProgressHUD.show()
        dismiss(animated: true) {[weak self] in
            guard let self = self else { return }
            self.fetchOAuthToken(code)
        }
    }
    
    private func fetchOAuthToken(_ code: String) {
        oAuth2Service.fetchOAuthToken(code: code) { [weak self]  result in
            guard let self = self else { return }
            switch result {
            case .success(let token):
                self.fetchProfile(token: token)
            case .failure:
                self.showErrorAlert()
                UIBlockingProgressHUD.dismiss()
                break
            }
        }
    }
    
    private func fetchProfile(token: String) {
        profileService.fetchProfile(token) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                UIBlockingProgressHUD.dismiss()
                self.switchToTabBarController()
            case .failure:
                self.showErrorAlert()
                UIBlockingProgressHUD.dismiss()
                break
            }
        }
    }
    
    private func showErrorAlert() {
        let alert = UIAlertController(title: "Что-то пошло не так", message: "Не удалось войти в систему", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default) { _ in
            alert.dismiss(animated: true)
        }
        alert.addAction(okAction)
        present(alert, animated: true)
    }   
}
