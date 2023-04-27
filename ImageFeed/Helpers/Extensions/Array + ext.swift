//
//  Array + ext.swift
//  ImageFeed
//
//  Created by Aleksandr Garipov on 19.04.2023.
//

import Foundation

extension Array {
    mutating func withReplaced(itemAt index: Int, newValue: Element) {
        guard index < count else { return }
        self[index] = newValue
    }
}
