//
//  MovieModel.swift
//  MovieQuiz
//
//  Created by Eduard Karimov on 16.06.2023.
//

import Foundation

////добавление файла данных в директорию проекта
//var documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
//    let fileName = "inception.json"
//    documentsURL.appendPathComponent(fileName)
//    let jsonString = try? String(contentsOf: documentsURL)
//
//    // приведение типа данных к типу data
//    guard let data = jsonString?.data(using: .utf8) else {
//        return
//    }
//
////сериализация данных в json
//func jsonObject(with data: Data, options opt: JSONSerialization.ReadingOptions = []) throws {
//    do {
//        let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
//        print(json as Any)
//    } catch {
//        print("Failed to parse: \(jsonString as Any)")
//    }
//}
//
//struct Actor: Codable {
//    let id: String
//    let image: String
//    let name: String
//    let asCharacter: String
//}
//
//struct Movie: Codable {
//    let id: String
//    let rank: String
//    let title: String
//    let fullTitle: String
//    let year: String
//    let image: String
//    let crew: String
//    let imDbRating: String
//    let imDbRatingCount: String
//}
//
//struct Top: Decodable {
//    let items: [Movie]
//}
//
//let result = try? JSONDecoder().decode(Top.self, from: data)
