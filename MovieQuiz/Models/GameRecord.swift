//
//  BestGame.swift
//  MovieQuiz
//
//  Created by Eduard Karimov on 21.06.2023.
//

import Foundation


struct GameRecord: Codable {
    let correct: Int //количество правильных ответов
    let total: Int // сколько всего было ответов
    let date: Date // дата
    
}

extension GameRecord: Comparable {
    
    private var accuracy: Double {
        guard total != 0 else {
            return 0
        }
        return Double(correct / total)
    }
    static func < (lhs: GameRecord, rhs: GameRecord) -> Bool {
        lhs.accuracy < rhs.accuracy
    }
}
