//
//  NYTMovieReviewTests.swift
//  NYTMovieReviewTests
//
//  Created by Kevin Phua on 2020/1/23.
//  Copyright © 2020 HagarSoft. All rights reserved.
//

import XCTest
@testable import NYTMovieReview

class NYTMovieReviewTests: XCTestCase {
    
    var vc: ReviewListViewController!

    override func setUp() {
        super.setUp()
        
        vc = ReviewListViewController()
        vc.loadView()
        vc.viewDidLoad()
    }

    override func tearDown() {
        super.tearDown()
    }
    
    func testThatViewLoads() {
        XCTAssertNotNil(vc.view, "View not instantiated properly")
    }
    
    func testThatTableViewLoads() {
        XCTAssertNotNil(vc.tableView, "Table view not initiated")
    }

    func testThatViewConformsToUITableViewDataSource() {
        XCTAssertTrue(vc.conforms(to: UITableViewDataSource.self), "View does not conform to UITableView datasource protocol")
    }
     
    func testThatTableViewHasDataSource() {
        XCTAssertNotNil(vc.tableView.dataSource, "Table datasource cannot be nil")
    }
     
    func testThatViewConformsToUITableViewDelegate() {
        XCTAssertTrue(vc.conforms(to: UITableViewDelegate.self), "View does not conform to UITableView delegate protocol")
    }
     
    func testTableViewIsConnectedToDelegate() {
        XCTAssertNotNil(vc.tableView.delegate, "Table delegate cannot be nil")
    }
          
}
