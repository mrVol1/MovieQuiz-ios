//
//  MoviesLoader.swift
//  MovieQuiz
//
//  Created by Eduard Karimov on 26.06.2023.
//

import Foundation

protocol MoviesLoading {
    func loadMovies(handler: @escaping (Result<MostPopularMovies, Error>) -> Void)
}

struct MoviesLoader: MoviesLoading {
    // constant
    static let apiKey = "2YXG5TW-638MY4H-M1V53M4-E66MHQE"
    private let stubNetworkClient: StubNetworkClient
    private let networkClient: NetworkClient
    // init networkClient
    init(
        networkClient: NetworkClient = NetworkClient(apiKey: apiKey),
        stubNetworkClient: StubNetworkClient = StubNetworkClient(emulateError: false)
    ) {
        self.networkClient = networkClient
        self.stubNetworkClient = stubNetworkClient
    }

    func loadMovies(handler: @escaping (Result<MostPopularMovies, Error>) -> Void) {
        var request = URLRequest(
            url: URL(
                string: """
                https://api.kinopoisk.dev/v1.3/movie?selectFields=name&selectFields=rating.imdb&selectFields=poster.url&page=1&limit=250
                """
                    )!,
                        timeoutInterval: Double.infinity)
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(MoviesLoader.apiKey, forHTTPHeaderField: "X-API-KEY")
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) { data, _, error
            in guard let data = data else {
                print(String(describing: error))
                return
            }
            do {
                let mostPopularMovies = try JSONDecoder().decode(MostPopularMovies.self, from: data)
                handler(.success(mostPopularMovies))
            } catch {
                handler(.failure(error))
            }
        }
        task.resume()
    }
}
