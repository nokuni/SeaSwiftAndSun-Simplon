//
//  ViewControllerTests.swift
//  SeaSwiftAndSun-SimplonTests
//
//  Created by Amelie Pocchiolo on 12/12/2023.
//

import XCTest
import SwiftUI
@testable import SeaSwiftAndSun_Simplon

final class ViewControllerTests: XCTestCase {
    var viewController = ViewController()

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

    func testNumberOfSections() {
        let tableView = UITableView()

        let numberOfSections = viewController.numberOfSections(in: tableView)

        XCTAssertEqual(numberOfSections, SurfBreak.allCases.count)
    }
    
    func testTitleForHeaderInSection() {
        let tableView = UITableView()

        // Test section 1
        let title1 = viewController.tableView(tableView, titleForHeaderInSection: 1)
        XCTAssertEqual(title1, SurfBreak.beachBreak.rawValue)

        // Test section 2
        let title2 = viewController.tableView(tableView, titleForHeaderInSection: 2)
        XCTAssertEqual(title2, SurfBreak.reefBreak.rawValue)

        // Test section 3
        let title3 = viewController.tableView(tableView, titleForHeaderInSection: 3)
        XCTAssertEqual(title3, SurfBreak.pointBreak.rawValue)

        // Test default section
        let defaultTitle = viewController.tableView(tableView, titleForHeaderInSection: 0)
        XCTAssertEqual(defaultTitle, SurfBreak.outerBanks.rawValue)
    }
}
