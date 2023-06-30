//
//  AlertPresenterError.swift
//  MovieQuiz
//
//  Created by Eduard Karimov on 30.06.2023.
//

import Foundation
import UIKit

protocol AlertPresenterError {
    
    func showError (alertPresentError: AlertModelError)
    
}

final class AlertPresenterErrorImplementasion {
    
    private weak var viewControllerError: UIViewController?

    init(viewControllerError: UIViewController? = nil) {
        self.viewControllerError = viewControllerError
    }
    
}

extension AlertPresenterErrorImplementasion: AlertPresenterError {
    
    func showError(alertPresentError: AlertModelError) {
        let alertError = UIAlertController(
            title: alertPresentError.title,
            message: alertPresentError.message,
            preferredStyle: .alert)
        
        let action = UIAlertAction(title: alertPresentError.buttonText, style: .default) { _ in
        }
        
        alertError.addAction(action)
        
        viewControllerError?.present(alertError, animated: true)
    }
}
