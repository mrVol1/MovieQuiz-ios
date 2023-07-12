//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Eduard Karimov on 12.07.2023.
//

import Foundation
import UIKit

final class MovieQuizPresenter {
    private var currentQuestionIndex = 0
    let questionsAmount: Int = 10
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
}
