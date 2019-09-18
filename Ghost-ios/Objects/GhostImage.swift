//
//  GhostImage.swift
//  Ghost-ios
//
//  Created by Criss Myers on 18/09/2019.
//  Copyright © 2019 Mission Labs. All rights reserved.
//

import Foundation

internal struct GhostImages: Codable {
    public let images:[GhostImage]
}

public struct GhostImage: Codable {
    public let url: String
    public let ref: String
}
