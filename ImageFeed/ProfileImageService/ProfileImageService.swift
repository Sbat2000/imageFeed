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
    
    func fetchProfileImageURL(username: String, _ completion: @escaping (Result<String, Error>) -> Void) {
        let request = imageURLRequest(oAuthToken!, userName: username)
        let task = object(for: request) { [weak self] result -> Void in
            guard let self = self else { return }
            switch result  {
            case .success(let userResult):
                self.avatarURL = userResult.profileImage.small
                print("AVATAR URL: \(self.avatarURL ?? "NETU!")")
                completion(.success(userResult.profileImage.small))
                NotificationCenter.default.post(
                    name: ProfileImageService.DidChangeNotification,
                    object: self,
                    userInfo: ["URL": self.avatarURL!])
            case .failure(let error):
                completion(.failure(error))
            }
        }
        task.resume()
        
    }
}

extension ProfileImageService {
    
    
    private func object(
        for request: URLRequest,
        completion: @escaping (Result<UserResult, Error>) -> Void
    ) -> URLSessionTask {
        let decoder = JSONDecoder()
        return urlSession.data(for: request) { (result: Result<Data, Error>) in
            let response = result.flatMap { data -> Result<UserResult, Error> in
                return Result { try decoder.decode(UserResult.self, from: data) }
            }
            completion(response)
        }
    }
    
    
    private func imageURLRequest(_ token: String, userName: String) -> URLRequest {
        var request = URLRequest.makeHTTPRequest(path: "/users/\(userName)", httpMethod: "GET")
        request.setValue("Bearer \(oAuthToken!)", forHTTPHeaderField: "Authorization")
        return request
    }
}
