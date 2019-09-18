//
//  GhostTags.swift
//  Ghost-ios
//
//  Created by Criss Myers on 05/09/2019.
//  Copyright © 2019 Mission Labs. All rights reserved.
//

import Foundation

public final class GhostTagConfig {
    public var sort:GhostOrder?
    public var includes:[GhostIncludes]?
    public var limit:Int?
    public var filters:[String]?
    
    public init() {}
}

internal struct GhostTags: Codable {
    let tags: [GhostTag]
    let meta:GhostMeta?
}

public struct GhostTag: Codable {
    public let id, name, slug: String
    public let tagDescription, featureImage: String?
    public let visibility: String?
    public let metaTitle, metaDescription: String?
    public let url: String?
    
    enum CodingKeys: String, CodingKey {
        case id, name, slug
        case tagDescription = "description"
        case featureImage = "feature_image"
        case visibility
        case metaTitle = "meta_title"
        case metaDescription = "meta_description"
        case url
    }
}
