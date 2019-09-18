//
//  GhostSite.swift
//  Ghost-ios
//
//  Created by Criss Myers on 09/09/2019.
//  Copyright © 2019 Mission Labs. All rights reserved.
//

import Foundation

internal struct GhostSites: Codable {
    public let site:GhostSite
}

public struct GhostSite: Codable {
    public let title: String
    public let url: String
    public let version: String
}
