//
//  MovieQuizUiViewTest.swift
//  MovieQuizUITests
//
//  Created by Eduard Karimov on 15.07.2023.
//

import XCTest
import Foundation
import UIKit
@testable import MovieQuiz

final class MovieQuizUiViewTest: MovieQuizViewControllerProtocol {
    func show(quiz step: MovieQuiz.QuizStepViewModel) {
    }
    func showQuizResult() {
    }
    func showAnswerResult(isCorrect: Bool) {
    }
    func showLoadingIndicator() {
    }
    func hideLoadingIndicator() {
    }
    func showNetworkError(message: String) {
    }
}

final class MovieQuizViewTest: XCTestCase {
    func testViewConvertModel() throws {
        let emptyData = Data()
        let viewControllerMockData = MovieQuizViewController()
        let sut = MovieQuizPresenter(viewController: viewControllerMockData,
                                     statisticServiceFactory: StatisticServiceFactory(), alertPresent: AlertPresentImplementation(viewController: UIViewController()))
        let question = QuizQuestion(image: emptyData, text: "Question Test", correctAnswer: Answer.yes)
        let viewModel = sut.convert(model: question)
        XCTAssertNotNil(viewModel.image)
        XCTAssertEqual(viewModel.question, "Question Test")
        XCTAssertEqual(viewModel.questionNumber, "1/10")
    }
}
