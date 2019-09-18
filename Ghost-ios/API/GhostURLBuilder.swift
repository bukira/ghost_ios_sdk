//
//  GhostURLBuilder.swift
//
//  Created by Criss Myers on 20/02/2019.
//  Copyright © 2019 Mission Labs. All rights reserved.
//

import Foundation
import Alamofire

public enum GhostIncludes {
    case authors, tags, count
    internal var description: String {
        switch self {
        case .authors: return "authors"
        case .tags: return "tags"
        case .count: return "count.posts"
        }
    }
}

public enum GhostFormats: String {
    case html, plaintext
}

public enum GhostOrder {
    case titleDesc, titleAsc, nameDesc, nameAsc, publishedDesc, publishedAsc
    internal var description: String {
        switch self {
        case .titleDesc: return "title desc"
        case .titleAsc: return "title asc"
        case .nameDesc: return "name desc"
        case .nameAsc: return "name asc"
        case .publishedDesc: return "published_at desc"
        case .publishedAsc: return "published_at asc"
        }
    }
}

internal final class GhostURLBuilder {
    //Posts
    internal class func postsURL(_ config: GhostAPIConfig, id: String?, slug: String?) -> String {
        if id != nil {
           return config.baseURL + GhostPaths.basePath + config.apiVersion + GhostPaths.content + GhostPaths.posts + "/\(id ?? "")/"
        }
        if slug != nil {
           return config.baseURL + GhostPaths.basePath + config.apiVersion + GhostPaths.content + GhostPaths.posts + GhostPaths.slug + "/\(slug ?? "")/"
        }
        return config.baseURL + GhostPaths.basePath + config.apiVersion + GhostPaths.content + GhostPaths.posts
    }
    
    //Authors
    internal class func authorsURL(_ config: GhostAPIConfig, id: String?, slug: String?) -> String {
        if id != nil {
            return config.baseURL + GhostPaths.basePath + config.apiVersion + GhostPaths.content + GhostPaths.authors + "/\(id ?? "")/"
        }
        if slug != nil {
            return config.baseURL + GhostPaths.basePath + config.apiVersion + GhostPaths.content + GhostPaths.authors + GhostPaths.slug + "/\(slug ?? "")/"
        }
        return config.baseURL + GhostPaths.basePath + config.apiVersion + GhostPaths.content + GhostPaths.authors
    }
    
    //Tags
    internal class func tagsURL(_ config: GhostAPIConfig, id: String?, slug: String?) -> String {
        if id != nil {
            return config.baseURL + GhostPaths.basePath + config.apiVersion + GhostPaths.content + GhostPaths.tags + "/\(id ?? "")/"
        }
        if slug != nil {
            return config.baseURL + GhostPaths.basePath + config.apiVersion + GhostPaths.content + GhostPaths.tags + GhostPaths.slug + "/\(slug ?? "")/"
        }
        return config.baseURL + GhostPaths.basePath + config.apiVersion + GhostPaths.content + GhostPaths.tags
    }
    
    //Pages
    internal class func pagesURL(_ config: GhostAPIConfig, id: String?, slug: String?) -> String {
        if id != nil {
            return config.baseURL + GhostPaths.basePath + config.apiVersion + GhostPaths.content + GhostPaths.pages + "/\(id ?? "")/"
        }
        if slug != nil {
           return config.baseURL + GhostPaths.basePath + config.apiVersion + GhostPaths.content + GhostPaths.pages + GhostPaths.slug + "/\(slug ?? "")/"
        }
        return config.baseURL + GhostPaths.basePath + config.apiVersion + GhostPaths.content + GhostPaths.pages
    }
    
    //Settings
    internal class func settingsURL(_ config: GhostAPIConfig) -> String {
        return config.baseURL + GhostPaths.basePath + config.apiVersion + GhostPaths.content + GhostPaths.settings
    }
}

internal final class GhostAdminURLBuilder {
    //Posts
    internal class func postsURL(_ config: GhostAPIConfig, id: String?, slug: String?) -> String {
        if id != nil {
            return config.baseURL + GhostPaths.basePath + config.apiVersion + GhostPaths.admin + GhostPaths.posts + "/\(id ?? "")/"
        }
        if slug != nil {
            return config.baseURL + GhostPaths.basePath + config.apiVersion + GhostPaths.admin + GhostPaths.posts + GhostPaths.slug + "/\(slug ?? "")/"
        }
        return config.baseURL + GhostPaths.basePath + config.apiVersion + GhostPaths.admin + GhostPaths.posts
    }
    
    //Site
    internal class func siteURL(_ config: GhostAPIConfig) -> String {
        return config.baseURL + GhostPaths.basePath + config.apiVersion + GhostPaths.admin + GhostPaths.site
    }
    
    //Pages
    internal class func pagesURL(_ config: GhostAPIConfig, id: String?, slug: String?) -> String {
        if id != nil {
            return config.baseURL + GhostPaths.basePath + config.apiVersion + GhostPaths.admin + GhostPaths.pages + "/\(id ?? "")/"
        }
        if slug != nil {
            return config.baseURL + GhostPaths.basePath + config.apiVersion + GhostPaths.admin + GhostPaths.pages + GhostPaths.slug + "/\(slug ?? "")/"
        }
        return config.baseURL + GhostPaths.basePath + config.apiVersion + GhostPaths.admin + GhostPaths.pages
    }
    
    //Images
    internal class func imagesURL(_ config: GhostAPIConfig) -> String {
        return config.baseURL + GhostPaths.basePath + config.apiVersion + GhostPaths.admin + GhostPaths.images + GhostPaths.upload
    }
}

internal final class GhostParmetersBuilder {
    internal class func postParameters(_ config :GhostAPIConfig, postsConfig: GhostPostConfig, for page: Int?) -> Parameters {
        var params:Parameters = ["key": config.apiKey]
        if page != nil {
            params["page"] = page
        }
        if postsConfig.limit != nil {
            if postsConfig.limit == 0 {
                params["limit"] = "all"
            } else {
                params["limit"] = postsConfig.limit!
            }
        }
        if postsConfig.sort != nil {
            params["order"] = postsConfig.sort!.description
        }
        if postsConfig.formats != nil {
            params["formats"] = postsConfig.formats!.map({ $0.rawValue }).joined(separator: ",")
        }
        if postsConfig.includes != nil {
            params["include"] = postsConfig.includes!.map({ $0.description }).joined(separator: ",")
        }
        if postsConfig.fields != nil {
            params["fields"] = postsConfig.fields!.joined(separator: ",")
        }
        if postsConfig.filters != nil {
            params["filter"] = postsConfig.filters!.joined(separator: ",")
        }
        return params
    }
    
    internal class func tagParameters(_ config :GhostAPIConfig, tagsConfig: GhostTagConfig, for page: Int?) -> Parameters {
        var params:Parameters = ["key": config.apiKey]
        if page != nil {
            params["page"] = page
        }
        if tagsConfig.limit != nil {
            if tagsConfig.limit == 0 {
                params["limit"] = "all"
            } else {
                params["limit"] = tagsConfig.limit!
            }
        }
        if tagsConfig.sort != nil {
            params["order"] = tagsConfig.sort!.description
        }
        if tagsConfig.includes != nil {
            params["include"] = tagsConfig.includes!.map({ $0.description }).joined(separator: ",")
        }
        if tagsConfig.filters != nil {
            params["filter"] = tagsConfig.filters!.joined(separator: ",")
        }
        return params
    }
    
    internal class func authorParameters(_ config :GhostAPIConfig, authorsConfig: GhostAuthorConfig, for page: Int?) -> Parameters {
        var params:Parameters = ["key": config.apiKey]
        if page != nil {
            params["page"] = page
        }
        if authorsConfig.limit != nil {
            if authorsConfig.limit == 0 {
                params["limit"] = "all"
            } else {
                params["limit"] = authorsConfig.limit!
            }
        }
        if authorsConfig.sort != nil {
            params["order"] = authorsConfig.sort!.description
        }
        if authorsConfig.includes != nil {
            params["include"] = authorsConfig.includes!.map({ $0.description }).joined(separator: ",")
        }
        if authorsConfig.filters != nil {
            params["filter"] = authorsConfig.filters!.joined(separator: ",")
        }
        return params
    }
    
    internal class func settingsParameters(_ config :GhostAPIConfig) -> Parameters {
        return ["key": config.apiKey]
    }
}

internal struct GhostPaths {
    static let basePath = "/ghost/api/"
    static let content = "/content"
    static let admin = "/admin"
    
    static let posts = "/posts"
    static let authors = "/authors"
    static let tags = "/tags"
    static let pages = "/pages"
    static let settings = "/settings"
    static let site = "/site"
    static let images = "/images"
    static let upload = "/upload"
    static let slug = "/slug"
}
