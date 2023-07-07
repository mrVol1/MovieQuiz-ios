//
//  MoviesLoaderTests.swift
//  MovieQuizTests
//
//  Created by Eduard Karimov on 06.07.2023.
//

import XCTest
@testable import MovieQuiz

class MoviesLoaderTests: XCTestCase {
    func testSuccessLoading() throws {
        // Given
        let stubNetworkClient = StubNetworkClient(emulateError: false) // говорим, что не хотим эмулировать ошибку
        let loader = MoviesLoader(networkClient: stubNetworkClient)
        
        // When
        let expectation = expectation(description: "Loading expectation")
        
        loader.loadMovies { result in
            // Then
            switch result {
            case .success(let movies):
                // давайте проверим, что пришло, например, два фильма — ведь в тестовых данных их всего два
                XCTAssertEqual(movies.movies.count, 250)
                expectation.fulfill()
            case .failure(_):
                XCTFail("Unexpected failure")
            }
        }
        waitForExpectations(timeout: 2)
    }
    
    func testErrorLoading() throws {
        // Given
        
        // When
        
        // Then
    }
}

