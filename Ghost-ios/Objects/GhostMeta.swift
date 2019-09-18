//
//  GhostMeta.swift
//  Ghost-ios
//
//  Created by Criss Myers on 05/09/2019.
//  Copyright © 2019 Mission Labs. All rights reserved.
//

import Foundation

internal struct GhostMeta: Codable {
    let pagination: Pagination?
}

internal struct Pagination: Codable {
    let page, limit, pages, total: Int?
    let next: Int?
    let prev: Int?
}
