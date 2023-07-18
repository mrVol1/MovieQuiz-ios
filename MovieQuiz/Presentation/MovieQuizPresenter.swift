//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Eduard Karimov on 12.07.2023.
//

import Foundation
import UIKit

enum Answer {
    case yes
    case not
}

final class MovieQuizPresenter: QuestionFactoryDelegate {
    private weak var viewController: MovieQuizViewControllerProtocol?
    private let questionsAmount: Int = 10
    private var currentQuestion: QuizQuestion?
    private var questionFactory: QuestionFactory?
    private var alertPresent: AlertPresent?
    private var alertPresenterError: AlertPresenterError?
    private var statisticService: StatisticService?
    private var currentQuestionIndex = 0
    private var isButtonYesEnabled = true
    private var isButtonNoEnabled = true
    private var randomWord = "больше"
    
    init(viewController: MovieQuizViewControllerProtocol, statisticServiceFactory: StatisticServiceFactory) {
        self.viewController = viewController
        self.questionFactory = QuestionFactory(
            moviesLoader: MoviesLoader(networkClient: NetworkClient(apiKey: MoviesLoader.apiKey)),
            delegate: self,
            randomWord: randomWord
        )
        self.statisticService = statisticServiceFactory.makeStaticService()
        self.alertPresenterError = viewController as? AlertPresenterError
    }
    
    func showImageLoadingError() {
        viewController?.showImageLoadingError()
    }
    
    func showLoadingIndicator() {
        viewController?.showLoadingIndicator()
    }
    
    func hideLoadingIndicator() {
        viewController?.hideLoadingIndicator()
    }
    
    func didLoadDataFromServer() {
        viewController?.hideLoadingIndicator()
        questionFactory?.requestNextQuestion()
    }
    
    func didFailToLoadData(with error: Error) {
            let message = error.localizedDescription
            viewController?.showNetworkError(message: message)
        }

        func didReceiveNextQuestion(question: QuizQuestion?) {
            guard let question = question else {
                return
            }
            currentQuestion = question
            let viewModel = convert(model: question)
            viewController?.show(quiz: viewModel)
        }
    
    func showNextQuestionOrResults() {
        if itLastQuestion() {
            showQuizResult()
        } else {
            switchToNextQuestion()
            DispatchQueue.main.async { [weak self] in
                guard let currentQuestion = self?.currentQuestion else { return }
                let viewModel = self?.convert(model: currentQuestion)
                if let viewModel = viewModel {
                    self?.viewController?.show(quiz: viewModel)
                }
                self?.questionFactory?.requestNextQuestion()
            }
        }
        isButtonYesEnabled = true
        isButtonNoEnabled = true
        viewController?.showButtonState(isButtonYesEnabled: isButtonYesEnabled, isButtonNoEnabled: isButtonNoEnabled)
    }
    
    func showQuizResult() {
        statisticService?.store(correct: viewController?.correctAnswers ?? 0, total: questionsAmount)
        guard let statisticService = statisticService else {
            assertionFailure("Ошибка игры")
            return
        }
        let message = """
            Ваш результат: \(viewController?.correctAnswers ?? 0)/\(questionsAmount),
            Количество сыгранных квизов: \(statisticService.gamesCount),
            Рекорд: \(statisticService.bestGame?.correct ?? 0)/10 (\(statisticService.bestGame?.date.dateTimeString ?? "Ошибка времени")),
            Средняя точность: \(String(format: "%.2f", statisticService.totalAccuracy))
            """
        let viewModel = AlertModel(
            title: "Этот раунд окончен!",
            message: message,
            buttonText: "Сыграть ещё раз"
        ) { [weak self] in
            self?.viewController?.correctAnswers = 0
            self?.resetQuestionIndex()
            self?.questionFactory?.requestNextQuestion()
        }
        alertPresent?.show(alertPresent: viewModel)
    }
    
    func showButtonState(isButtonYesEnabled: Bool, isButtonNoEnabled: Bool) {
        viewController?.showButtonState(isButtonYesEnabled: isButtonYesEnabled, isButtonNoEnabled: isButtonNoEnabled)
    }
    
    func buttonYes() {
        didAnswer(isYes: true)
        isButtonYesEnabled = false
        isButtonNoEnabled = false
        viewController?.showButtonState(isButtonYesEnabled: isButtonYesEnabled, isButtonNoEnabled: isButtonNoEnabled)
    }
    
    func buttonNo() {
        didAnswer(isYes: false)
        isButtonYesEnabled = false
        isButtonNoEnabled = false
        viewController?.showButtonState(isButtonYesEnabled: isButtonYesEnabled, isButtonNoEnabled: isButtonNoEnabled)
    }
    
    func didAnswer(isYes: Bool) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        let givenAnswer: Answer = isYes ? .yes : .not
        let isCorrect = givenAnswer == currentQuestion.correctAnswer
        viewController?.showAnswerResult(isCorrect: isCorrect)
    }
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        let questionStep = QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)"
        )
        return questionStep
    }
    
    private func itLastQuestion() -> Bool {
        currentQuestionIndex == questionsAmount - 1
    }
    
    private func resetQuestionIndex() {
        currentQuestionIndex = 0
    }
    
    private func switchToNextQuestion() {
        currentQuestionIndex += 1
    }
}
