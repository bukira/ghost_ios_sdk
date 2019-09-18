//
//  TestClass.swift
//
//  Created by Criss Myers on 20/02/2019.
//  Copyright © 2019 Mission Labs. All rights reserved.
//

internal func convertToData(_ fileName: String) -> Data? {
    let url = Bundle.main.url(forResource: fileName, withExtension: "json")
    do {
        let jsonData = try Data(contentsOf:url!)
        return jsonData
    } catch let error as NSError {
        print("json failed: \(error.localizedDescription)")
        return nil
    }
}
