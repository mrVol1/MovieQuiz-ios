//
//  ArrayTest.swift
//  MovieQuizTests
//
//  Created by Eduard Karimov on 06.07.2023.
//

import XCTest
@testable import MovieQuiz

class ArrayTest: XCTestCase {
    func testGetValueInRange() {
        // Given
        let array = [1,1,2,3,5]
        // When
        let value = array[safe: 2]
        //Then
        XCTAssertNil(value)
        XCTAssertEqual(value, 2)
    }
    
    func testGetValueOutOfRange() {
        // Given
        let array = [1,1,2,3,5]
        // When
        let value = array[safe: 20]
        //Then
        XCTAssertNil(value)
    }
}
