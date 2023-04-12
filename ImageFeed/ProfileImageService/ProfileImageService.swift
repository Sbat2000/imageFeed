//
//  ProfileImageService.swift
//  ImageFeed
//
//  Created by Aleksandr Garipov on 08.04.2023.
//

import Foundation

final class ProfileImageService{
    
    static let shared = ProfileImageService()
    static let DidChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    private (set) var avatarURL: String?
    private let oAuthToken = OAuth2TokenStorage().token
    private let urlSession = URLSession.shared
    
    private var task: URLSessionDataTask?
    private var lastToken: String?
    
    func fetchProfileImageURL(username: String, _ completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        if lastToken == oAuthToken { return }
        task?.cancel()
        lastToken = oAuthToken
        let request = imageURLRequest(oAuthToken!, userName: username)
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<UserResult, Error>) in
            guard let self = self else {return}
            switch result {
            case .success(let userResult):
                self.avatarURL = userResult.profileImage.small
                completion(.success(userResult.profileImage.small))
                self.task = nil
                NotificationCenter.default.post(
                    name: ProfileImageService.DidChangeNotification,
                    object: self,
                    userInfo: ["URL": self.avatarURL!])
            case .failure(let eror):
                completion(.failure(eror))
                self.lastToken = nil
            }
        }
        self.task = task
        task.resume() 
    }
}

extension ProfileImageService {
    private func imageURLRequest(_ token: String, userName: String) -> URLRequest {
        var request = URLRequest.makeHTTPRequest(path: "/users/\(userName)", httpMethod: "GET")
        request.setValue("Bearer \(oAuthToken!)", forHTTPHeaderField: "Authorization")
        return request
    }
}
