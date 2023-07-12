//
//  MostPopularMovies.swift
//  MovieQuiz
//
//  Created by Eduard Karimov on 26.06.2023.
//

import Foundation

struct MostPopularMovies: Codable {
    let movies: [Movie]

    private enum CodingKeys: String, CodingKey {
        case movies = "docs"
    }
}

struct Movie: Codable {
    let name: String
    let rating: Rating
    let poster: Poster

    private enum CodingKeys: String, CodingKey {
        case name
        case rating
        case poster
    }
}

struct Rating: Codable {
    let imdb: Float
}

struct Poster: Codable {
    let url: String
}
