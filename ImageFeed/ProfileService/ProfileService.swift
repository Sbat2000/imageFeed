//
//  ProfileService.swift
//  ImageFeed
//
//  Created by Aleksandr Garipov on 07.04.2023.
//

import Foundation
let authToken = OAuth2TokenStorage().token
let urlSession = URLSession.shared
var profile: Profile?

final class ProfileService {
    

    let urlSession = URLSession.shared
    
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        let request = profileRequest(token: token)
        let task = object(for: request) { [weak self] result -> Void in
            guard let self = self else { return }
            switch result  {
            case .success(let profile):
                completion(.success(profile))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    
}

extension ProfileService {
    private func profileRequest(token: String) -> URLRequest {
        var request = URLRequest.makeHTTPRequest(path: "/me", httpMethod: "GET")
        request.setValue("Bearer \(authToken!)", forHTTPHeaderField: "Authorization")
        print("\(request.allHTTPHeaderFields)")
        print("\(request)")
        //profileBody(request: request)
        return request
    }
    
    private func object(
        for request: URLRequest,
        completion: @escaping (Result<Profile, Error>) -> Void
    ) -> URLSessionTask {
        let decoder = JSONDecoder()
        return urlSession.data(for: request) { (result: Result<Data, Error>) in
            let response = result.flatMap { data -> Result<Profile, Error> in
                Result { try decoder.decode(Profile.self, from: data) }
            }
            completion(response)
        }
    }
    
//    private func profileBody(request: URLRequest) -> Void {
//        let decoder = JSONDecoder()
//        let task = urlSession.dataTask(with: request) { (data, response, error) in
//            guard let data = data else { return }
//            print("data: \(data)")
//            do {
//                let profile = try decoder.decode(Profile.self, from: data)
//                print(profile.username)
//            } catch let error {
//                print("error profile: \(error)")
//            }
//            }
//        task.resume()
//        }
//

}



//private func object(
//    for request: URLRequest,
//    completion: @escaping (Result<OAuthTokenResponseBody, Error>) -> Void
//) -> URLSessionTask {
//    let decoder = JSONDecoder()
//    return urlSession.data(for: request) { (result: Result<Data, Error>) in
//        let response = result.flatMap { data -> Result<OAuthTokenResponseBody, Error> in
//            Result { try decoder.decode(OAuthTokenResponseBody.self, from: data) }
//        }
//        completion(response)
//    }
//}
