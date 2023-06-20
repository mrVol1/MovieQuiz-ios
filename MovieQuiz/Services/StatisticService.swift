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

protocol StatisticService {
    func store(correct: Int, total: Int)
    var totalAccuracy: Double { get }
    var gamesCount: Int { get }
    var bestGame: GameRecord { get }
}

struct GameRecord: Codable {
    let correct: Int
    let total: Int
    let date: Date
    
    private func comparison() {
        
    }
}

final class StatisticServiceImplementation: StatisticService {
    var gamesCount: Int = 0
    
    var totalAccuracy: Double = 0.0
    
    private let userDefaults = UserDefaults.standard
    
    func store(correct: Int, total: Int) {
        self.correct += correct
        self.total += total
        self.gamesCount += 1
        
        let currentGameRecord = GameRecord(correct: correct, total: total, date: Date())
        
        if let previosGameRecord = bestGame {
            if currentGameRecord > previosGameRecord {
                bestGame = currentGameRecord
            }
        }
    }
    
    var totalAccuracy: Double {
        get {
            let totalA = Double(correct)/Double(total)*100
            return totalA
        }
    }
    
    var total: Int {
        get {
            guard let data = userDefaults.data(forKey: Keys.total.rawValue),
                  let total = try? JSONDecoder().decode(Int.self, from: data) else {
                return .init()
            }
            
            return total
        }
        set {
            guard let data = try? JSONEncoder().encode(newValue) else {
                print("Невозможно сохранить результат")
                return
            }
            userDefaults.set(data, forKey: Keys.total.rawValue)
        }
    }
    
    var correct: Int {
        get {
            guard let data = userDefaults.data(forKey: Keys.correct.rawValue),
                  let correct = try? JSONDecoder().decode(Int.self, from: data) else{
                return .init()
            }
            return correct
        }
        
            set {
                guard let data = try? JSONEncoder().encode(newValue) else {
                    print("Невозможно сохранить результат")
                    return
                }
                userDefaults.set(data, forKey: Keys.correct.rawValue)
            }
        }
    
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
