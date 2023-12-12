//
//  ApiManagersTests.swift
//  SeaSwiftAndSun-SimplonTests
//
//  Created by Amelie Pocchiolo on 12/12/2023.
//

import XCTest
@testable import SeaSwiftAndSun_Simplon

final class ApiManagerTests: XCTestCase {
    
    var apiManager = APIManager()
    var apiManagerMock = APIManagerMock()

    func testGetSuccess() throws {
        // Given
        var data: APIManagerMock.MockData? = nil
        // When
        runAsyncTest {
            data = try await self.apiManager.get(url: self.apiManagerMock.url)
        }
        // Then
        XCTAssertNotNil(data)
    }
}

class APIManagerMock {
    
    let url = "https://api.publicapis.org/entries"
    
    // MARK: - Welcome
    struct MockData: Codable {
        let count: Int
        let entries: [Entry]
    }

    // MARK: - Entry
    struct Entry: Codable {
        let api, description: String
        let auth: Auth
        let https: Bool
        let cors: Cors
        let link: String
        let category: String

        enum CodingKeys: String, CodingKey {
            case api = "API"
            case description = "Description"
            case auth = "Auth"
            case https = "HTTPS"
            case cors = "Cors"
            case link = "Link"
            case category = "Category"
        }
    }

    enum Auth: String, Codable {
        case apiKey = "apiKey"
        case empty = ""
        case oAuth = "OAuth"
        case userAgent = "User-Agent"
        case xMashapeKey = "X-Mashape-Key"
    }

    enum Cors: String, Codable {
        case no = "no"
        case unknown = "unknown"
        case unkown = "unkown"
        case yes = "yes"
    }
}
