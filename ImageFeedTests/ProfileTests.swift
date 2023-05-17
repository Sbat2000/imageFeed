//
//  ProfileTests.swift
//  ImageFeedTests
//
//  Created by Aleksandr Garipov on 09.05.2023.
//

@testable import ImageFeed
import XCTest

final class ProfileTests: XCTestCase {
    final class ProfilePresenterSpy: ProfilePresenterProtocol {
 
        
        var delegate: ProfilePresenterDelegate?
        
        var showLogoutAlertCalled: Bool = false
        var cleanCalled: Bool = false
        func logoutButtonPressed() {
            showLogoutAlertCalled = true
            clean()
        }
        
        func clean() {
            cleanCalled = true
        }
    }
    
    final class ProfileViewControllerSpy: ProfileViewControllerProtocol {
        var presenter: ProfilePresenterProtocol?
        
        func didTapLogoutButton() {
            presenter?.logoutButtonPressed()
        }
    }
    
    func testClean() {
        let presenter = ProfilePresenterSpy()
        
        presenter.clean()
        
        XCTAssertTrue(presenter.cleanCalled)
    }
    
    func testDidTapLogoutButton() {
        
        let presenter = ProfilePresenterSpy()
        let view = ProfileViewControllerSpy()
        view.presenter = presenter
        
       
        view.didTapLogoutButton()
        
        XCTAssertTrue(presenter.cleanCalled)
        XCTAssertTrue(presenter.showLogoutAlertCalled)
    }
}
