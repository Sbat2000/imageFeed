//
//  AuthViewController.swift
//  ImageFeed
//
//  Created by Aleksandr Garipov on 18.03.2023.
//

import UIKit

final class AuthViewController: UIViewController {
    
    let showWebViewSegueIdentifier = "ShowWebView"
    
    let oAuth2Service = OAuth2Service()

    var webViewViewController: WebViewViewController?
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let token = UserDefaults.standard.string(forKey: "auth2_token")
        print(token)
        if segue.identifier == showWebViewSegueIdentifier {
            
            if let viewController = segue.destination as? WebViewViewController {
                webViewViewController = viewController
                webViewViewController?.delegate = self
            }
        }
    }
}

extension AuthViewController: WebViewViewControllerDelegate {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        oAuth2Service.fetchOAuthToken(code: code) { result in
            switch result {
            case .success(let token):
                print(token)
                vc.dismiss(animated: true)
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    

    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        dismiss(animated: true)
    }
}

