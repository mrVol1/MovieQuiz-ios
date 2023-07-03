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

//    var resizedImageURL: URL {
//        // создаем строку из адреса
//        let urlString = imageURL.absoluteString
//        //  обрезаем лишнюю часть и добавляем модификатор желаемого качества
//        let imageUrlString = urlString.components(separatedBy: "._")[0] + "._V0_UX600_.jpg"
//        // пытаемся создать новый адрес, если не получается возвращаем старый
//        guard let newURL = URL(string: imageUrlString) else {
//            return imageURL
//        }
//        return newURL
//    }
