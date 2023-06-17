//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by Eduard Karimov on 17.06.2023.
//

import Foundation

private enum Keys: String {
    case correct, total, bestGame, gamesCount
}

struct GameRecord: Codable {
    let correct: Int
    let total: Int
    let date: Date
}

protocol StatisticService {
    func store(correct count: Int, total amount: Int)
    var totalAccuracy: Double { get }
    var gamesCount: Int { get }
    var bestGame: GameRecord { get }
}

final class StatisticServiceImplementation: StatisticService {
    func store(correct count: Int, total amount: Int) {
        <#code#>
    }
    
    var totalAccuracy: Double
    
    var gamesCount: Int
    
    var bestGame: GameRecord {
        get {
            guard let data = userDefaults.data(forKey: Keys.bestGame.rawValue),
            let record = try? JSONDecoder().decode(GameRecord.self, from: data) else {
                return .init(correct: 0, total: 0, date: Date())
            }
            
            return record
        }
        
        set {
            guard let data = try? JSONEncoder().encode(newValue) else {
                print("Невозможно сохранить результат")
                return
            }
            
            userDefaults.set(data, forKey: Keys.bestGame.rawValue)
        }
    }
    
    
}
