//
//  ListViewPresenterTests.swift
//  ListViewPresenterTests
//
//  Created by Sam Clewclo on 2/25/17.
//  Copyright © 2017 SamClewlow. All rights reserved.
//

import XCTest
@testable import UserView

class ListViewPresenterTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testLoadingInvokedOnWasDisplayed() {
        
        var callCount = 0
        
        let mockView = MockListView()
        
        // Closure to run assertions when the mock method is called.
        mockView.loadingStateClosure = {show in

            callCount = callCount + 1
        }
        
        // Stub the interactor so real network calls are not made
        let mockInteractor = MockInteractor()
        
        let sut = ListViewPresenter(view: mockView, getUserInteractor: mockInteractor)
        sut.viewWasDisplayed()
        
        XCTAssertEqual(callCount, 2, "showLoadingState should have been called twice to show and hide the indicator")
    }
    
    func testViewModelsGenerated() {
        
        let dummyUsers = getDummyUsers()
        
        var renderViewModelsWasCalled = false
        var getUsersWasCalled = false
        
        let mockView = MockListView()
        
        mockView.renderViewModelsClosure = {viewModels in
            
            renderViewModelsWasCalled = true
            XCTAssertEqual(viewModels.count, dummyUsers.count, "Expected \(dummyUsers.count) view models, but got \(viewModels.count)")
        }
        
        let mockInteractor = MockInteractor()
        mockInteractor.dataToReturn = dummyUsers
        mockInteractor.isSuccess = true
        mockInteractor.getRemoteUsersClosure = { numberRequested in
            
            getUsersWasCalled = true
        }
        
        let sut = ListViewPresenter(view: mockView, getUserInteractor: mockInteractor)
        sut.viewWasDisplayed()
        
        XCTAssert(renderViewModelsWasCalled, "renderViewModels should have been called on view")
        XCTAssert(getUsersWasCalled, "getRemoteUsers should have been called on interactor")
        
    }
    
    func testErrorCaptured() {
        
        var displayErrorWasCalled = false
        var getUsersWasCalled = false
        
        let mockView = MockListView()
        mockView.displayErrorClosure = {error in
            displayErrorWasCalled = true
        }
        
        let mockInteractor = MockInteractor()
        mockInteractor.isSuccess = false
        mockInteractor.getRemoteUsersClosure = { numberRequested in
            
            getUsersWasCalled = true
        }
        
        let sut = ListViewPresenter(view: mockView, getUserInteractor: mockInteractor)
        sut.viewWasDisplayed()
        
        XCTAssert(displayErrorWasCalled, "displayError should have been called on view")
        XCTAssert(getUsersWasCalled, "getRemoteUsers should have been called on interactor")
        
    }
}

extension ListViewPresenterTests {
    
    fileprivate func getDummyUsers() -> [User] {
        
        var arr: [User] = []
        for _ in 0..<5 {
            let user = User(JSON: ["gender": "male",
                                   "dob": "1983-07-14 07:29:45",
                                   "picture": ["medium": "https://randomuser.me/api/portraits/med/men/83.jpg"],
                                   "name":["title": "mr",
                                           "first": "romain",
                                           "last": "hoogmoed"]])
            
            XCTAssertNotNil(user, "Problem creating dummy user")
            arr.append(user!)
        }
        
        return arr
    }
}

// MARK:- Mocks
class MockListView: ListViewProtocol {
    
    var loadingStateClosure: ((Bool) -> ())?
    var renderViewModelsClosure: (([UserViewModel]) -> ())?
    var displayErrorClosure: ((NSError) -> ())?
    
    func showLoadingState(show: Bool) {
        loadingStateClosure?(show)
    }
    
    func displayError(error: NSError) {
        displayErrorClosure?(error)
    }
    
    func renderViewModels(viewModels: [UserViewModel]) {
        renderViewModelsClosure?(viewModels)
    }
}

class MockInteractor: GetRemoteUserInteractor {
    
    var dataToReturn: [User] = []
    var errorToReturn = NSError(domain: "Mockdomain", code: 0, userInfo: nil)
    var isSuccess: Bool = true
    
    var getRemoteUsersClosure: ((Int) -> ())?
    
    override func getRemoteUsers(numberOfUsers: Int, completion: @escaping (GetRemoteUserInteractor.Result) -> ()) {
        
        getRemoteUsersClosure?(numberOfUsers)
        
        if isSuccess {
            completion(.success(dataToReturn))
        } else {
            completion(.failure(errorToReturn))
        }
    }
}


