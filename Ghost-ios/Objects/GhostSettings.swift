//
//  GhostSettings.swift
//  Ghost-ios
//
//  Created by Criss Myers on 05/09/2019.
//  Copyright © 2019 Mission Labs. All rights reserved.
//

import Foundation

internal struct GhostSet: Codable {
    let settings:GhostSettings
    let meta:GhostMeta?
}

public struct GhostSettings: Codable {
    public let title, settingsDescription: String
    public let logo, icon: String?
    public let coverImage: String?
    public let facebook, twitter, lang, timezone: String?
    public let navigation: [GhostNavigation]
    public let metaTitle, metaDescription, ogImage, ogTitle: String?
    public let ogDescription, twitterImage, twitterTitle, twitterDescription: String?
    public let url: String?
    public let codeinjectionHead, codeinjectionFoot: String?
    
    enum CodingKeys: String, CodingKey {
        case title
        case settingsDescription = "description"
        case logo, icon
        case coverImage = "cover_image"
        case facebook, twitter, lang, timezone, navigation
        case metaTitle = "meta_title"
        case metaDescription = "meta_description"
        case ogImage = "og_image"
        case ogTitle = "og_title"
        case ogDescription = "og_description"
        case twitterImage = "twitter_image"
        case twitterTitle = "twitter_title"
        case twitterDescription = "twitter_description"
        case url
        case codeinjectionHead = "codeinjection_head"
        case codeinjectionFoot = "codeinjection_foot"
    }
}

public struct GhostNavigation: Codable {
    public let label: String
    public let url: String
}
