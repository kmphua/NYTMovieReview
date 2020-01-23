//
//  NYTMovieReviewUITests.swift
//  NYTMovieReviewUITests
//
//  Created by Kevin Phua on 2020/1/23.
//  Copyright © 2020 HagarSoft. All rights reserved.
//

import XCTest

class NYTMovieReviewUITests: XCTestCase {
    
    var app: XCUIApplication!

    override func setUp() {
        app = XCUIApplication()
        app.launchArguments = ["enable-testing"]
        app.launch()
        continueAfterFailure = false
    }

    override func tearDown() {
        app.terminate()
        app = nil
    }

    func testAppLaunch() {
        XCTAssertNotNil(app, "App is not launched")
    }

    func testAppTableReload() {
        app.swipeUp()
    }
    
    func testDetailViewLoaded() {
        app.tables.element.tap()
    }
    
    func testAppTerminate() {
        app.terminate()
    }    
}
