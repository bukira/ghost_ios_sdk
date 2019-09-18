//
//  GhostAPIConfig.swift
//
//  Created by Criss Myers on 20/02/2019.
//  Copyright © 2019 Mission Labs. All rights reserved.
//

import Foundation

public enum LogType: Int {
    case all, posts, tags, authors, pages, settings, site
}

/**
 Log Type
 0 = All Logs
 1 = Posts
 2 = Tags
 3 = Authors
 4 = Page
 5 = Settings
 6 = Site
 7 = Images
 */

public final class GhostAPIConfig {
    
    internal let baseURL:String
    internal let apiVersion:String
    internal let apiKey:String
    internal let adminAPIKey:String?
    public var apiLogging:Bool
    public var logType:LogType
    
    public init(base url: String, api version: String, apiKey key: String, adminKey: String? = nil) {
        baseURL = url
        apiLogging = false
        logType = .all
        apiVersion = version
        apiKey = key
        adminAPIKey = adminKey
    }
}
