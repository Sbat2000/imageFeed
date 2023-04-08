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
    //private let token = OAuth2TokenStorage().token ?? ""
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if oAuth2TokenStorage.token != nil {
            fetchProfile(token: oAuth2TokenStorage.token!)
        } else {
            performSegue(withIdentifier: ShowAuthenticationScreenSegueIdentifier, sender: nil)
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
    
}


extension SplashViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == ShowAuthenticationScreenSegueIdentifier {
            guard
                let navigationController = segue.destination as? UINavigationController,
                let viewController = navigationController.viewControllers[0] as? AuthViewController
            else {assertionFailure("Failed to prepare for \(ShowAuthenticationScreenSegueIdentifier)")
                return
            }
            
            viewController.delegate = self
        } else {
            prepare(for: segue, sender: sender)
        }
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
                print(token)
                print(self.oAuth2TokenStorage.token!)
                self.fetchProfile(token: token)
            case .failure:
                //TODO
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
                UIBlockingProgressHUD.dismiss()
                // TODO [Sprint 11] Показать ошибку
                break
            }
        }
    }
    
    
}
