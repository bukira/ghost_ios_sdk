//
//  ECToken.swift
//  ECom
//
//  Created by Criss Myers on 20/02/2019.
//  Copyright © 2019 Mission Labs. All rights reserved.
//

import Foundation
import SwiftJWT

internal struct GhostTokenGenerator {

    internal var token:String?
    
    internal init(_ key: String, version: String) {
        let keyData = key.components(separatedBy: ":")
        let header = Header(kid: keyData[0])
        let claims = GhostClaims(iss: "Kitura", exp: Date(timeIntervalSinceNow: 3600), aud: "/\(version)/admin/")
        var jwtToken = JWT(header: header, claims: claims)
        let signer = JWTSigner.hs256(key: Data(keyData[1].utf8))
        token = try? jwtToken.sign(using: signer)
    }
}

private struct GhostClaims: Claims {
    let iss: String
    let exp: Date
    let aud:String
}
