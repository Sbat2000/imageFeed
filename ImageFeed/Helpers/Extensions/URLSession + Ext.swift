//
//  URLSession + Ext.swift
//  ImageFeed
//
//  Created by Aleksandr Garipov on 19.03.2023.
//

import Foundation

enum NetworkError: Error {
    case httpStatusCode(Int)
    case urlRequestError(Error)
    case urlSessionError
}

extension URLSession {
    func objectTask<T: Decodable>(
        for request: URLRequest,
        completion: @escaping(Result<T, Error>) -> Void) -> URLSessionDataTask {
            let fulfillCompletionOnMainThread: (Result<T, Error>) -> Void = { result in
                DispatchQueue.main.async {
                    completion(result)
                }
            }
            let task = dataTask(with: request, completionHandler: {data, response, error in
                if let error  = error {
                    fulfillCompletionOnMainThread(.failure(NetworkError.urlRequestError(error)))
                } else if let data = data,
                          let response = response,
                          let statusCode = (response as? HTTPURLResponse)?.statusCode {
                    if 200..<300 ~= statusCode {
                        do {
                            let decoder = JSONDecoder()
                            let result = try decoder.decode(T.self, from: data)
                            fulfillCompletionOnMainThread(.success(result))
                        } catch {
                            fulfillCompletionOnMainThread(.failure(NetworkError.httpStatusCode(statusCode)))
                        }
                    } else {
                        fulfillCompletionOnMainThread(.failure(NetworkError.httpStatusCode(statusCode)))
                    }
                } else {
                    fulfillCompletionOnMainThread(.failure(NetworkError.urlSessionError))   
                }
            })
            return task
        }
}
