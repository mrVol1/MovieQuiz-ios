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
    
    func requestNextQuestion() {
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            let index = (0..<self.movies.count).randomElement() ?? 0
            
            guard let movie = self.movies[safe: index] else { return }
            
            var imageData = Data()
            
            do {
                imageData = try Data(contentsOf: movie.resizedImageURL)
            } catch {
                print("Failed to load image")
            }
            
            let rating = Float(movie.rating) ?? 0
            let random = Int.random(in: 1..<10)
            
            func randomWordComparison (wordMore: String, wordLess: String) -> String {
                
                if self.randomWord == wordMore {
                    self.randomWord = wordLess
                } else {
                    self.randomWord = wordMore
                }
                return self.randomWord
            }
            
            let randomWordMoreOrLess = randomWordComparison(wordMore: "больше", wordLess: "меньше")
            
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
