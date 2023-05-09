//
//  WebViewControllerProtocol.swift
//  ImageFeed
//
//  Created by Aleksandr Garipov on 08.05.2023.
//

import Foundation

public protocol WebViewControllerProtocol: AnyObject {
    var presenter: WebViewPresenterProtocol? { get set }
    func load(request: URLRequest)
    func setProgressValue(_ newValue: Float)
    func setProgressHidden(_ isHidden: Bool)
}
