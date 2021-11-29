//
//  FlickrImageSearchViewControllerTests.swift
//  Qardio-FlickrImageSearchTests
//
//  Created by Neelam Sharma on 29/11/21.
//

import XCTest
@testable import Qardio_FlickrImageSearch

class FlickrImageSearchViewControllerTests: XCTestCase {

    // MARK: - sut under test
    var viewControllerUnderTest: FlickrImageSearchViewController!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        viewControllerUnderTest = storyboard.instantiateViewController(withIdentifier: "image_list_view") as? FlickrImageSearchViewController
        viewControllerUnderTest.loadView()
        viewControllerUnderTest.viewDidLoad()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        viewControllerUnderTest = nil
    }
    
    func test_sut_has_a_collectionView() {
        XCTAssertNotNil(viewControllerUnderTest.collectionView)
    }

    func test_sut_has_a_searchController() {
        XCTAssertNotNil(viewControllerUnderTest.searchController)
    }
    
    func test_collectionView_has_delegate() {
        XCTAssertNotNil(viewControllerUnderTest.collectionView.delegate)
    }

    func test_collectionView_conforms_to_collectionView_delegate_protocol() {
        XCTAssertTrue(viewControllerUnderTest.conforms(to: UICollectionViewDelegate.self))
    }

    func test_collectionView_has_dataSource() {
        XCTAssertNotNil(viewControllerUnderTest.collectionView.dataSource)
    }

    func test_collectionView_conforms_to_collectionView_datasource_protocol() {
        XCTAssertTrue(viewControllerUnderTest.conforms(to: UICollectionViewDataSource.self))
        XCTAssertTrue(viewControllerUnderTest.responds(to: #selector(viewControllerUnderTest.collectionView(_:numberOfItemsInSection:))))
        XCTAssertTrue(viewControllerUnderTest.responds(to: #selector(viewControllerUnderTest.collectionView(_:cellForItemAt:))))
    }

    func test_collectionView_cell_has_reuse_identifier() {
        let cell = viewControllerUnderTest.collectionView(viewControllerUnderTest.collectionView, cellForItemAt: IndexPath(row: 0, section: 0))
        let actualReuseIdentifier = cell.reuseIdentifier
        let expectedReuseIdentifier = FlickrImageSearchViewControllerConstants.cellIdentifier

        /// Assert
        XCTAssertEqual(actualReuseIdentifier, expectedReuseIdentifier)
    }
    
    func test_collectionView_header_size_in_section() {
        let size = viewControllerUnderTest.collectionView(viewControllerUnderTest.collectionView, layout: viewControllerUnderTest.collectionView.collectionViewLayout, referenceSizeForHeaderInSection: 0)
        XCTAssertEqual(size, CGSize.zero)
    }

}
