//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by Eduard Karimov on 17.06.2023.
//

import Foundation

protocol StatisticService {
    func store(correct: Int, total: Int) //сохраняет текущую игру
    var totalAccuracy: Double { get } //общая точность
    var gamesCount: Int { get } //количество сыграных игр
    var bestGame: GameRecord? { get } //лучшая сыгранная игра
}

final class StatisticServiceImplementation {
    
    private let userDefaults: UserDefaults
    private let decoder: JSONDecoder
    private let encoder: JSONEncoder
    private let dateProvider: () -> Date
    
    init(userDefaults: UserDefaults = .standard,
         decoder: JSONDecoder = JSONDecoder(),
         encoder: JSONEncoder = JSONEncoder(),
         dateProvider: @escaping () -> Date = { Date() }
        ) {
        self.userDefaults = userDefaults
        self.decoder = decoder
        self.encoder = encoder
        self.dateProvider = dateProvider
    }
    
    private enum Keys: String {
        case correct, total, bestGame, gamesCount
    }
}

extension StatisticServiceImplementation: StatisticService {
    
    var gamesCount: Int {
        get {
            userDefaults.integer(forKey: Keys.gamesCount.rawValue)
        }
        
        set {
            userDefaults.set(newValue, forKey: Keys.gamesCount.rawValue)
        }
    }
    
    var total: Int {
        get {
            userDefaults.integer(forKey: Keys.total.rawValue)
        }
        
        set {
                userDefaults.set(newValue, forKey: Keys.total.rawValue)
        }
    }
    
    var correct: Int {
        get {
            userDefaults.integer(forKey: Keys.correct.rawValue)
        }
        
        set {
            userDefaults.set(newValue, forKey: Keys.correct.rawValue)
        }
    }
    
    var totalAccuracy: Double {
        guard total != 0 else { return 0 }
        return Double(correct)/Double(total) * 100
    }
    
    var bestGame: GameRecord? {
        get {
            guard
                let data = userDefaults.data(forKey: Keys.bestGame.rawValue),
                let bestGame = try? decoder.decode(GameRecord.self, from: data) else {
                return nil
            }
            return bestGame
        }
        
        set {
            let data = try? encoder.encode(newValue)
            userDefaults.set(data, forKey: Keys.bestGame.rawValue)
        }
    }
    
    func store(correct: Int, total: Int) {
        self.correct += correct
        self.total += total
        self.gamesCount += 1
        
        let date = dateProvider()
        
        let currentGameRecord = GameRecord(correct: correct, total: total, date: date)
        
        if let previosGameRecord = bestGame {
            if currentGameRecord > previosGameRecord {
                bestGame = currentGameRecord
            }
        } else {
            bestGame = currentGameRecord
        }
    }
}
