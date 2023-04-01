//
//  AuthViewController.swift
//  ImageFeed
//
//  Created by Aleksandr Garipov on 18.03.2023.
//

import UIKit

final class AuthViewController: UIViewController {
    
    private let showWebViewSegueIdentifier = "ShowWebView"
    
    weak var delegate: AuthViewControllerDelegate?
    
    let oAuth2Service = OAuth2Service()

    var webViewViewController: WebViewViewController?
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
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
        self.delegate?.authViewController(self, didAuthenticateWithCode: code)
    }
  
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        dismiss(animated: true)
    }
}

