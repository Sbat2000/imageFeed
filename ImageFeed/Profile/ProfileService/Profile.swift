//
//  ProfileServiceReponcseBody.swift
//  ImageFeed
//
//  Created by Aleksandr Garipov on 07.04.2023.
//

import Foundation

struct Profile: Decodable {
    let username, firstName: String
    let lastName: String?
    let bio: String?
}
