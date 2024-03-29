//
//  ImageFeedTests.swift
//  ImageFeedTests
//
//  Created by Aleksandr Garipov on 09.05.2023.
//
@testable import ImageFeed
import XCTest

final class WebViewTests: XCTestCase {
    
    final class WebViewPresenterSpy: WebViewPresenterProtocol {
        var viewDidLoadCalled: Bool = false
        var view: WebViewControllerProtocol?
        
        func viewDidLoad() {
            viewDidLoadCalled = true
        }
        
        func didUpdateProgressValue(_ newValue: Double) {
            
        }
        
        func code(from url: URL) -> String? {
            return nil
        }
    }
    
    final class WebViewControllerSpy: WebViewControllerProtocol {
        var presenter: ImageFeed.WebViewPresenterProtocol?
        
        var loadRequestCalled: Bool = false
        
        func load(request: URLRequest) {
            loadRequestCalled = true
        }
        
        func setProgressValue(_ newValue: Float) {
            
        }
        
        func setProgressHidden(_ isHidden: Bool) {
            
        }
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testViewControllerCallsViewDidLoad() {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "WebViewViewController") as! WebViewViewController
        let presenter = WebViewPresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        _ = viewController.view
        
        XCTAssertTrue(presenter.viewDidLoadCalled)
    }
    
    func testPresenterCallsLoadRequest() {
        let viewController = WebViewControllerSpy()
        let authHelper = AuthHelper()
        let presenter = WebViewPresenter(authHelper: authHelper)
        viewController.presenter = presenter
        presenter.view = viewController
        
        presenter.viewDidLoad()
        
        XCTAssertTrue(viewController.loadRequestCalled)
    }
    
    func testProgressVisibleWhenLessThenOne() {
        
        let authHelper = AuthHelper()
        let presenter  = WebViewPresenter(authHelper: authHelper)
        let progress: Float = 0.6
        
        let shouldHideProgress = presenter.showHideProgress(for: progress)
        
        XCTAssertFalse(shouldHideProgress)
    }
    
    func testProgressHiddenWhenOne() {
        
        let authHelper = AuthHelper()
        let presenter  = WebViewPresenter(authHelper: authHelper)
        let progress: Float = 1.0
        
        let shouldHideProgress = presenter.showHideProgress(for: progress)
        
        XCTAssertTrue(shouldHideProgress)
    }
    
    func testAuthHelperAuthUrl() {
        
        let configuration = AuthConfiguration.standard
        let authHelper = AuthHelper(configuration: configuration)
        
        let url = authHelper.authURL()
        let urlString = url.absoluteString
        
        XCTAssertTrue(urlString.contains(configuration.authURLString))
        XCTAssertTrue(urlString.contains(configuration.accessKey))
        XCTAssertTrue(urlString.contains(configuration.redirectURI))
        XCTAssertTrue(urlString.contains("code"))
        XCTAssertTrue(urlString.contains(configuration.accessScope))
        
    }
    
    func testCodeFromUrl() {
        
        var urlComponents = URLComponents(string: "https://unsplash.com/oauth/authorize/native")!
        
        let codeQueryItem = URLQueryItem(name: "code", value: "test code")
        urlComponents.queryItems = [codeQueryItem]
        let url = urlComponents.url!
        
        let authHelper = AuthHelper()
        
        let code = authHelper.code(from: url)
        
        XCTAssertEqual(code, "test code")
    }

}
