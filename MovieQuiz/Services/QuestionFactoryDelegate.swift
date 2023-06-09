//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Eduard Karimov on 14.06.2023.
//

import Foundation

protocol QuestionFactoryDelegate: AnyObject {
    func didReceiveNextQuestion(question: QuizQuestion?)
    func didLoadDataFromServer() // сообщение об успешной загрузке
    func didFailToLoadData(with error: Error) // сообщение об ошибке загрузки
    func showLoadingIndicator()
    func hideLoadingIndicator()
    func showImageLoadingError()
    func showButtonState(isButtonYesEnabled: Bool, isButtonNoEnabled: Bool)
}
