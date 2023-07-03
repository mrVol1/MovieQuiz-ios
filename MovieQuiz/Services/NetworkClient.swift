//
//  NetworkClient.swift
//  MovieQuiz
//
//  Created by Eduard Karimov on 26.06.2023.
//

import Foundation

struct NetworkClient {
    private enum NetworkError: Error {
        case codeError
    }
    private let apiKey: String
    init(apiKey: String) {
        self.apiKey = apiKey
    }
    func fetch(url: URL, handler: @escaping (Result<Data, Error>) -> Void) {
        var request = URLRequest(url: url)
        request.addValue(apiKey, forHTTPHeaderField: "X-API-KEY")

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                handler(.failure(error))
                print(error)
                return
            }

            if let response = response as? HTTPURLResponse,
               response.statusCode < 200 || response.statusCode >= 300 {
                handler(.failure(NetworkError.codeError))
                print(response)
                return
            }

            guard let data = data else { return }
            handler(.success(data))
        }

        task.resume()
    }
}
