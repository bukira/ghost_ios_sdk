//
//  Subject.swift
//
//  Created by Criss Myers on 25/04/2016.
//  Copyright © 2017 missionlabs. All rights reserved.
//

import Foundation

/**
 Rx Subject returned with success, error or object
 */
public struct Subject {

    public var object:Any?
    public var success = true
    public var error:GhostError?
    public var key:String?
    
    //MARK: Init
    public init(state: Bool) {
        success = state
    }
    
    public init(keyValue: String) {
        key = keyValue
        success = true
    }
    
    public init(anObject: Any, keyValue: String? = nil) {
        success = true
        object = anObject
        key = keyValue
    }
    
    public init(anError: GhostError) {
        success = false
        error = anError
    }
}
