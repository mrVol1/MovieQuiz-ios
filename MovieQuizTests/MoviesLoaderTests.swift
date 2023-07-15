//
//  MoviesLoaderTests.swift
//  MovieQuizTests
//
//  Created by Eduard Karimov on 06.07.2023.
//

import XCTest
@testable import MovieQuiz

class MoviesLoaderTests: XCTestCase {
    var expectation: XCTestExpectation!

    override func setUp() {
        super.setUp()
        expectation = XCTestExpectation(description: "Loading expectation")
    }
    override func tearDown() {
        expectation = nil
        super.tearDown()
    }
    func testSuccessLoading() throws {
        // Given
        let stubNetworkClient = StubNetworkClient(emulateError: false)
        let loader = MoviesLoader(stubNetworkClient: stubNetworkClient)
        // Create expectation
        let expectation = XCTestExpectation(description: "Movies loaded")
        // When
        loader.loadMovies { result in
            // Then
            switch result {
            case .success(let movies):
                XCTAssertEqual(movies.movies.count, 250)
                expectation.fulfill()
            case .failure(let error):
                XCTFail("Unexpected failure: \(error)")
            }
        }
        // Wait for the expectation
        wait(for: [expectation], timeout: 5)
    }
    func testErrorLoading() throws {
        // Given
        let stubNetworkClient = StubNetworkClient(emulateError: true)
        let loader = MoviesLoader(stubNetworkClient: stubNetworkClient)
        // When
        var loadingError: Error?
        // Create the expectation using `self.expectation(description:)`
        let errorExpectation = self.expectation(description: "Error expectation")
        loader.loadMovies { result in
            // Then
            switch result {
            case .failure(let error):
                loadingError = error
            case .success(_):
                loadingError = nil
            }
            // Fulfill the expectation inside the completion block
            errorExpectation.fulfill()
        }
        // Wait for the expectation to be fulfilled
        waitForExpectations(timeout: 5)
        if let error = loadingError {
            XCTFail("Unexpected success with error: \(error)")
        }
    }
}
