//
//  GhostAdmin.swift
//  Ghost-ios
//
//  Created by Criss Myers on 06/09/2019.
//  Copyright © 2019 Mission Labs. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

public final class GhostAdmin {
    
    private var disposeBag = DisposeBag()
    
    public init() {}
    
    public let ghostSiteSubject = PublishSubject<Subject>()
    public let ghostPostSubject = PublishSubject<Subject>()
    public let ghostImageSubject = PublishSubject<Subject>()
    
    public func getSite(_ completion: ((GhostError?, Bool, Any?) -> Void)? = nil) {
        GhostAPI.shared.rxGetSite()
            .retry(3)
            .subscribe { [weak self] event in
                guard let _ = self else { return }
                switch event {
                case .next(let element):
                    if let sites = element as? GhostSites {
                        self?.ghostSiteSubject.onNext(Subject(anObject: sites.site))
                        if completion != nil { completion!(nil, true, sites.site) }
                    }
                case .completed: break
                case .error(let error):
                    self?.ghostSiteSubject.onNext(Subject(anError: error as! GhostError))
                    if completion != nil {completion!(error as? GhostError, false, nil) }
                }
            }.disposed(by: disposeBag)        
    }
    
    public func createPost(_ post: GhostPost, completion: ((GhostError?, Bool, Any?) -> Void)? = nil) {
        var posts = GhostPosts()
        posts.posts.append(post)
        GhostAPI.shared.rxCreate(posts: posts)
            .retry(3)
            .subscribe { [weak self] event in
                guard let _ = self else { return }
                switch event {
                case .next(let element):
                    if let posts = element as? GhostPosts {
                        self?.ghostPostSubject.onNext(Subject(anObject: posts.posts))
                        if completion != nil { completion!(nil, true, posts.posts) }
                    }
                case .completed: break
                case .error(let error):
                    self?.ghostPostSubject.onNext(Subject(anError: error as! GhostError))
                    if completion != nil {completion!(error as? GhostError, false, nil) }
                }
            }.disposed(by: disposeBag)
    }
    
    public func deletePost(_ post: GhostPost, completion: ((GhostError?, Bool, Any?) -> Void)? = nil) {
        GhostAPI.shared.rxDelete(by: post.id ?? "")
            .retry(3)
            .subscribe { [weak self] event in
                guard let _ = self else { return }
                switch event {
                case .next(let element):
                    if let posts = element as? GhostPosts {
                        self?.ghostPostSubject.onNext(Subject(anObject: posts.posts))
                        if completion != nil { completion!(nil, true, posts.posts) }
                    }
                case .completed: break
                case .error(let error):
                    self?.ghostPostSubject.onNext(Subject(anError: error as! GhostError))
                    if completion != nil {completion!(error as? GhostError, false, nil) }
                }
            }.disposed(by: disposeBag)
    }
    
    public func editPost(_ post: GhostPost, id: String, completion: ((GhostError?, Bool, Any?) -> Void)? = nil) {
        var posts = GhostPosts()
        posts.posts.append(post)
        GhostAPI.shared.rxEdit(posts: posts, id: id)
            .retry(3)
            .subscribe { [weak self] event in
                guard let _ = self else { return }
                switch event {
                case .next(let element):
                    if let posts = element as? GhostPosts {
                        self?.ghostPostSubject.onNext(Subject(anObject: posts.posts))
                        if completion != nil { completion!(nil, true, posts.posts) }
                    }
                case .completed: break
                case .error(let error):
                    self?.ghostPostSubject.onNext(Subject(anError: error as! GhostError))
                    if completion != nil {completion!(error as? GhostError, false, nil) }
                }
            }.disposed(by: disposeBag)
    }
    
    public func uploadImage(_ image: UIImage, purpose: String, name: String, completion: ((GhostError?, Bool, Any?) -> Void)? = nil) {
        GhostAPI.shared.rxUploadImage(image, purpose: purpose, name: name)
            .retry(3)
            .subscribe { [weak self] event in
                guard let _ = self else { return }
                switch event {
                case .next(let element):
                    if let images = element as? GhostImages {
                        self?.ghostImageSubject.onNext(Subject(anObject:images.images))
                        if completion != nil { completion!(nil, true, images.images) }
                    }
                case .completed: break
                case .error(let error):
                    self?.ghostImageSubject.onNext(Subject(anError: error as! GhostError))
                    if completion != nil {completion!(error as? GhostError, false, nil) }
                }
        }.disposed(by: disposeBag)
    }
}
