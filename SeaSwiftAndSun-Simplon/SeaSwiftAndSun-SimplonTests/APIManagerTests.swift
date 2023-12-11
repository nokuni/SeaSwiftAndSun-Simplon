//
//  APIManagerTests.swift
//  SeaSwiftAndSun-SimplonTests
//
//  Created by Yann Christophe Maertens on 11/12/2023.
//

import XCTest
import SeaSwiftAndSun_Simplon

final class APIManagerTests: XCTestCase {
    
    var apiManager: APIManager!

    override func setUpWithError() throws {
        apiManager = APIManager()
    }

    override func tearDownWithError() throws {
        apiManager = nil
    }

    func test_get_success() async throws {
        // Given
        let expectation = XCTestExpectation(description: "Expecting get data")
        // TODO: Complete URL
        let url = ""
        // When
        // TODO: Complete Data
        //let data: [Data] = try await apiManager.get(url: url)
        //if !data.isEmpty { expectation.fulfill() }
        // Then
        await fulfillment(of: [expectation])
    }
    
    func test_post_success() async throws {
        // Given
        let expectation = XCTestExpectation(description: "Expecting post data")
        // TODO: Complete value
        //let value = Data.value
        // TODO: Complete URL
        //let url = ""
        // When
        // TODO: Complete Data
        //let data: [TestObject] = try await apiManager.post(url: url, value: value)
        //if !data.isEmpty { expectation.fulfill() }
        // Then
        await fulfillment(of: [expectation])
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
