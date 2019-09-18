//
//  GhostTokenGenerator.swift
//
//  Created by Criss Myers on 20/02/2019.
//  Copyright © 2019 Mission Labs. All rights reserved.
//

import Foundation
import SwiftJWT

internal struct GhostTokenGenerator {
    private let id:String
    private let secret:String
    private let version:String
    
    internal init(_ apiKey: String, apiVersion: String) {
        let key = apiKey.components(separatedBy: ":")
        id = key[0]
        secret = key[1]
        version = apiVersion
    }
    
    internal func createToken() -> String? {
        let header = Header(kid: id)
        let now = Date()
        let five = now.addingTimeInterval(300)
        let claims = GhostClaims(exp: five, iat: now, aud: "/\(version)/admin/")
        var jwtToken = JWT(header: header, claims: claims)
        let data = Data(fromHexEncodedString: secret)
        let signer = JWTSigner.hs256(key: data!)
        let token = try? jwtToken.sign(using: signer)
        print(token ?? "")
        return token
    }
}

private struct GhostClaims: Claims {
    let exp: Date
    let iat: Date
    let aud: String
}

private extension Data {
    init?(fromHexEncodedString string: String) {
        func decodeNibble(u: UInt16) -> UInt8? {
            switch(u) {
            case 0x30 ... 0x39:
                return UInt8(u - 0x30)
            case 0x41 ... 0x46:
                return UInt8(u - 0x41 + 10)
            case 0x61 ... 0x66:
                return UInt8(u - 0x61 + 10)
            default:
                return nil
            }
        }
        
        self.init(capacity: string.utf16.count/2)
        var even = true
        var byte: UInt8 = 0
        for c in string.utf16 {
            guard let val = decodeNibble(u: c) else { return nil }
            if even {
                byte = val << 4
            } else {
                byte += val
                self.append(byte)
            }
            even = !even
        }
        guard even else { return nil }
    }
}
