//
//  GhostAPI.swift
//  Ghost-ios
//
//  Created by Criss Myers on 04/09/2019.
//  Copyright © 2019 Mission Labs. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift

internal extension DateFormatter {
    static let iso8601Full: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
}

/**
 API class
 */
public final class GhostAPI {
    
    private var alamofireManager = Alamofire.SessionManager()
    
    private var networkHandler:GhostNetworkHandler?
    
    /**
     Shared
     */
    public static let shared = GhostAPI()

    private init() {}
    
    deinit {}
    
    public var config:GhostAPIConfig? {
        didSet {
            if config?.adminAPIKey != nil {
                startAdmin()
            }
        }
    }
    
    private func startAdmin() {
        guard let adminAPIKey = config?.adminAPIKey, let apiVersion = config?.apiVersion else { return }
        let tokenGenerator = GhostTokenGenerator(adminAPIKey, apiVersion: apiVersion)
        networkHandler = GhostNetworkHandler(tokenGenerator)
        
        let sessionManager = SessionManager()
        let retrier = networkHandler
        sessionManager.adapter = retrier
        sessionManager.retrier = retrier
        self.alamofireManager = sessionManager
    }
    
    //MARK: Content API
    internal func rxGetPosts(with config: GhostPostConfig, for id: String?, or slug: String?, page: Int?) -> Observable<Any?> {
        return Observable.create({ (observer) -> Disposable in
            guard let _ = self.config else { return Disposables.create {} }
            let request = Alamofire.request(GhostURLBuilder.postsURL(self.config!, id: id, slug: slug),
                                                        method: .get,
                                                        parameters: GhostParmetersBuilder.postParameters(self.config!, postsConfig: config, for: page),
                                                        encoding: URLEncoding.default,
                                                        headers: nil)
                .validate(statusCode: 200..<300)
                .responseString(completionHandler: { response in
                    if self.config!.apiLogging {
                        //Log response and Request if Debug true
                        if self.config!.logType.rawValue == 0 || self.config!.logType.rawValue == 1 {
                            ResponseHandler.log(response)
                        }
                    }
                })
                .responseData(completionHandler: { response in
                    if let data = response.data {
                        let decoder = JSONDecoder()
                        decoder.dateDecodingStrategy = .formatted(.iso8601Full)
                        if let posts = try? decoder.decode(GhostPosts.self, from: data) {
                            observer.onNext(posts)
                            observer.onCompleted()
                        } else if let error = try? decoder.decode(GhostErrors.self, from: data) {
                            observer.onError(GhostError(localizedTitle: error.errors[0].errorType, localizedDescription: error.errors[0].message, code: 0))
                        }
                    } else if let _ = response.result.error {
                        observer.onError(ResponseHandler.error(response))
                    } else {
                        observer.onError(ResponseHandler.error(response))
                    }
                })
            return Disposables.create {
                request.cancel()
            }
        })
    }
   
    internal func rxGetTags(with config: GhostTagConfig, for id: String?, or slug: String?, page: Int?) -> Observable<Any?> {
        return Observable.create({ (observer) -> Disposable in
            guard let _ = self.config else { return Disposables.create {} }
            let request = Alamofire.request(GhostURLBuilder.tagsURL(self.config!, id: id, slug: slug),
                                                        method: .get,
                                                        parameters: GhostParmetersBuilder.tagParameters(self.config!, tagsConfig: config, for: page),
                                                        encoding: URLEncoding.default,
                                                        headers: nil)
                .validate(statusCode: 200..<300)
                .responseString(completionHandler: { response in
                    if self.config!.apiLogging {
                        //Log response and Request if Debug true
                        if self.config!.logType.rawValue == 0 || self.config!.logType.rawValue == 2 {
                            ResponseHandler.log(response)
                        }
                    }
                })
                .responseData(completionHandler: { response in
                    if let data = response.data {
                        let decoder = JSONDecoder()
                        decoder.dateDecodingStrategy = .formatted(.iso8601Full)
                        if let tags = try? decoder.decode(GhostTags.self, from: data) {
                            observer.onNext(tags)
                            observer.onCompleted()
                        } else if let error = try? decoder.decode(GhostErrors.self, from: data) {
                            observer.onError(GhostError(localizedTitle: error.errors[0].errorType, localizedDescription: error.errors[0].message, code: 0))
                        }
                    } else if let _ = response.result.error {
                        observer.onError(ResponseHandler.error(response))
                    } else {
                        observer.onError(ResponseHandler.error(response))
                    }
                })
            return Disposables.create {
                request.cancel()
            }
        })
    }
    
    internal func rxGetAuthors(with config: GhostAuthorConfig, for id: String?, or slug: String?, page: Int?) -> Observable<Any?> {
        return Observable.create({ (observer) -> Disposable in
            guard let _ = self.config else { return Disposables.create {} }
            let request = Alamofire.request(GhostURLBuilder.authorsURL(self.config!, id: id, slug: slug),
                                                        method: .get,
                                                        parameters: GhostParmetersBuilder.authorParameters(self.config!, authorsConfig: config, for: page),
                                                        encoding: URLEncoding.default,
                                                        headers: nil)
                .validate(statusCode: 200..<300)
                .responseString(completionHandler: { response in
                    if self.config!.apiLogging {
                        //Log response and Request if Debug true
                        if self.config!.logType.rawValue == 0 || self.config!.logType.rawValue == 3 {
                            ResponseHandler.log(response)
                        }
                    }
                })
                .responseData(completionHandler: { response in
                    if let data = response.data {
                        let decoder = JSONDecoder()
                        decoder.dateDecodingStrategy = .formatted(.iso8601Full)
                        if let authors = try? decoder.decode(GhostAuthors.self, from: data) {
                            observer.onNext(authors)
                            observer.onCompleted()
                        } else if let error = try? decoder.decode(GhostErrors.self, from: data) {
                            observer.onError(GhostError(localizedTitle: error.errors[0].errorType, localizedDescription: error.errors[0].message, code: 0))
                        }
                    } else if let _ = response.result.error {
                        observer.onError(ResponseHandler.error(response))
                    } else {
                        observer.onError(ResponseHandler.error(response))
                    }
                })
            return Disposables.create {
                request.cancel()
            }
        })
    }
    
    internal func rxGetPages(with config: GhostPostConfig, for id: String?, or slug: String?, page: Int?) -> Observable<Any?> {
        return Observable.create({ (observer) -> Disposable in
            guard let _ = self.config else { return Disposables.create {} }
            let request = Alamofire.request(GhostURLBuilder.pagesURL(self.config!, id: id, slug: slug),
                                                        method: .get,
                                                        parameters: GhostParmetersBuilder.postParameters(self.config!, postsConfig: config, for: page),
                                                        encoding: URLEncoding.default,
                                                        headers: nil)
                .validate(statusCode: 200..<300)
                .responseString(completionHandler: { response in
                    if self.config!.apiLogging {
                        //Log response and Request if Debug true
                        if self.config!.logType.rawValue == 0 || self.config!.logType.rawValue == 4 {
                            ResponseHandler.log(response)
                        }
                    }
                })
                .responseData(completionHandler: { response in
                    if let data = response.data {
                        let decoder = JSONDecoder()
                        decoder.dateDecodingStrategy = .formatted(.iso8601Full)
                        if let pages = try? decoder.decode(GhostPages.self, from: data) {
                            observer.onNext(pages)
                            observer.onCompleted()
                        } else if let error = try? decoder.decode(GhostErrors.self, from: data) {
                            observer.onError(GhostError(localizedTitle: error.errors[0].errorType, localizedDescription: error.errors[0].message, code: 0))
                        }
                    } else if let _ = response.result.error {
                        observer.onError(ResponseHandler.error(response))
                    } else {
                        observer.onError(ResponseHandler.error(response))
                    }
                })
            return Disposables.create {
                request.cancel()
            }
        })
    }
    
    internal func rxGetSettings()  -> Observable<Any?> {
        return Observable.create({ (observer) -> Disposable in
            guard let _ = self.config else { return Disposables.create {} }
            let request = Alamofire.request(GhostURLBuilder.settingsURL(self.config!),
                                                        method: .get,
                                                        parameters: GhostParmetersBuilder.settingsParameters(self.config!),
                                                        encoding: URLEncoding.default,
                                                        headers: nil)
                .validate(statusCode: 200..<300)
                .responseString(completionHandler: { response in
                    if self.config!.apiLogging {
                        //Log response and Request if Debug true
                        if self.config!.logType.rawValue == 0 || self.config!.logType.rawValue == 5 {
                            ResponseHandler.log(response)
                        }
                    }
                })
                .responseData(completionHandler: { response in
                    if let data = response.data {
                        let decoder = JSONDecoder()
                        decoder.dateDecodingStrategy = .formatted(.iso8601Full)
                        if let settings = try? decoder.decode(GhostSet.self, from: data) {
                            observer.onNext(settings)
                        } else if let error = try? decoder.decode(GhostErrors.self, from: data) {
                            observer.onError(GhostError(localizedTitle: error.errors[0].errorType, localizedDescription: error.errors[0].message, code: 0))
                        }
                        observer.onCompleted()
                    } else if let _ = response.result.error {
                        observer.onError(ResponseHandler.error(response))
                    } else {
                        observer.onError(ResponseHandler.error(response))
                    }
                })
            return Disposables.create {
                request.cancel()
            }
        })
    }
    
    //MARK: Admin API
    internal func rxGetSite() -> Observable<Any?> {
        return Observable.create({ (observer) -> Disposable in
            guard let _ = self.config else { return Disposables.create {} }
            let request = self.alamofireManager.request(GhostAdminURLBuilder.siteURL(self.config!),
                                            method: .get,
                                            parameters: nil,
                                            encoding: URLEncoding.default,
                                            headers: nil)
                .validate(statusCode: 200..<300)
                .responseString(completionHandler: { response in
                    if self.config!.apiLogging {
                        //Log response and Request if Debug true
                        if self.config!.logType.rawValue == 0 || self.config!.logType.rawValue == 6 {
                            ResponseHandler.log(response)
                        }
                    }
                })
                .responseData(completionHandler: { response in
                    if let data = response.data {
                        let decoder = JSONDecoder()
                        decoder.dateDecodingStrategy = .formatted(.iso8601Full)
                        if let sites = try? decoder.decode(GhostSites.self, from: data) {
                            observer.onNext(sites)
                            observer.onCompleted()
                        } else if let error = try? decoder.decode(GhostErrors.self, from: data) {
                            observer.onError(GhostError(localizedTitle: error.errors[0].errorType, localizedDescription: error.errors[0].message, code: 0))
                        }
                    } else if let _ = response.result.error {
                        observer.onError(ResponseHandler.error(response))
                    } else {
                        observer.onError(ResponseHandler.error(response))
                    }
                })
            return Disposables.create {
                request.cancel()
            }
        })
    }
    
    internal func rxCreate(posts: GhostPosts) -> Observable<Any?> {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .formatted(DateFormatter.iso8601Full)
        let newPosts = try? encoder.encode(posts)
        var request = URLRequest(url: URL(string: GhostAdminURLBuilder.postsURL(self.config!, id: nil, slug: nil))!)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request.httpBody = newPosts
        return Observable.create({ (observer) -> Disposable in
            guard let _ = self.config else { return Disposables.create {} }
            let request = self.alamofireManager.request(request)
                .validate(statusCode: 200..<300)
                .responseString(completionHandler: { response in
                    if self.config!.apiLogging {
                        //Log response and Request if Debug true
                        if self.config!.logType.rawValue == 0 || self.config!.logType.rawValue == 1 {
                            ResponseHandler.log(response)
                        }
                    }
                })
                .responseData(completionHandler: { response in
                    if let data = response.data {
                        let decoder = JSONDecoder()
                        decoder.dateDecodingStrategy = .formatted(.iso8601Full)
                        if let posts = try? decoder.decode(GhostPosts.self, from: data) {
                            observer.onNext(posts)
                            observer.onCompleted()
                        } else if let error = try? decoder.decode(GhostErrors.self, from: data) {
                            observer.onError(GhostError(localizedTitle: error.errors[0].errorType, localizedDescription: error.errors[0].message, code: 0))
                        }
                    } else if let _ = response.result.error {
                        observer.onError(ResponseHandler.error(response))
                    } else {
                        observer.onError(ResponseHandler.error(response))
                    }
                })
            return Disposables.create {
                request.cancel()
            }
        })
    }
    
    internal func rxEdit(posts: GhostPosts, id: String) -> Observable<Any?> {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .formatted(DateFormatter.iso8601Full)
        let newPosts = try? encoder.encode(posts)
        var request = URLRequest(url: URL(string: GhostAdminURLBuilder.postsURL(self.config!, id: id, slug: nil))!)
        request.httpMethod = HTTPMethod.put.rawValue
        request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request.httpBody = newPosts
        return Observable.create({ (observer) -> Disposable in
            guard let _ = self.config else { return Disposables.create {} }
            let request = self.alamofireManager.request(request)
                .validate(statusCode: 200..<300)
                .responseString(completionHandler: { response in
                    if self.config!.apiLogging {
                        //Log response and Request if Debug true
                        if self.config!.logType.rawValue == 0 || self.config!.logType.rawValue == 1 {
                            ResponseHandler.log(response)
                        }
                    }
                })
                .responseData(completionHandler: { response in
                    if let data = response.data {
                        let decoder = JSONDecoder()
                        decoder.dateDecodingStrategy = .formatted(.iso8601Full)
                        if let posts = try? decoder.decode(GhostPosts.self, from: data) {
                            observer.onNext(posts)
                            observer.onCompleted()
                        } else if let error = try? decoder.decode(GhostErrors.self, from: data) {
                            observer.onError(GhostError(localizedTitle: error.errors[0].errorType, localizedDescription: error.errors[0].message, code: 0))
                        }
                    } else if let _ = response.result.error {
                        observer.onError(ResponseHandler.error(response))
                    } else {
                        observer.onError(ResponseHandler.error(response))
                    }
                })
            return Disposables.create {
                request.cancel()
            }
        })
    }
    
    internal func rxDelete(by id: String) -> Observable<Any?> {        
        return Observable.create({ (observer) -> Disposable in
            guard let _ = self.config else { return Disposables.create {} }
            let request = self.alamofireManager.request(GhostAdminURLBuilder.postsURL(self.config!, id: id, slug: nil),
                                                        method: .delete,
                                                        parameters: nil,
                                                        encoding: URLEncoding.default,
                                                        headers: nil)
                .validate(statusCode: 200..<300)
                .responseString(completionHandler: { response in
                    if self.config!.apiLogging {
                        //Log response and Request if Debug true
                        if self.config!.logType.rawValue == 0 || self.config!.logType.rawValue == 1 {
                            ResponseHandler.log(response)
                        }
                    }
                })
                .responseData(completionHandler: { response in
                    if response.response?.statusCode == 204 {
                        observer.onNext("DELTETD")
                        observer.onCompleted()
                    } else if let data = response.data {
                        let decoder = JSONDecoder()
                        if let error = try? decoder.decode(GhostErrors.self, from: data) {
                            observer.onError(GhostError(localizedTitle: error.errors[0].errorType, localizedDescription: error.errors[0].message, code: 0))
                        } else {
                            observer.onError(ResponseHandler.error(response))
                        }
                    } else {
                        observer.onError(ResponseHandler.error(response))
                    }
                })
            return Disposables.create {
                request.cancel()
            }
        })
    }
    
    internal func rxUploadImage(_ image: UIImage, purpose: String, name: String) -> Observable<Any?> {
        let parameters = ["purpose": purpose, "ref": name]
        return Observable.create({ (observer) -> Disposable in
            guard let _ = self.config else { return Disposables.create {} }
            let url = GhostAdminURLBuilder.imagesURL(self.config!)
            self.alamofireManager.upload(
                multipartFormData: { multipartFormData in
                    for (key, value) in parameters {
                        multipartFormData.append(value.data(using: .utf8)!, withName: key)
                    }
                    if let imageData = image.pngData() {
                        multipartFormData.append(imageData, withName: "file", fileName: "image.png", mimeType: "image/png")
                    }
            },
                to: url,
                method: .post,
                encodingCompletion: { encodingResult in
                    switch encodingResult {
                    case .success(let upload, _, _):
                        upload.uploadProgress(closure: { progress in
                            observer.onNext(progress)
                        })
                        upload.responseString { response in
                            if self.config!.apiLogging {
                                //Log response and Request if Debug true
                                if self.config!.logType.rawValue == 0 || self.config!.logType.rawValue == 7 {
                                    ResponseHandler.log(response)
                                }
                            }
                        }
                        upload.responseData { response in
                            if let data = response.data {
                                let decoder = JSONDecoder()
                                if let images = try? decoder.decode(GhostImages.self, from: data) {
                                    observer.onNext(images)
                                    observer.onCompleted()
                                } else if let error = try? decoder.decode(GhostErrors.self, from: data) {
                                    observer.onError(GhostError(localizedTitle: error.errors[0].errorType, localizedDescription: error.errors[0].message, code: 0))
                                }
                            } else if let _ = response.result.error {
                                observer.onError(ResponseHandler.error(response))
                            } else {
                                observer.onError(ResponseHandler.error(response))
                            }
                        }
                    case .failure(let encodingError):
                        observer.onError(encodingError)
                    }
            })
            return Disposables.create {}
        })
    }
}
