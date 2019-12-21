//
//  ReaderTranslatorMacTests.swift
//  ReaderTranslatorMacTests
//
//  Created by Viktor Kushnerov on 17/12/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//

import XCTest

class ReaderTranslatorMacTests: XCTestCase {
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testSyncBookmarks() {

        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.

        let bookmark1 = BookmarksStore.Bookmark(text: "bookmark1")
        let bookmark2 = BookmarksStore.Bookmark(text: "bookmark2")
        let bookmark3 = BookmarksStore.Bookmark(text: "bookmark3")
        let bookmark4 = BookmarksStore.Bookmark(text: "bookmark4")
        let bookmark5 = BookmarksStore.Bookmark(text: "bookmark5")
        let bookmark6 = BookmarksStore.Bookmark(text: "bookmark6")

        var macBookmarks: BookmarksStore.Bookmarks = [
            bookmark1,
            bookmark2,
            bookmark3,
            bookmark4
        ]

        var playerBookmarks = macBookmarks

        macBookmarks.append(bookmark5)
        macBookmarks.append(bookmark6)
        playerBookmarks.merge(newElements: macBookmarks)
        XCTAssertEqual(playerBookmarks.count, 6, "playerBookmarks must be 6")

        XCTAssertEqual(
            playerBookmarks.first(text: "bookmark2")?.counter,
            0,
            "playerBookmarks.bookmark2 counter must be 0")
        macBookmarks.increase(bookmark: macBookmarks.first(text: "bookmark2"))
        playerBookmarks.merge(newElements: macBookmarks)
        XCTAssertEqual(
            playerBookmarks.first(text: "bookmark2")?.counter,
            1,
            "playerBookmarks.bookmark2 counter must be 1")

        XCTAssertEqual(macBookmarks.first(text: "bookmark3")?.counter, 0, "macBookmarks.bookmark3 counter must be 0")
        macBookmarks.increase(bookmark: macBookmarks.first(text: "bookmark3"))
        macBookmarks.increase(bookmark: macBookmarks.first(text: "bookmark3"))
        macBookmarks.merge(newElements: playerBookmarks)
        XCTAssertEqual(macBookmarks.first(text: "bookmark3")?.counter, 2, "macBookmarks.bookmark3 counter must be 2")

        XCTAssertEqual(macBookmarks.first(text: "bookmark4")?.counter, 0, "macBookmarks.bookmark3 counter must be 0")
        macBookmarks.increase(bookmark: macBookmarks.first(text: "bookmark4"))
        playerBookmarks.increase(bookmark: playerBookmarks.first(text: "bookmark4"))
        macBookmarks.merge(newElements: playerBookmarks)
        XCTAssertEqual(macBookmarks.first(text: "bookmark4")?.counter, 2, "macBookmarks.bookmark3 counter must be 2")
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }
}
