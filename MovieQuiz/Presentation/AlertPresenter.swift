//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Eduard Karimov on 14.06.2023.
//

import Foundation
import UIKit

class AlertPresent {
    
    private var questionFactory: QuestionFactoryProtocol?
    private var currentQuestion: QuizQuestion?
    private var currentQuestionIndex = 0
    private var correctAnswers = 0
    private var questionStep: QuizResultsViewModel?
    private var viewController: MovieQuizViewController?
    
    func show(quiz result: QuizResultsViewModel) {
        let alert = UIAlertController(
            title: result.title,
            message: result.text,
            preferredStyle: .alert)
        
        let action = UIAlertAction(title: result.buttonText, style: .default) { [weak self] _ in
            guard let self = self else { return }
            
            self.currentQuestionIndex = 0
            self.correctAnswers = 0
            
            questionFactory?.requestNextQuestion()
        }
        
        alert.addAction(action)
        
        viewController?.present(alert, animated: true, completion: nil)
    }
}
