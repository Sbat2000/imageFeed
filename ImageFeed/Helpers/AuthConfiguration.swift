//
//  Constants.swift
//  ImageFeed
//
//  Created by Aleksandr Garipov on 17.03.2023.
//

import Foundation

let AccessKey = "EWqoGPFrqHLBRnz4bGDduUh7TP1CsHgTBhU4_LkOnBI"
let SecretKey = "W3KcynAzK1WFcIC13_6Y-Jpnt3lw3YGcuvY0WbHT1VM"
let RedirectURI = "urn:ietf:wg:oauth:2.0:oob"
let AccessScope = "public+read_user+write_likes"

let DefaultBaseApiURL = URL(string: "https://api.unsplash.com")!
let UnsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
let baseURL = URL(string: "https://unsplash.com")!

//let accessKey = "w1q5-5uTu_enPVnBQRk15f6M8eLpeKmBclZDOLTJ7As"
//let secretKey = "g9L0Xof4AWw69pk1ad7IhhBW5OgoiuXRP5vkklRtMRI"
//let redirectURI = "urn:ietf:wg:oauth:2.0:oob"

//let accessKey = "P4URqKxPKlM-zJ-qAacKsb0-YAYeTVVzj7IQ4U05MBE"
//let secretKey = "vlUCjMbxtDyowdlYDmq2OB4ekqm0Qvj6_IlpJBAU8s0"
//let redirectURI = "urn:ietf:wg:oauth:2.0:oob"


struct AuthConfiguration {
    let accessKey:          String
    let secretKey:          String
    let redirectURI:        String
    let accessScope:        String
    let authURLString:      String
    let defaultBaseURL:     URL

    static var standard: AuthConfiguration {
        return AuthConfiguration(accessKey: AccessKey,
                                 secretKey: SecretKey,
                                 redirectURI: RedirectURI,
                                 accessScope: AccessScope,
                                 authURLString: UnsplashAuthorizeURLString,
                                 defaultBaseURL: DefaultBaseApiURL)
    }
    
    init(accessKey: String, secretKey: String, redirectURI: String, accessScope: String, authURLString: String, defaultBaseURL: URL) {
        self.accessKey = accessKey
        self.secretKey = secretKey
        self.redirectURI = redirectURI
        self.accessScope = accessScope
        self.authURLString = authURLString
        self.defaultBaseURL = defaultBaseURL
    }
}
