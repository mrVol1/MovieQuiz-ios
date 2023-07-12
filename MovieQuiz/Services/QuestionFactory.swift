//
//  QuestionFactory.swift
//  MovieQuiz
//
//  Created by Eduard Karimov on 14.06.2023.
//

import Foundation
import UIKit

class QuestionFactory: QuestionFactoryProtocol {
    private let moviesLoader: MoviesLoading
    private var randomWord: String
    private var imageLoadingDelegate: QuestionFactoryDelegate?
    private var movies: [Movie] = []
    internal weak var delegate: QuestionFactoryDelegate?
    init(moviesLoader: MoviesLoading, delegate: QuestionFactoryDelegate?, randomWord: String) {
        self.moviesLoader = moviesLoader
        self.randomWord = randomWord
        self.delegate = delegate
    }
    func loadData() {
        delegate?.showLoadingIndicator()
        moviesLoader.loadMovies { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .success(let mostPopularMovies):
                    let movies = mostPopularMovies.movies
                    if movies.isEmpty {
                        let error = NSError(
                            domain:
                                "https://api.kinopoisk.dev/v1.3/movie?selectFields=name&selectFields=rating.imdb&selectFields=poster.url&page=1&limit=10",
                            code: 0
                            
                        )
                        self.delegate?.didFailToLoadData(with: error)
                    } else {
                        self.movies = movies
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
            if let imageUrl = URL(string: movie.poster.url), let data = try? Data(contentsOf: imageUrl) {
                imageData = data
            } else {
                DispatchQueue.main.async { [weak self] in
                    self?.showImageLoadingError()
                }
                return
            }
            let ratingString = String(movie.rating.imdb)
            let random = Int.random(in: 1..<10)
            func randomWordComparison() -> String {
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
            let correctAnswer = Int(ratingString) ?? 0 > random
            let question = QuizQuestion(image: imageData, text: text, correctAnswer: correctAnswer)
            self.delegate?.didReceiveNextQuestion(question: question)
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.delegate?.hideLoadingIndicator()
            }
        }
    }
    private func showImageLoadingError() {
        delegate?.showImageLoadingError()
    }
    private func handleNextQuestionLoaded() {
        delegate?.hideLoadingIndicator()
    }
}
