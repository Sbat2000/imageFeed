//
//  WebViewViewControllerDelegate.swift
//  ImageFeed
//
//  Created by Aleksandr Garipov on 18.03.2023.
//

import WebKit

protocol WebViewViewControllerDelegate {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String)
    func webViewViewControllerDidCancel(_ vc: WebViewViewController)
}
