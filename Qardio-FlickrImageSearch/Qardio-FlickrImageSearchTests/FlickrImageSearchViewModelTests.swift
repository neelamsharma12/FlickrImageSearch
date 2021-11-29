//
//  Qardio_FlickrImageSearchTests.swift
//  Qardio-FlickrImageSearchTests
//
//  Created by Neelam Sharma on 28/11/21.
//

import XCTest
@testable import Qardio_FlickrImageSearch

class FlickrImageSearchViewModelTests: XCTestCase {

    // MARK: - sut under test
    var sut: FlickrImageSearchViewModel!
    
    // MARK: - DataService and Mocks
    var dataService: ImageDataService!
    let delegate = MockFlickrImageSearchViewModelDelegate()
    
    override func setUpWithError() throws {
        dataService = ImageDataService()
        sut = FlickrImageSearchViewModel(sessionProvider: dataService, delegate: delegate)
        try super.setUpWithError()
    }

    override func tearDownWithError() throws {
       try super.tearDownWithError()
        sut = nil
        delegate.isDidLoadImageListCalled = false
        delegate.isFailLoadingImageCalled = false
    }
    
    func test_load_image_list_with_search_string_should_success() {

        let resultExpectation = expectation(description: "wait expectation")

        /// Act
        sut.getImageList(forSearchString: "Kittens", pageNumber: 1)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 25.0) {
            resultExpectation.fulfill()
        }
        wait(for: [resultExpectation], timeout: 25.0)
        
        XCTAssertTrue(delegate.isDidLoadImageListCalled)
        XCTAssertFalse(delegate.isFailLoadingImageCalled)
    }
    
    func test_load_image_list_with_empty_search_string_should_fail() {
        let resultExpectation = expectation(description: "wait expectation")

        /// Act
        sut.getImageList(forSearchString: "", pageNumber: 1)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 25.0) {
            resultExpectation.fulfill()
        }

        wait(for: [resultExpectation], timeout: 25.0)

        XCTAssertFalse(delegate.isDidLoadImageListCalled)
        XCTAssertTrue(delegate.isFailLoadingImageCalled)
    }


    func test_load_image_list_with_unicode_search_string_should_success() {
        let resultExpectation = expectation(description: "wait expectation")
        
        /// Act
        sut.getImageList(forSearchString: "Groß", pageNumber: 1)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 20.0) {
            resultExpectation.fulfill()
        }

        wait(for: [resultExpectation], timeout: 20.0)

        /// Assert
        XCTAssertTrue(delegate.isDidLoadImageListCalled)
        XCTAssertFalse(delegate.isFailLoadingImageCalled)
    }
    
    func test_load_image_list_with_upper_cased_search_string_should_success() {
        let resultExpectation = expectation(description: "wait expectation")
        
        /// Act
        sut.getImageList(forSearchString: "CAT", pageNumber: 1)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 20.0) {
            resultExpectation.fulfill()
        }

        wait(for: [resultExpectation], timeout: 20.0)

        /// Assert
        XCTAssertTrue(delegate.isDidLoadImageListCalled)
        XCTAssertFalse(delegate.isFailLoadingImageCalled)
    }
    
    func test_load_image_list_with_upper_and_lower_cased_search_string_should_success() {
        let resultExpectation = expectation(description: "wait expectation")
        
        /// Act
        sut.getImageList(forSearchString: "FoLoWeR", pageNumber: 1)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 20.0) {
            resultExpectation.fulfill()
        }

        wait(for: [resultExpectation], timeout: 20.0)

        /// Assert
        XCTAssertTrue(delegate.isDidLoadImageListCalled)
        XCTAssertFalse(delegate.isFailLoadingImageCalled)
    }

}
