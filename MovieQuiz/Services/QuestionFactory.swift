//
//  QuestionFactory.swift
//  MovieQuiz
//
//  Created by Eduard Karimov on 14.06.2023.
//

import Foundation

class QuestionFactory: QuestionFactoryProtocol  {
    
    private let moviesLoader: MoviesLoading
    private var delegate: QuestionFactoryDelegate?
    private var randomWord: String
    private var alertError: AlertPresenterError?
    
    init(moviesLoader: MoviesLoading, delegate: QuestionFactoryDelegate?, randomWord: String) {
        self.moviesLoader = moviesLoader
        self.delegate = delegate
        self.randomWord = randomWord
    }
    
    private var movies: [MostPopularMovie] = []
    
    func loadData() {
        moviesLoader.loadMovies { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .success(let mostPopularMovies):
                    self.movies = mostPopularMovies.items
                    self.delegate?.didLoadDataFromServer()
                case .failure(let error):
                    self.delegate?.didFailToLoadData(with: error)
                }
            }
        }
    }
    
    func showError(alertPresentError: Error) {
        
    }
    
    func requestNextQuestion() {
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            let index = (0..<self.movies.count).randomElement() ?? 0
            
            guard let movie = self.movies[safe: index] else { return }
            
            var imageData = Data()
            var alertError: Error?
            
            do {
                imageData = try Data(contentsOf: movie.resizedImageURL)
            } catch let catchedError {
                print("Failed to load image")
                alertError = AlertModelError(title: "Error", message: "Data is not loaded. Please wait", buttonText: "Update") as! any Error
            }
            
            DispatchQueue.main.async { [weak self] in
                // Обработка imageData и error на главной очереди
                guard let self = self else { return }
                if let alertError = alertError {
                    // Обработка ошибки
                    self.showError(alertPresentError: alertError)
                } else {
                    // Обработка imageData
                    self.processImageData(imageData)
                }
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
                self.delegate?.didReceiveNextQuestion(question: question)
            }
        }
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
