//
//  AlertPresenterError.swift
//  MovieQuiz
//
//  Created by Eduard Karimov on 30.06.2023.
//

import Foundation
import UIKit

protocol AlertPresenterError {
    func showImageError (alertPresentError: AlertModelError)
    func restartGame()
}

final class AlertPresenterErrorImplementasion {
    private weak var viewControllerError: UIViewController?
    private var questionFactory: QuestionFactory?
    
    init(viewControllerError: UIViewController? = nil, questionFactory: QuestionFactory? = nil) {
        self.viewControllerError = viewControllerError
        self.questionFactory = questionFactory
    }
}

extension AlertPresenterErrorImplementasion: AlertPresenterError {
    func showImageError(alertPresentError: AlertModelError) {
        let alert = UIAlertController(
            title: alertPresentError.title,
            message: alertPresentError.message,
            preferredStyle: .alert
        )
        let action = UIAlertAction(title: alertPresentError.buttonText, style: .default) { _ in
            alertPresentError.completion()
        }
        alert.addAction(action)
        viewControllerError?.present(alert, animated: true, completion: nil)
    }
    
    func restartGame() {
        questionFactory?.loadData()
        questionFactory?.requestNextQuestion()
    }
}
