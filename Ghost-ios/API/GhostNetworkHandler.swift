//
//  GhostNetworkHandler.swift
//
//  Created by Criss Myers on 20/02/2019.
//  Copyright © 2019 Mission Labs. All rights reserved.
//

import Foundation
import Alamofire

public final class GhostNetworkHandler: RequestRetrier, RequestAdapter {
    
    private typealias RefreshCompletion = (_ succeeded: Bool, _ accessToken: String?) -> Void
    
    private let tokenGenerator:GhostTokenGenerator
    private var token:String?
    
    init(_ generator: GhostTokenGenerator) {
        tokenGenerator = generator
        token = tokenGenerator.createToken()
    }
    
    //MARK: Alamofire
    private var isRefreshing = false
    private var requestsToRetry: [RequestRetryCompletion] = []
    
    //Intercept 401 and do a Token authorization.
    public func should(_ manager: SessionManager, retry request: Request, with error: Error, completion: @escaping RequestRetryCompletion) {
        if let response = request.task?.response as? HTTPURLResponse, 401 == response.statusCode {
            requestsToRetry.append(completion)
            print(response)
            if !isRefreshing {
                refreshTokens { [weak self] succeeded, accessToken in
                    guard let strongSelf = self else { return }
                    if succeeded == false {
                        completion(false, 0.0)
                    }
                    
                    if let accessToken = accessToken {
                        strongSelf.token = accessToken
                    }
                    
                    strongSelf.requestsToRetry.forEach { $0(succeeded, 0.0) }
                    strongSelf.requestsToRetry.removeAll()
                }
            }
        }
        else {
            completion(false, 0.0) // not a 401, not our problem
        }
    }
    
    //Sign the request with the access token.
    public func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
        var urlRequest = urlRequest
        if token != nil {
            urlRequest.setValue("Ghost \(token!)", forHTTPHeaderField: "Authorization")
            //print("request =",urlRequest.urlRequest ?? "", "  header = ", urlRequest.allHTTPHeaderFields as Any)
        }
        return urlRequest
    }
    
    //MARK: Private - Refresh Tokens
    private func refreshTokens(completion: @escaping RefreshCompletion) {
        if let accessToken = tokenGenerator.createToken() {
            completion(true, accessToken)
            isRefreshing = false
        } else {
            completion(false, nil)
            isRefreshing = false
        }
    }
}
