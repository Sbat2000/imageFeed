//
//  AlertModel.swift
//  ImageFeed
//
//  Created by Aleksandr Garipov on 17.05.2023.
//

import Foundation

public struct Alert {
    var id: String? = nil
    let title: String
    let message: String
    let buttons: [Button]
    
    enum Button {
        typealias Action = () -> Void
        case `default`(text: String, id: String? = nil, action: Action? = nil)
        case cancel(text: String, id: String? = nil, action: Action? = nil)
    }
    
}
