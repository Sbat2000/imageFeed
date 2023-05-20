//
//  AuthHelperProtocol.swift
//  ImageFeed
//
//  Created by Aleksandr Garipov on 09.05.2023.
//

import Foundation

protocol AuthHelperProtocol {
    func authRequest() -> URLRequest
    func code(from url: URL) -> String?
}
