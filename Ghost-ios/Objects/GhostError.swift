//
//  GhostError.swift
//  Ghost-ios
//
//  Created by Criss Myers on 05/09/2019.
//  Copyright © 2019 Mission Labs. All rights reserved.
//

import Foundation

public struct GhostError: Error {
    public var localizedTitle: String
    public var localizedDescription: String
    public var code: Int
    
    public init(localizedTitle: String?, localizedDescription: String, code: Int) {
        self.localizedTitle = localizedTitle ?? "Error"
        self.localizedDescription = localizedDescription
        self.code = code
    }
}

internal struct GhostErrors: Codable {
    let errors:[GhostErrorMessage]
}

internal struct GhostErrorMessage: Codable {
    let message, errorType: String
}
