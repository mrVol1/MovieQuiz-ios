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
    internal weak var delegate: QuestionFactoryDelegate?
    weak var viewController: MovieQuizViewController?
    private let questionsAmount: Int = 10
    private var currentQuestion: QuizQuestion?
    private var questionFactory: QuestionFactoryProtocol?
    private var alertPresent: AlertPresent?
    private var alertPresenterError: AlertPresenterError?
    private var statisticService: StatisticService?
    private var currentQuestionIndex = 0
    private var isButtonYesEnabled = true
    private var isButtonNoEnabled = true
    private var randomWord = "больше"
    init(viewController: MovieQuizViewController,
         statisticServiceFactory: StatisticServiceFactory,
         alertPresent: AlertPresent) {
        self.viewController = viewController
        self.questionFactory =
                        QuestionFactory(moviesLoader: MoviesLoader(
                            networkClient: NetworkClient(apiKey: MoviesLoader.apiKey)
                        ),
                        delegate: self,
                        randomWord: randomWord)
        self.questionFactory?.loadData()
        self.statisticService = statisticServiceFactory.makeStaticService()
        self.alertPresent = alertPresent
    }
    // MARK: - Loader Indicator
    func showLoadingIndicator() {
        viewController?.showLoadingIndicator()
    }
    func hideLoadingIndicator() {
        viewController?.hideLoadingIndicator()
    }
    // MARK: - QuestionFactoryDelegate
    func didLoadDataFromServer() {
        viewController?.hideLoadingIndicator()
        questionFactory?.requestNextQuestion()
    }
    func didFailToLoadData(with error: Error) {
        let message = error.localizedDescription
        viewController?.showNetworkError(message: message)
    }
    // MARK: - QuestionFactoryDelegate
    /// метод делегата
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            return
        }
        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.show(quiz: viewModel)
        }
    }
    // MARK: - Main Func
    func restartGame() {
        currentQuestionIndex = 0
        viewController?.correctAnswers = 0
        questionFactory?.requestNextQuestion()
    }
    /// функции для представления currentQuestionIndex и questionsAmount в других слоях
    func itLastQuestion() -> Bool {
        currentQuestionIndex == questionsAmount - 1
    }
    func resetQuestionIndex() {
        currentQuestionIndex = 0
    }
    func switchToNextQuestion() {
        currentQuestionIndex += 1
    }
    /// функция, которая конвертирует полученные данные
    func convert(model: QuizQuestion) -> QuizStepViewModel {
        let questionStep = QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
        return questionStep
    }
    /// функция показа следующего вопроса или показывает результат
    func showNextQuestionOrResults() {
        if self.itLastQuestion() {
            showQuizResult()
        } else {
            self.switchToNextQuestion()
            DispatchQueue.main.async { [weak self] in
                guard let currentQuestion = self?.currentQuestion else {
                    return
                }
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
    /// функция, которая показывает результат квиза
    func showQuizResult() {
        statisticService?.store(correct: viewController?.correctAnswers ?? 0, total: questionsAmount)
        guard let statisticService = statisticService else {
            assertionFailure("Ошибка игры")
            return
        }
        let message =
            """
    Ваш результат: \(viewController?.correctAnswers ?? 0)/\(questionsAmount),
    Количество сыгранных квизов: \(statisticService.gamesCount),
    Рекорд: \(statisticService.bestGame?.correct ?? 0)/10 (\((statisticService.bestGame?.date.dateTimeString)
    ?? "Ошибка времени")),
    Средняя точность \(String(format: "%.2f", statisticService.totalAccuracy))
"""
        let viewModel = AlertModel(
            title: "Этот раунд окончен!",
            message: message,
            buttonText: "Сыграть ещё раз",
            completion: { [weak self] in
                self?.viewController?.correctAnswers = 0
                self?.resetQuestionIndex()
                self?.questionFactory?.requestNextQuestion()
            }
        )
        alertPresent?.show(alertPresent: viewModel)
    }
    /// метод для определения состояния кнопки
    func showButtonState(isButtonYesEnabled: Bool, isButtonNoEnabled: Bool) {
        viewController?.showButtonState(isButtonYesEnabled: isButtonYesEnabled, isButtonNoEnabled: isButtonNoEnabled)
    }
    /// метод показывающий, что произошла ошибка в сети
    func showNetworkError(message: String) {
        viewController?.hideLoadingIndicator()
        let model = AlertModel(title: "Ошибка",
                               message: message,
                               buttonText: "Попробовать еще раз") { [weak self] in self?.restartGame()
        }
        alertPresent?.show(alertPresent: model)
    }
    func showImageLoadingError() {
        viewController?.hideLoadingIndicator()
        let alert = AlertModelError(
            title: "Ошибка загрузки изображения",
            message: "Не удалось загрузить постер фильма",
            buttonText: "Попробовать еще раз") { [weak self] in
                self?.restartGame()
            }
        alertPresenterError?.showImageError(alertPresentError: alert)
    }
    // MARK: - Buttons
    /// Кнопка да
    func buttonYes() {
        didAnswer(isYes: true)
        isButtonYesEnabled = false
        isButtonNoEnabled = false
        viewController?.showButtonState(isButtonYesEnabled: isButtonYesEnabled, isButtonNoEnabled: isButtonNoEnabled)
    }
    /// Кнопка нет
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
        let isCorrect: Bool
        if givenAnswer == currentQuestion.correctAnswer {
            isCorrect = true
        } else {
            isCorrect = false
        }
        viewController?.showAnswerResult(isCorrect: isCorrect)
    }
}
