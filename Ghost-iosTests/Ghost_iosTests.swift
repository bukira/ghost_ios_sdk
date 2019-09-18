//
//  Ghost_iosTests.swift
//  Ghost-iosTests
//
//  Created by Criss Myers on 04/09/2019.
//  Copyright © 2019 Mission Labs. All rights reserved.
//

import XCTest
@testable import Ghost_ios

class Ghost_iosTests: XCTestCase {

    override func setUp() {
        let config = GhostAPIConfig(base: "https://demo.ghost.io", api: "v2", apiKey: "22444f78447824223cefc48062", adminKey: "")
        config.apiLogging = true
        config.logType = 0
        GhostAPI.shared.config = config
    }

    override func tearDown() {}

    //MARK: Local JSON
    func testPosts() {
        let bundle = Bundle(for: type(of: self))
        if let data = convertToData("all", bundle: bundle) {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601Full)
            if let posts = try? decoder.decode(GhostPosts.self, from: data) {
                XCTAssertEqual(posts.posts.count, 15)
                XCTAssertEqual(posts.posts[0].id, "5b7ada404f87d200b5b1f9c8")
            } else {
                XCTAssert(false, "failed to create")
            }
        } else {
            XCTAssert(false, "failed json")
        }
    }
    
    func testPostsWithConfig() {
        let bundle = Bundle(for: type(of: self))
        if let data = convertToData("postsWithConfig", bundle: bundle) {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601Full)
            if let posts = try? decoder.decode(GhostPosts.self, from: data) {
                XCTAssertEqual(posts.posts.count, 5)
            } else {
                XCTAssert(false, "failed to create")
            }
        } else {
            XCTAssert(false, "failed json")
        }
    }
    
    func testTags() {
        let bundle = Bundle(for: type(of: self))
        if let data = convertToData("tags", bundle: bundle) {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601Full)
            if let tags = try? decoder.decode(GhostTags.self, from: data) {
                XCTAssertEqual(tags.tags.count, 1)
                XCTAssertEqual(tags.tags[0].id, "59799bbd6ebb2f00243a33db")
            } else {
                XCTAssert(false, "failed to create")
            }
        } else {
            XCTAssert(false, "failed json")
        }
    }
    
    func testAuthors() {
        let bundle = Bundle(for: type(of: self))
        if let data = convertToData("authors", bundle: bundle) {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601Full)
            if let authors = try? decoder.decode(GhostAuthors.self, from: data) {
                XCTAssertEqual(authors.authors.count, 1)
                XCTAssertEqual(authors.authors[0].id, "5c9a4da453c79000bf19a6f5")
            } else {
                XCTAssert(false, "failed to create")
            }
        } else {
            XCTAssert(false, "failed json")
        }
    }
    
    func testSettings() {
        let bundle = Bundle(for: type(of: self))
        if let data = convertToData("settings", bundle: bundle) {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601Full)
            if let settings = try? decoder.decode(GhostSet.self, from: data) {
                XCTAssertEqual(settings.settings.navigation.count, 4)
                XCTAssertEqual(settings.settings.title, "Ghost")
            } else {
                XCTAssert(false, "failed to create")
            }
        } else {
            XCTAssert(false, "failed json")
        }
    }
    
    //MARK: API
    func testAPIPosts() {
        let expectation = XCTestExpectation(description: "get posts")
        let ghostModel = GhostModel()
        let postsConfig = GhostPostConfig()
        postsConfig.limit = 5
        postsConfig.formats = [.plaintext, .html]
        postsConfig.sort = .nameAsc
        postsConfig.includes = [.tags]
        postsConfig.fields = ["url", "title"]
        postsConfig.filters = ["tag:Fiction"]
        ghostModel.getPosts(postsConfig, by: nil, for: nil) { (error, success, posts) in
            if error != nil {
                XCTAssert(false, "failed json")
                expectation.fulfill()
            }
            if success {
                if let allPosts = posts as? [GhostPost] {
                    XCTAssertEqual(allPosts.count, 4)
                    XCTAssertEqual(allPosts[0].title, "Down The Rabbit Hole")
                    expectation.fulfill()
                }
            }
        }
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testAPIPostByID() {
        let expectation = XCTestExpectation(description: "get post by ID")
        let ghostModel = GhostModel()
        let postsConfig = GhostPostConfig()
        postsConfig.limit = 5
        postsConfig.formats = [.plaintext, .html]
        postsConfig.sort = .nameAsc
        postsConfig.includes = [.tags]
        postsConfig.fields = ["url", "title"]
        postsConfig.filters = ["tag:Fiction"]
        ghostModel.getPosts(postsConfig, by: "5b7ada404f87d200b5b1f9c8", for: nil) { (error, success, post) in
            if error != nil {
                XCTAssert(false, "failed json")
                expectation.fulfill()
            }
            if success {
                if let allPosts = post as? [GhostPost] {
                    XCTAssertEqual(allPosts.count, 1)
                    XCTAssertEqual(allPosts[0].id, "5b7ada404f87d200b5b1f9c8")
                    expectation.fulfill()
                }
            }
        }
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testAPIPostbySlug() {
        let expectation = XCTestExpectation(description: "get post by slug")
        let ghostModel = GhostModel()
        let postsConfig = GhostPostConfig()
        postsConfig.limit = 5
        postsConfig.formats = [.plaintext, .html]
        postsConfig.sort = .nameAsc
        postsConfig.includes = [.tags]
        postsConfig.fields = ["url", "title"]
        postsConfig.filters = ["tag:Fiction"]
        ghostModel.getPosts(postsConfig, by: nil, for: "welcome") { (error, success, post) in
            if error != nil {
                XCTAssert(false, "failed json")
                expectation.fulfill()
            }
            if success {
                if let allPosts = post as? [GhostPost] {
                    XCTAssertEqual(allPosts.count, 1)
                    XCTAssertEqual(allPosts[0].slug, "welcome")
                    expectation.fulfill()
                }
            }
        }
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testAPITags() {
        let expectation = XCTestExpectation(description: "get tags")
        let ghostModel = GhostModel()
        ghostModel.getTags(GhostTagConfig(), by: nil, for: nil) { (error, success, tags) in
            if error != nil {
                XCTAssert(false, "failed json")
                expectation.fulfill()
            }
            if success {
                if let allTags = tags as? [GhostTag] {
                    XCTAssertEqual(allTags.count, 4)
                    expectation.fulfill()
                }
            }
        }
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testAPIAuthors() {
        let expectation = XCTestExpectation(description: "get authors")
        let ghostModel = GhostModel()
        ghostModel.getAuthors(GhostAuthorConfig(), by: nil, for: nil) { (error, success, authors) in
            if error != nil {
                XCTAssert(false, "failed json")
                expectation.fulfill()
            }
            if success {
                if let allAuthors = authors as? [GhostAuthor] {
                    XCTAssertEqual(allAuthors.count, 7)
                    expectation.fulfill()
                }
            }
        }
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testAPIPages() {
        let expectation = XCTestExpectation(description: "get pages")
        let ghostModel = GhostModel()
        ghostModel.getPages(GhostPostConfig(), by: nil, for: nil) { (error, success, pages) in
            if error != nil {
                XCTAssert(false, "failed json")
                expectation.fulfill()
            }
            if success {
                if let allPages = pages as? [GhostPost] {
                    XCTAssertEqual(allPages.count, 1)
                    expectation.fulfill()
                }
            }
        }
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testAPISettings() {
        let expectation = XCTestExpectation(description: "get settings")
        let ghostModel = GhostModel()
        ghostModel.getSettings { (error, success, settings) in
            if error != nil {
                XCTAssert(false, "failed json")
                expectation.fulfill()
            }
            if success {
                if let set = settings as? GhostSettings {
                    XCTAssertEqual(set.navigation.count, 4)
                    XCTAssertEqual(set.title, "Ghost")
                    expectation.fulfill()
                }
            }
        }
        wait(for: [expectation], timeout: 10.0)
    }
}
