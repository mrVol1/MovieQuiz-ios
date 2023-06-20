//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Eduard Karimov on 14.06.2023.
//

import Foundation
import UIKit

final class AlertPresent {
    
    private var questionFactory: QuestionFactoryProtocol?
    private var currentQuestionIndex = 0
    private var correctAnswers = 0
    private var viewController: UIViewController?
    private var completion: UIViewController?
    
    init(viewController: UIViewController) {
        self.viewController = viewController
    }
    
    
    func show(alertPresent: AlertModel) {
        let alert = UIAlertController(
            title: alertPresent.title,
            message: alertPresent.message,
            preferredStyle: .alert)
        
        let action = UIAlertAction(title: alertPresent.buttonText, style: .default) { [weak self] _ in
            guard let self = self else { return }
            
            questionFactory?.requestNextQuestion()
            
            alertPresent.completion()
        }
        
        alert.addAction(action)
        
        viewController?.present(alert, animated: true, completion: nil)
    }
}
