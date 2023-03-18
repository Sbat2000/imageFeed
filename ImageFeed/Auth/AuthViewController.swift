//
//  AuthViewController.swift
//  ImageFeed
//
//  Created by Aleksandr Garipov on 18.03.2023.
//

import UIKit

final class AuthViewController: UIViewController {
    
    let showWebViewSegueIdentifier = "ShowWebView"
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var webViewViewController: WebViewViewController?
        
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
        
    }
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        dismiss(animated: true)
    }
}

