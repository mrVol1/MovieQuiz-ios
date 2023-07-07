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
        expectation = expectation(description: "Loading expectation")
    }

    override func tearDown() {
        expectation = nil
        super.tearDown()
    }

    func testSuccessLoading() throws {
        // Given
        let stubNetworkClient = StubNetworkClient(emulateError: false)
        let loader = MoviesLoader(stubNetworkClient: stubNetworkClient)
        // When
        loader.loadMovies { result in
            // Then
            switch result {
            case .success(let movies):
                XCTAssertEqual(movies.movies.count, 250)
                self.expectation.fulfill()
            case .failure(let error):
                XCTFail("Unexpected failure: \(error)")
            }
        }
        waitForExpectations(timeout: 2)
    }

    func testErrorLoading() throws {
        // Given
        let stubNetworkClient = StubNetworkClient(emulateError: true)
        let loader = MoviesLoader(stubNetworkClient: stubNetworkClient)
        // When
        loader.loadMovies { result in
            // Then
            switch result {
            case .failure(let error):
                XCTAssertNotNil(error)
                self.expectation.fulfill()
            case .success(_):
                XCTFail("Unexpected success")
            }
        }
        waitForExpectations(timeout: 5)
    }
}
