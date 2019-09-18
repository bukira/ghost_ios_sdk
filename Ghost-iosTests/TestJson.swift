//
//  TestJson.swift
//
//  Created by Criss Myers on 20/02/2019.
//  Copyright © 2019 Mission Labs. All rights reserved.
//

import Foundation

func convertToData(_ fileName: String, bundle: Bundle) -> Data? {
    let jsonPath = bundle.path(forResource: fileName, ofType: "json")!
    do {
        let data = try Data(contentsOf: URL(fileURLWithPath: jsonPath), options: Data.ReadingOptions.mappedIfSafe)
        return data
    }
    catch _ as NSError {
        return nil
    }
}
