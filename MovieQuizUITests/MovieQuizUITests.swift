//
//  MovieQuizUITests.swift
//  MovieQuizUITests
//
//  Created by Eduard Karimov on 08.07.2023.
//

import XCTest

final class MovieQuizUITests: XCTestCase {
    var app: XCUIApplication!

    override func setUpWithError() throws {
        try super.setUpWithError()
        app = XCUIApplication()
        app.launch()
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        app.terminate()
        app = nil
    }
    
    func testButtonYes() {
            sleep(3)
        let firstPoster = app.images["Poster"]
        let firstPosterData = firstPoster.screenshot().pngRepresentation
        app.buttons["Yes"].tap()
            sleep(3)
        let secondPoster = app.images["Poster"]
        let secondPosterData = secondPoster.screenshot().pngRepresentation
        XCTAssertNotEqual(firstPosterData, secondPosterData)
        let indexLabel = app.staticTexts["Index"]
        XCTAssertEqual(indexLabel.label, "2/10")
        
    }
    func testButtonNo() {
        sleep(3)
        let firstPoster = app.images["Poster"]
        let firstPosterData = firstPoster.screenshot().pngRepresentation
        app.buttons["No"].tap()
        sleep(3)
        let secondPoster = app.images["Poster"]
        let secondPosterData = secondPoster.screenshot().pngRepresentation
        XCTAssertNotEqual(firstPosterData, secondPosterData)
        let indexLabel = app.staticTexts["Index"]
        XCTAssertEqual(indexLabel.label, "2/10")
    }
    
    func testGameFinish() {
        sleep(2)
        for _ in 1...10 {
            app.buttons["No"].tap()
            sleep(2)
        }
        // Ищем алерт с заданным заголовком
        let predicate = NSPredicate(format: "label == %@", "Этот раунд окончен!")
        let alert = app.alerts.element(matching: predicate)
        // Проверяем, что алерт существует
        XCTAssertTrue(alert.exists)
        // Далее продолжаем с проверками и взаимодействием с алертом, например:
        XCTAssertTrue(alert.buttons["Сыграть ещё раз"].exists)
        alert.buttons["Сыграть ещё раз"].tap()
        // Проверяем, что алерт больше не существует
        XCTAssertFalse(alert.exists)
    }

    func testAlertDismiss() {
        sleep(2)
        for _ in 1...10 {
            app.buttons["Yes"].tap()
            sleep(2)
        }
        let predicate = NSPredicate(format: "label == %@", "Этот раунд окончен!")
        let alert = app.alerts.element(matching: predicate)
        XCTAssertTrue(alert.buttons["Сыграть ещё раз"].exists)
        alert.buttons["Сыграть ещё раз"].tap()
        sleep(2)
        let indexLabel = app.staticTexts["Index"]
        XCTAssertFalse(alert.exists)
        XCTAssertTrue(indexLabel.label == "1/10")
    }
}
