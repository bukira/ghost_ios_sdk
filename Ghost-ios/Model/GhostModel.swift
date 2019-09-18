//
//  GhostModel.swift
//  Ghost-ios
//
//  Created by Criss Myers on 04/09/2019.
//  Copyright © 2019 Mission Labs. All rights reserved.
//

import Foundation
import RxSwift

public enum Direction {
    case forward, backwards
}

public final class GhostModel {
    
    private var disposeBag = DisposeBag()
    
    public init() {}
    
    public let ghostPostsSubject = PublishSubject<Subject>()
    public let ghostTagsSubject = PublishSubject<Subject>()
    public let ghostAuthorsSubject = PublishSubject<Subject>()
    public let ghostPagesSubject = PublishSubject<Subject>()
    public let ghostSettingsSubject = PublishSubject<Subject>()
    
    public var hasMorePostsAvailable:Bool {
        get {
            if postsPagination?.next != nil { return true }
            return false
        }
    }
    public var hasMoreTagsAvailable:Bool {
        get {
            if tagsPagination?.next != nil { return true }
            return false
        }
    }
    public var hasMoreAuthorsAvailable:Bool {
        get {
            if authorsPagination?.next != nil { return true }
            return false
        }
    }
    public var hasMorePagesAvailable:Bool {
        get {
            if postsPagination?.next != nil { return true }
            return false
        }
    }
    
    internal var postsPagination:Pagination?
    internal var postsConfig:GhostPostConfig?
    internal var tagsPagination:Pagination?
    internal var tagsConfig:GhostTagConfig?
    internal var authorsPagination:Pagination?
    internal var authorsConfig:GhostAuthorConfig?
    
    //MARK: Posts
    public func getPosts(_ config: GhostPostConfig, by id: String? = nil, for slug: String? = nil, completion: ((GhostError?, Bool, Any?) -> Void)? = nil) {
        postsConfig = config
        GhostAPI.shared.rxGetPosts(with: config, for: id, or: slug, page: nil)
            .retry(3)
            .subscribe { [weak self] event in
                guard let _ = self else { return }
                switch event {
                case .next(let element):
                    if let posts = element as? GhostPosts {
                        self?.postsPagination = posts.meta?.pagination
                        self?.ghostPostsSubject.onNext(Subject(anObject: posts.posts))
                        if completion != nil { completion!(nil, true, posts.posts) }
                    }
                case .completed: break
                case .error(let error):
                    self?.ghostPostsSubject.onNext(Subject(anError: error as! GhostError))
                    if completion != nil {completion!(error as? GhostError, false, nil) }
                }
            }.disposed(by: disposeBag)
    }
    
    public func getMorePosts(_ direction: Direction, completion: ((GhostError?, Bool, Any?) -> Void)? = nil) {
        switch direction {
        case .forward:
            if postsPagination?.next != nil {
                GhostAPI.shared.rxGetPosts(with: postsConfig ?? GhostPostConfig(), for: nil, or: nil, page: postsPagination?.next)
                    .retry(3)
                    .subscribe { [weak self] event in
                        guard let _ = self else { return }
                        switch event {
                        case .next(let element):
                            if let posts = element as? GhostPosts {
                                self?.postsPagination = posts.meta?.pagination
                                self?.ghostPostsSubject.onNext(Subject(anObject: posts.posts))
                                if completion != nil { completion!(nil, true, posts.posts) }
                            }
                        case .completed: break
                        case .error(let error):
                            self?.ghostPostsSubject.onNext(Subject(keyValue: "Error"))
                            if completion != nil { completion!(error as? GhostError, false, nil) }
                        }
                    }.disposed(by: disposeBag)
            } else {
                ghostPostsSubject.onNext(Subject(keyValue: "No Most Posts"))
                if completion != nil { completion!(nil, false, nil) }
            }
        case .backwards:
            if postsPagination?.prev != nil {
                GhostAPI.shared.rxGetPosts(with: postsConfig ?? GhostPostConfig(), for: nil, or: nil, page: postsPagination?.prev)
                    .retry(3)
                    .subscribe { [weak self] event in
                        guard let _ = self else { return }
                        switch event {
                        case .next(let element):
                            if let posts = element as? GhostPosts {
                                self?.postsPagination = posts.meta?.pagination
                                self?.ghostPostsSubject.onNext(Subject(anObject: posts.posts))
                                if completion != nil { completion!(nil, true, posts.posts) }
                            }
                        case .completed: break
                        case .error(let error):
                            self?.ghostPostsSubject.onNext(Subject(keyValue: "Error"))
                            if completion != nil { completion!(error as? GhostError, false, nil) }
                        }
                    }.disposed(by: disposeBag)
            } else {
                ghostPostsSubject.onNext(Subject(keyValue: "No More Posts"))
                if completion != nil {completion!(nil, false, nil) }
            }
        }
    }
    
    //MARK: Tags
    public func getTags(_ config: GhostTagConfig, by id: String? = nil, for slug: String? = nil, completion: ((GhostError?, Bool, Any?) -> Void)? = nil) {
        tagsConfig = config
        GhostAPI.shared.rxGetTags(with: config, for: id, or: slug, page: nil)
            .retry(3)
            .subscribe { [weak self] event in
                guard let _ = self else { return }
                switch event {
                case .next(let element):
                    if let tags = element as? GhostTags {
                        self?.tagsPagination = tags.meta?.pagination
                        self?.ghostTagsSubject.onNext(Subject(anObject: tags.tags))
                        if completion != nil { completion!(nil, true, tags.tags) }
                    }
                case .completed: break
                case .error(let error):
                    self?.ghostTagsSubject.onNext(Subject(anError: error as! GhostError))
                    if completion != nil {completion!(error as? GhostError, false, nil) }
                }
            }.disposed(by: disposeBag)
    }
    
    public func getMoreTags(_ direction: Direction, completion: ((GhostError?, Bool, Any?) -> Void)? = nil) {
        switch direction {
        case .forward:
            if tagsPagination?.next != nil {
                GhostAPI.shared.rxGetTags(with: tagsConfig ?? GhostTagConfig(), for: nil, or: nil, page: tagsPagination?.next)
                    .retry(3)
                    .subscribe { [weak self] event in
                        guard let _ = self else { return }
                        switch event {
                        case .next(let element):
                            if let tags = element as? GhostTags {
                                self?.tagsPagination = tags.meta?.pagination
                                self?.ghostTagsSubject.onNext(Subject(anObject: tags.tags))
                                if completion != nil { completion!(nil, true, tags.tags) }
                            }
                        case .completed: break
                        case .error(let error):
                            self?.ghostTagsSubject.onNext(Subject(keyValue: "Error"))
                            if completion != nil { completion!(error as? GhostError, false, nil) }
                        }
                    }.disposed(by: disposeBag)
            } else {
                ghostTagsSubject.onNext(Subject(keyValue: "No Most Tags"))
                if completion != nil { completion!(nil, false, nil) }
            }
        case .backwards:
            if tagsPagination?.prev != nil {
                GhostAPI.shared.rxGetTags(with: tagsConfig ?? GhostTagConfig(), for: nil, or: nil, page: tagsPagination?.prev)
                    .retry(3)
                    .subscribe { [weak self] event in
                        guard let _ = self else { return }
                        switch event {
                        case .next(let element):
                            if let tags = element as? GhostTags {
                                self?.tagsPagination = tags.meta?.pagination
                                self?.ghostTagsSubject.onNext(Subject(anObject: tags.tags))
                                if completion != nil { completion!(nil, true, tags.tags) }
                            }
                        case .completed: break
                        case .error(let error):
                            self?.ghostTagsSubject.onNext(Subject(keyValue: "Error"))
                            if completion != nil { completion!(error as? GhostError, false, nil) }
                        }
                    }.disposed(by: disposeBag)
            } else {
                ghostTagsSubject.onNext(Subject(keyValue: "No More Tags"))
                if completion != nil {completion!(nil, false, nil) }
            }
        }
    }
    
    //MARK: Authors
    public func getAuthors(_ config: GhostAuthorConfig, by id: String? = nil, for slug: String? = nil, completion: ((GhostError?, Bool, Any?) -> Void)? = nil) {
        authorsConfig = config
        GhostAPI.shared.rxGetAuthors(with: config, for: id, or: slug, page: nil)
            .retry(3)
            .subscribe { [weak self] event in
                guard let _ = self else { return }
                switch event {
                case .next(let element):
                    if let authors = element as? GhostAuthors {
                        self?.authorsPagination = authors.meta?.pagination
                        self?.ghostAuthorsSubject.onNext(Subject(anObject: authors.authors))
                        if completion != nil { completion!(nil, true, authors.authors) }
                    }
                case .completed: break
                case .error(let error):
                    self?.ghostAuthorsSubject.onNext(Subject(anError: error as! GhostError))
                    if completion != nil {completion!(error as? GhostError, false, nil) }
                }
            }.disposed(by: disposeBag)
    }
    
    public func getMoreAuthors(_ direction: Direction, completion: ((GhostError?, Bool, Any?) -> Void)? = nil) {
        switch direction {
        case .forward:
            if authorsPagination?.next != nil {
                GhostAPI.shared.rxGetAuthors(with: authorsConfig ?? GhostAuthorConfig(), for: nil, or: nil, page: authorsPagination?.next)
                    .retry(3)
                    .subscribe { [weak self] event in
                        guard let _ = self else { return }
                        switch event {
                        case .next(let element):
                            if let authors = element as? GhostAuthors {
                                self?.authorsPagination = authors.meta?.pagination
                                self?.ghostAuthorsSubject.onNext(Subject(anObject: authors.authors))
                                if completion != nil { completion!(nil, true, authors.authors) }
                            }
                        case .completed: break
                        case .error(let error):
                            self?.ghostAuthorsSubject.onNext(Subject(keyValue: "Error"))
                            if completion != nil { completion!(error as? GhostError, false, nil) }
                        }
                    }.disposed(by: disposeBag)
            } else {
                ghostAuthorsSubject.onNext(Subject(keyValue: "No Most Authors"))
                if completion != nil { completion!(nil, false, nil) }
            }
        case .backwards:
            if authorsPagination?.prev != nil {
                GhostAPI.shared.rxGetAuthors(with: authorsConfig ?? GhostAuthorConfig(), for: nil, or: nil, page: authorsPagination?.prev)
                    .retry(3)
                    .subscribe { [weak self] event in
                        guard let _ = self else { return }
                        switch event {
                        case .next(let element):
                            if let authors = element as? GhostAuthors {
                                self?.authorsPagination = authors.meta?.pagination
                                self?.ghostAuthorsSubject.onNext(Subject(anObject: authors.authors))
                                if completion != nil { completion!(nil, true, authors.authors) }
                            }
                        case .completed: break
                        case .error(let error):
                            self?.ghostAuthorsSubject.onNext(Subject(keyValue: "Error"))
                            if completion != nil { completion!(error as? GhostError, false, nil) }
                        }
                    }.disposed(by: disposeBag)
            } else {
                ghostAuthorsSubject.onNext(Subject(keyValue: "No More Authors"))
                if completion != nil {completion!(nil, false, nil) }
            }
        }
    }
    
    //MARK: Settings
    public func getSettings(_ completion: ((GhostError?, Bool, Any?) -> Void)? = nil) {
        GhostAPI.shared.rxGetSettings()
            .retry(3)
            .subscribe { [weak self] event in
                guard let _ = self else { return }
                switch event {
                case .next(let element):
                    if let settings = element as? GhostSet {
                        self?.ghostSettingsSubject.onNext(Subject(anObject: settings.settings))
                        if completion != nil { completion!(nil, true, settings.settings) }
                    }
                case .completed: break
                case .error(let error):
                    self?.ghostSettingsSubject.onNext(Subject(anError: error as! GhostError))
                    if completion != nil {completion!(error as? GhostError, false, nil) }
                }
            }.disposed(by: disposeBag)
    }
    
    //MARK: Pages
    public func getPages(_ config: GhostPostConfig, by id: String? = nil, for slug: String? = nil, completion: ((GhostError?, Bool, Any?) -> Void)? = nil) {
        postsConfig = config
        GhostAPI.shared.rxGetPages(with: config, for: id, or: slug, page: nil)
            .retry(3)
            .subscribe { [weak self] event in
                guard let _ = self else { return }
                switch event {
                case .next(let element):
                    if let pages = element as? GhostPages {
                        self?.postsPagination = pages.meta?.pagination
                        self?.ghostPagesSubject.onNext(Subject(anObject: pages.pages))
                        if completion != nil { completion!(nil, true, pages.pages) }
                    }
                case .completed: break
                case .error(let error):
                    self?.ghostPagesSubject.onNext(Subject(anError: error as! GhostError))
                    if completion != nil {completion!(error as? GhostError, false, nil) }
                }
            }.disposed(by: disposeBag)
    }
    
    public func getMorePages(_ direction: Direction, completion: ((GhostError?, Bool, Any?) -> Void)? = nil) {
        switch direction {
        case .forward:
            if postsPagination?.next != nil {
                GhostAPI.shared.rxGetPages(with: postsConfig ?? GhostPostConfig(), for: nil, or: nil, page: postsPagination?.next)
                    .retry(3)
                    .subscribe { [weak self] event in
                        guard let _ = self else { return }
                        switch event {
                        case .next(let element):
                            if let pages = element as? GhostPages {
                                self?.postsPagination = pages.meta?.pagination
                                self?.ghostPagesSubject.onNext(Subject(anObject: pages.pages))
                                if completion != nil { completion!(nil, true, pages.pages) }
                            }
                        case .completed: break
                        case .error(let error):
                            self?.ghostPagesSubject.onNext(Subject(keyValue: "Error"))
                            if completion != nil { completion!(error as? GhostError, false, nil) }
                        }
                    }.disposed(by: disposeBag)
            } else {
                ghostPagesSubject.onNext(Subject(keyValue: "No Most Pagess"))
                if completion != nil { completion!(nil, false, nil) }
            }
        case .backwards:
            if postsPagination?.prev != nil {
                GhostAPI.shared.rxGetPages(with: postsConfig ?? GhostPostConfig(), for: nil, or: nil, page: postsPagination?.prev)
                    .retry(3)
                    .subscribe { [weak self] event in
                        guard let _ = self else { return }
                        switch event {
                        case .next(let element):
                            if let pages = element as? GhostPages {
                                self?.postsPagination = pages.meta?.pagination
                                self?.ghostPagesSubject.onNext(Subject(anObject: pages.pages))
                                if completion != nil { completion!(nil, true, pages.pages) }
                            }
                        case .completed: break
                        case .error(let error):
                            self?.ghostPagesSubject.onNext(Subject(keyValue: "Error"))
                            if completion != nil { completion!(error as? GhostError, false, nil) }
                        }
                    }.disposed(by: disposeBag)
            } else {
                ghostPagesSubject.onNext(Subject(keyValue: "No More Pages"))
                if completion != nil {completion!(nil, false, nil) }
            }
        }
    }
}
