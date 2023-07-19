//
//  StatisticServiceFactory.swift
//  MovieQuiz
//
//  Created by Eduard Karimov on 15.07.2023.
//

import Foundation

class StatisticServiceFactory: StatisticServiceProtocol {
    func makeStaticService() -> StatisticService {
        return StatisticServiceImplementation()
    }
}
