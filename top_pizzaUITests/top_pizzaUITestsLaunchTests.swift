//
//  top_pizzaUITestsLaunchTests.swift
//  top_pizzaUITests
//
//  Created by Anastasia Tyutinova on 23/7/2568 BE.
//

import XCTest

final class TopPizzaUITestsLaunchTests: XCTestCase {

//    override class var runsForEachTargetApplicationUIConfiguration: Bool {
//        true
//    }

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    @MainActor
    func testLaunch() throws {
        let app = XCUIApplication()
        app.launch()

        // Insert steps here to perform after app launch but before taking a screenshot,
        // such as logging into a test account or navigating somewhere in the app

        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Launch Screen"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
