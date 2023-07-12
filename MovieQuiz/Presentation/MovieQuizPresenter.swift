//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Eduard Karimov on 12.07.2023.
//

import Foundation
import UIKit

final class MovieQuizPresenter {
    var currentQuestion: QuizQuestion?
    weak var viewController: MovieQuizViewController?
    var correctAnswers: Int = 0
    private var currentQuestionIndex = 0
    let questionsAmount: Int = 10
    var questionFactory: QuestionFactoryProtocol?
    var myButtonYes: UIButton?
    var myButtonNo: UIButton?
    var alertPresent: AlertPresent?
    var statisticService: StatisticService?
    // MARK: - Main Func
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
        myButtonYes?.isEnabled = true
        myButtonNo?.isEnabled = true
    }
    /// функция, которая показывает результат квиза
    func showQuizResult() {
        statisticService?.store(correct: correctAnswers, total: self.questionsAmount)
        guard let statisticService = statisticService else {
            assertionFailure("Ошибка игры")
            return
        }
        let message =
            """
    Ваш результат: \(correctAnswers)/\(questionsAmount),
    Количество сыгранных квизов: \(statisticService.gamesCount),
    Рекорд: \(statisticService.bestGame?.correct ?? 0)/10 (\((statisticService.bestGame?.date.dateTimeString) ?? "Ошибка времени")),
    Средняя точность \(String(format: "%.2f", statisticService.totalAccuracy))
"""
        let viewModel = AlertModel(
            title: "Этот раунд окончен!",
            message: message,
            buttonText: "Сыграть ещё раз",
            completion: { [weak self] in
                self?.correctAnswers = 0
                self?.resetQuestionIndex()
                self?.questionFactory?.requestNextQuestion()
            }
        )
        alertPresent?.show(alertPresent: viewModel)
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
    // MARK: - Buttons
    /// Кнопка да
    func buttonYes() {
        didAnswer(isYes: true)
    }
    /// Кнопка нет
    func buttonNo() {
        didAnswer(isYes: false)
    }
    private func didAnswer(isYes: Bool) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        let givenAnswer = isYes
        viewController?.showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
}
