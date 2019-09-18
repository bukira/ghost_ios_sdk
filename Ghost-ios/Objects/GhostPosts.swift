//
//  GhostPosts.swift
//  Ghost-ios
//
//  Created by Criss Myers on 04/09/2019.
//  Copyright © 2019 Mission Labs. All rights reserved.
//

import Foundation

public final class GhostPostConfig {
    public var sort:GhostOrder?
    public var includes:[GhostIncludes]?
    public var formats:[GhostFormats]?
    public var limit:Int?
    public var filters:[String]?
    public var fields:[String]?
    
    public init() {}
}

internal struct GhostPosts: Codable {
    var posts:[GhostPost]
    var meta:GhostMeta?
    
    init() {
        posts = [GhostPost]()
    }
}

internal struct GhostPages: Codable {
    let pages:[GhostPost]
    let meta:GhostMeta?
}

public struct GhostPost: Codable {
    public var id, uuid, title, slug: String?
    public var mobiledoc, html, commentID, plaintext: String?
    public var featureImage: String?
    public var featured, page: Bool?
    public var status: String?
    public var locale: String?
    public var visibility: String?
    public var metaTitle, metaDescription: String?
    public var authorID: String?
    public var createdAt, updatedAt, publishedAt: Date?
    public var customExcerpt: String?
    public var codeinjectionHead, codeinjectionFoot, ogImage, ogTitle: String?
    public var ogDescription, twitterImage, twitterTitle, twitterDescription: String?
    public var customTemplate, canonicalURL: String?
    public var primaryAuthor: GhostAuthor?
    public var primaryTag: GhostTag?
    public var url: String?
    public var excerpt: String?
    public var tags: [GhostTag]?
    public var authors: [GhostAuthor]?
    
    enum CodingKeys: String, CodingKey {
        case id, uuid, title, slug, mobiledoc, html
        case commentID = "comment_id"
        case plaintext
        case featureImage = "feature_image"
        case featured, page, status, locale, visibility
        case metaTitle = "meta_title"
        case metaDescription = "meta_description"
        case authorID = "author_id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case publishedAt = "published_at"
        case customExcerpt = "custom_excerpt"
        case codeinjectionHead = "codeinjection_head"
        case codeinjectionFoot = "codeinjection_foot"
        case ogImage = "og_image"
        case ogTitle = "og_title"
        case ogDescription = "og_description"
        case twitterImage = "twitter_image"
        case twitterTitle = "twitter_title"
        case twitterDescription = "twitter_description"
        case customTemplate = "custom_template"
        case canonicalURL = "canonical_url"
        case primaryAuthor = "primary_author"
        case primaryTag = "primary_tag"
        case url, excerpt
        case tags, authors
    }
    
    public init() {}
}
