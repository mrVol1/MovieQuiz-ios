//
//  MovieQuizViewControllerProtocol.swift
//  MovieQuiz
//
//  Created by Eduard Karimov on 15.07.2023.
//

import Foundation

protocol MovieQuizViewControllerProtocol: AnyObject {
    func show(quiz step: QuizStepViewModel)
    func showQuizResult()
    func showAnswerResult(isCorrect: Bool)
    func showLoadingIndicator()
    func hideLoadingIndicator()
    func showNetworkError(message: String)
    func showButtonState(isButtonYesEnabled: Bool, isButtonNoEnabled: Bool)
    func showImageLoadingError()
    var correctAnswers: Int { get set }
}
