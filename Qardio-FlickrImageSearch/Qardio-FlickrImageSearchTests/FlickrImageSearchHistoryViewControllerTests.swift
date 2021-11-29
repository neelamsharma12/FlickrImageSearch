//
//  FlickrImageSearchHistoryViewControllerTests.swift
//  Qardio-FlickrImageSearchTests
//
//  Created by Neelam Sharma on 29/11/21.
//

import XCTest
@testable import Qardio_FlickrImageSearch

class FlickrImageSearchHistoryViewControllerTests: XCTestCase {

    // MARK: - sut under test
    var viewControllerUnderTest: FlickrImageSearchHistoryViewController!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        viewControllerUnderTest = storyboard.instantiateViewController(withIdentifier: "image_search_history") as? FlickrImageSearchHistoryViewController
        viewControllerUnderTest.loadView()
        viewControllerUnderTest.viewDidLoad()
        viewControllerUnderTest.history = ["kittens", "cat", "Animals", "rose"]
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        viewControllerUnderTest = nil
    }
    
    func test_sut_has_a_tableView() {
        XCTAssertNotNil(viewControllerUnderTest.historyTableView)
    }

    func test_tableview_has_delegate() {
        XCTAssertNotNil(viewControllerUnderTest.historyTableView.delegate)
    }

    func test_tableview_conforms_to_tableview_delegate_protocol() {
        XCTAssertFalse(viewControllerUnderTest.conforms(to: UITableViewDelegate.self))
    }

    func test_tableview_has_dataSource() {
        XCTAssertNotNil(viewControllerUnderTest.historyTableView.dataSource)
    }

    func test_tableview_conforms_to_tableview_datasource_protocol() {
        XCTAssertTrue(viewControllerUnderTest.conforms(to: UITableViewDataSource.self))
        XCTAssertTrue(viewControllerUnderTest.responds(to: #selector(viewControllerUnderTest.tableView(_:numberOfRowsInSection:))))
        XCTAssertTrue(viewControllerUnderTest.responds(to: #selector(viewControllerUnderTest.tableView(_:cellForRowAt:))))
    }

    func test_tableview_cell_has_reuse_identifier() {
        let cell = viewControllerUnderTest.tableView(viewControllerUnderTest.historyTableView, cellForRowAt: IndexPath(row: 0, section: 0))
        let actualReuseIdentifier = cell.reuseIdentifier
        let expectedReuseIdentifier = "historyCell"

        /// Assert
        XCTAssertEqual(actualReuseIdentifier, expectedReuseIdentifier)
    }

}
