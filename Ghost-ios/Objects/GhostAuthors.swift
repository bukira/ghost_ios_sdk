//
//  GhostAuthors.swift
//  Ghost-ios
//
//  Created by Criss Myers on 05/09/2019.
//  Copyright © 2019 Mission Labs. All rights reserved.
//

import Foundation

public final class GhostAuthorConfig {
    public var sort:GhostOrder?
    public var includes:[GhostIncludes]?
    public var limit:Int?
    public var filters:[String]?
    
    public init() {}
}

internal struct GhostAuthors: Codable {
    let authors: [GhostAuthor]
    let meta:GhostMeta?
}

public struct GhostAuthor: Codable {
    public let id, name, slug: String
    public let profileImage: String?
    public let coverImage: String?
    public let bio: String?
    public let website: String?
    public let location: String?
    public let facebook, twitter: String?
    public let metaTitle, metaDescription: String?
    public let url: String?
    
    enum CodingKeys: String, CodingKey {
        case id, name, slug
        case profileImage = "profile_image"
        case coverImage = "cover_image"
        case bio, website, location, facebook, twitter
        case metaTitle = "meta_title"
        case metaDescription = "meta_description"
        case url
    }
}
