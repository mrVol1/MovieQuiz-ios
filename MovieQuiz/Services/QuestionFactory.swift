//
//  QuestionFactory.swift
//  MovieQuiz
//
//  Created by Eduard Karimov on 14.06.2023.
//

import Foundation
import UIKit

class QuestionFactory: QuestionFactoryProtocol  {
    
    private let moviesLoader: MoviesLoading
    private var delegate: QuestionFactoryDelegate?
    private var randomWord: String
    private var imageLoadingDelegate: QuestionFactoryDelegate?
    private var movies: [MostPopularMovie] = []
    
    init(moviesLoader: MoviesLoading, delegate: QuestionFactoryDelegate?, randomWord: String) {
        self.moviesLoader = moviesLoader
        self.delegate = delegate
        self.randomWord = randomWord
    }
    
    func loadData() {
        delegate?.showLoadingIndicator()
        moviesLoader.loadMovies { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .success(let mostPopularMovies):
                    if mostPopularMovies.items.isEmpty {
                        let errorMessage = mostPopularMovies.errorMessage
                        let error = NSError(domain: "https://imdb-api.com/en/API/Top250Movies/k_37bm4xsb", code: 0, userInfo: [NSLocalizedDescriptionKey: errorMessage])
                        self.delegate?.didFailToLoadData(with: error)
                    } else {
                        self.movies = mostPopularMovies.items
                        self.delegate?.didLoadDataFromServer()
                    }
                case .failure(let error):
                    self.delegate?.didFailToLoadData(with: error)
                }
            }
        }
    }
    
    func requestNextQuestion() {
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            let index = (0..<self.movies.count).randomElement() ?? 0
            
            guard let movie = self.movies[safe: index] else { return }
            
            var imageData = Data()
            
            do {
                imageData = try Data(contentsOf: movie.resizedImageURL)
            } catch {
                DispatchQueue.main.async { [weak self] in
                    self?.showImageLoadingError()
                }
                return
            }
            
            let rating = Float(movie.rating) ?? 0
            let random = Int.random(in: 1..<10)
            
            func randomWordComparison () -> String {
                let wordMore = "больше"
                let wordLess = "меньше"
                
                if self.randomWord == wordMore {
                    self.randomWord = wordLess
                } else {
                    self.randomWord = wordMore
                }
                return self.randomWord
            }
            
            let randomWordMoreOrLess = randomWordComparison()
            
            let text = "Рейтинг этого фильма \(randomWordMoreOrLess) чем \(random)?"
            let correctAnswer = Int(rating) > random
            
            let question = QuizQuestion(image: imageData,
                                        text: text,
                                        correctAnswer: correctAnswer)
            
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.delegate?.hideLoadingIndicator()
                self.delegate?.didReceiveNextQuestion(question: question)
            }
        }
    }
    
    func showImageLoadingError() {
        delegate?.showImageLoadingError()
    }
    
    private func handleNextQuestionLoaded() {
        delegate?.hideLoadingIndicator()
    }
}

//
//    /// мок данные
//    private let questions: [QuizQuestion] = [
//        QuizQuestion (image: "The Godfather",
//                      text: "Рейтинг этого фильма больше чем 6?",
//                      correctAnswer: true),
//        QuizQuestion (image: "The Dark Knight",
//                      text: "Рейтинг этого фильма больше чем 6?",
//                      correctAnswer: true),
//        QuizQuestion (image: "Kill Bill",
//                      text: "Рейтинг этого фильма больше чем 6?",
//                      correctAnswer: true),
//        QuizQuestion (image: "The Avengers",
//                      text: "Рейтинг этого фильма больше чем 6?",
//                      correctAnswer: true),
//        QuizQuestion (image: "Deadpool",
//                      text: "Рейтинг этого фильма больше чем 6?",
//                      correctAnswer: true),
//        QuizQuestion (image: "The Green Knight",
//                      text: "Рейтинг этого фильма больше чем 6?",
//                      correctAnswer: true),
//        QuizQuestion (image: "Old",
//                      text: "Рейтинг этого фильма больше чем 6?",
//                      correctAnswer: false),
//        QuizQuestion (image: "The Ice Age Adventures of Buck Wild",
//                      text: "Рейтинг этого фильма больше чем 6?",
//                      correctAnswer: false),
//        QuizQuestion (image: "Tesla",
//                      text: "Рейтинг этого фильма больше чем 6?",
//                      correctAnswer: false),
//        QuizQuestion (image: "Vivarium",
//                      text: "Рейтинг этого фильма больше чем 6?",
//                      correctAnswer: false)
//    ]
