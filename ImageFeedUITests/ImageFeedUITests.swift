//
//  ImageFeedUITests.swift
//  ImageFeedUITests
//
//  Created by Aleksandr Garipov on 14.05.2023.
//

import XCTest

final class ImageFeedUITests: XCTestCase {
    
    private let app = XCUIApplication()
    
    private let yourEmail = "your email"
    private let yourPassword = "your password"
    private let fullName = "your firstName + lastName"
    private let yourUserName = "your @username"
    
    override func setUpWithError() throws {
        
        continueAfterFailure = false
        
        app.launch()
        
    }
    
    func testAuth() throws {
        
        app.buttons["Authenticate"].tap()
        
        let webView = app.webViews["UnsplashWebView"]
        
        XCTAssertTrue(webView.waitForExistence(timeout: 5))
        
        let passwordTextFiled = webView.descendants(matching: .secureTextField).element
        XCTAssertTrue(passwordTextFiled.waitForExistence(timeout: 5))
        
        passwordTextFiled.tap()
        sleep(3)
        passwordTextFiled.typeText(yourPassword)
        webView.swipeUp()
        
        
        let loginTextFiled = webView.descendants(matching: .textField).element
        XCTAssertTrue(loginTextFiled.waitForExistence(timeout: 5))
        
        loginTextFiled.tap()
        sleep(3)
        loginTextFiled.typeText(yourEmail)
        webView.swipeUp()
        XCTAssertTrue(webView.waitForExistence(timeout: 5))
        
        let loginButton = webView.descendants(matching: .button).element
        XCTAssertTrue(loginButton.waitForExistence(timeout: 5))
        loginButton.tap()
        
        let tablesQuery = app.tables
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        
        XCTAssertTrue(cell.waitForExistence(timeout: 5))
        
        
        print(app.debugDescription)
        
    }
    
    func testFeed() throws {
        
        let tablesQuery = app.tables
        
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        cell.swipeUp()
        
        sleep(2)
        
        let cellToLike = tablesQuery.children(matching: .cell).element(boundBy: 1)
        
        cellToLike.buttons["likeButton"].tap()
        sleep(5)
        cellToLike.buttons["likeButton"].tap()
        sleep(5)
        
        cellToLike.tap()
        sleep(5)
        
        let image = app.scrollViews.images.element(boundBy: 0)
        image.pinch(withScale: 3, velocity: 1)
        image.pinch(withScale: 0.5, velocity: -1)
        
        let navBackButton = app.buttons["backButton"]
        navBackButton.tap()
        
    }
    
    func testProfile() throws {
        sleep(3)
        app.tabBars.buttons.element(boundBy: 1).tap()
        
        XCTAssertTrue(app.staticTexts[fullName].exists)
        XCTAssertTrue(app.staticTexts[yourUserName].exists)
        
        app.buttons["logoutButton"].tap()
        
        app.alerts["logoutAlert"].scrollViews.otherElements.buttons["Yes"].tap()
    }
}
