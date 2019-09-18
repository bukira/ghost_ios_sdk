//
//  ECNetworkHandler.swift
//  ECom
//
//  Created by Criss Myers on 20/02/2019.
//  Copyright © 2019 Mission Labs. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

public final class GhostNetworkHandler: RequestRetrier, RequestAdapter {
    
    private typealias RefreshCompletion = (_ succeeded: Bool, _ accessToken: SPToken?) -> Void
    
//    private let defaults = UserDefaults.standard
    
//    public var accessToken:Token? {
//        didSet {
//            if accessToken != nil {
//                archiveToken()
//            }
//        }
//    }
//    var config:APIConfig?
//    let groupKey:String?
//
//    //MARK: Public
//    init(_ key: String?) {
//        groupKey = key
//        //   testToken()
//        retrieveToken()
//    }
    
    //MARK: Forget - token and email and password from keychain
//    public func forgetToken() {
//        KErrors.debug("TokenHandler : forget token")
//        accessToken = nil
//        #if IOS
//        if let email = defaults.string(forKey: "CLUTProviderUserEmail") {
//            Authentication.eraseKeychain(email)
//        }
//        #endif
//    }
    
    //MARK: Testing, set token to wrong value to trigger a test
//    public func testToken() {
//        if accessToken != nil {
//            accessToken!.ID = "99c9fdb-f5a3-47b4-a2ef-9400d0f3daa9"
//        }
//    }
    
    //MARK: Private
    //archive and unarchive the token
//    private func archiveToken() {
//        defaults.set(accessToken?.ID, forKey: "CLUTProviderTokenID")
//        if accessToken?.userID != nil {
//            defaults.set(accessToken?.userID, forKey: "userID")
//        }
//        if accessToken?.clientID != nil {
//            defaults.set(accessToken?.clientID, forKey: "clientID")
//        }
//
//        if let defaultsShared = UserDefaults.init(suiteName: groupKey) {
//            defaultsShared.set(accessToken?.ID, forKey: "CLUTProviderTokenID")
//            if accessToken?.userID != nil {
//                defaultsShared.set(accessToken?.userID, forKey: "userID")
//            }
//            if accessToken?.clientID != nil {
//                defaultsShared.set(accessToken?.clientID, forKey: "clientID")
//            }
//        }
//    }
    
//    private func retrieveToken() {
//        guard let tokenID = defaults.string(forKey: "CLUTProviderTokenID") else {
//            return
//        }
//        accessToken = Token(tokenID)
//        if let userID = defaults.string(forKey: "userID") {
//            accessToken?.userID = userID
//        }
//        if let clientID = defaults.string(forKey: "clientID") {
//            accessToken?.clientID = clientID
//        }
//
//        #if IOS
//        //send to apple watch
//        if accessToken?.userName != nil {
//            KWatchManager.shared.watchConfig = ["userID": accessToken!.userID ?? "none", "clientID": accessToken!.clientID ?? "none", "tokenID": accessToken!.ID ?? "none", "userName": accessToken!.userName ?? "none"]
//        } else {
//            KWatchManager.shared.watchConfig = ["userID": accessToken!.userID ?? "none", "clientID": accessToken!.clientID ?? "none", "tokenID": accessToken!.ID ?? "none", "userName": accessToken!.userName ?? "none"]
//        }
//        #endif
//    }
    
    //MARK: Alamofire
    private var isRefreshing = false
    private var requestsToRetry: [RequestRetryCompletion] = []
    
    //Intercept 401 and do a Token authorization.
    public func should(_ manager: SessionManager, retry request: Request, with error: Error, completion: @escaping RequestRetryCompletion) {
        if let response = request.task?.response as? HTTPURLResponse, 401 == response.statusCode {
            requestsToRetry.append(completion)
            
            // call a new login with saved email and passowrd, get the token and then retry the req
            if !isRefreshing {
                refreshTokens { [weak self] succeeded, accessToken in
                    guard let strongSelf = self else { return }
                    if succeeded == false {
                        completion(false, 0.0)
                    }
                    
                    //if let accessToken = accessToken {
                        //strongSelf.accessToken = accessToken
                        //strongSelf.archiveToken()
                    //}
                    
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
         urlRequest.setValue("", forHTTPHeaderField: "Authorization")
        print("request =",urlRequest.urlRequest ?? "", "  header = ", urlRequest.allHTTPHeaderFields as Any)
        return urlRequest
    }
    
    //MARK: Private - Refresh Tokens
    private func refreshTokens(completion: @escaping RefreshCompletion) {
        /*
        guard !isRefreshing else { return }
        guard (config != nil) else { return }
        
        KErrors.debug("TokenHandler : get new token")
        
        isRefreshing = true
        let credentials = Authentication.savedCredentials()
        if credentials.success == true {
            let payload = ["email": credentials.email!, "password": credentials.password!]
            _ = Alamofire.request(URLBuilder.tokenRefreshURL(config!),
                                  method: .post,
                                  parameters: payload,
                                  encoding: JSONEncoding.default,
                                  headers: nil)
                .validate()
                .responseString(completionHandler: { [weak self] response in
                    guard let strongSelf = self else { return }
                    
                    if strongSelf.config!.tokenLogging == true {
                        //Log response and Request
                        ResponseHandler.log(response)
                    }
                })
                .responseJSON(completionHandler: { [weak self] response in
                    guard let strongSelf = self else { return }
                    if let value = response.result.value {
                        let json = JSON(value)
                        if let accessToken = Token(json) {
                            completion(true, accessToken)
                        }
                        else {
                            completion(false, nil)
                        }
                        strongSelf.isRefreshing = false
                    }
                    else if let _ = response.result.error {
                        completion(false, nil)
                        strongSelf.isRefreshing = false
                    }
                })
        }
        else {
 */
            completion(false, nil)
            isRefreshing = false
        //}
    }
}
