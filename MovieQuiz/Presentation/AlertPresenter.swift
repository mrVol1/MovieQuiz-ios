//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Eduard Karimov on 14.06.2023.
//

import Foundation
import UIKit

protocol AlertPresent {
    func show (alertPresent: AlertModel)
}

final class AlertPresentImplementation {

    private weak var viewController: UIViewController?

    init(viewController: UIViewController? = nil) {
        self.viewController = viewController
    }
}

extension AlertPresentImplementation: AlertPresent {
    func show(alertPresent: AlertModel) {
        let alert = UIAlertController(
            title: alertPresent.title,
            message: alertPresent.message,
            preferredStyle: .alert)
        let action = UIAlertAction(title: alertPresent.buttonText, style: .default) { _ in

            alertPresent.completion()
        }
        alert.addAction(action)
        viewController?.present(alert, animated: true)
    }
}
