//
//  WebViewPresenterProtocol.swift
//  ImageFeed
//
//  Created by Aleksandr Garipov on 08.05.2023.
//

import Foundation

public protocol WebViewPresenterProtocol {
    var view: WebViewControllerProtocol? { get set }
    func viewDidLoad()
    func didUpdateProgressValue(_ newValue: Double)
    func code(from url: URL) -> String?
}
