//
//  ResponseHandler.swift

//
//  Created by Criss Myers on 20/02/2019.
//  Copyright © 2019 Mission Labs. All rights reserved.
//

import Foundation
import Alamofire

internal final class ResponseHandler {
    
    //Error String from Code
    internal class func errorString(from statusCode: Int) -> String {
        let httpErrorStrings = [400: "Bad Request",
                                401: "Unauthorized",
                                402: "Payment Required",
                                403: "Forbidden",
                                404: "Not Found",
                                405: "Method Not Allowed",
                                406: "Not Acceptable",
                                407: "Proxy Authentication Required",
                                408: "Request Timeout",
                                409: "Conflict",
                                410: "Gone",
                                411: "Length Required",
                                412: "Precondition Failed",
                                413: "Request Entity Too Large",
                                414: "Request-URI Too Long",
                                415: "Unsupported Media Type",
                                416: "Requested Range Not Satisfiable",
                                417: "Expectation Failed",
                                429: "Too Many Requests",
                                500: "Internal Server Error",
                                501: "Not Implemented",
                                502: "Bad Gateway",
                                503: "Service Unavailable",
                                504: "Gateway Timeout",
                                505: "HTTP Version Not Supported"]
        return httpErrorStrings[statusCode]!
    }
    
    //MARK: Logging
    internal class func error(_ errorResponse: DataResponse<Data>) -> GhostError {
        var responseError:GhostError?
        var errorDescription = "Platform error"
        if let _ = errorResponse.response {
            if errorResponse.response!.statusCode == 401 { //forbidden OAuth2 token
                responseError = GhostError(localizedTitle: nil, localizedDescription: "Expired Token", code: 401)
            }
            else if errorResponse.response!.statusCode == 429 { //too many requests
                responseError = GhostError(localizedTitle: "Too Many Requests", localizedDescription: "Please wait and try again in a few minutes", code: 429)
            }
            else if errorResponse.response!.statusCode == 503 { //backend fetch failed
                responseError = GhostError(localizedTitle: "Service Timeout", localizedDescription: "Network service timeout", code: 503)
            }
            else if errorResponse.response!.statusCode == 200 {
                responseError = GhostError(localizedTitle: nil, localizedDescription: "Success", code: 200)
            }
            else { //!200
                //we have to convert the reponse to json and dict for the error message
                var errorDict:Dictionary<String, Any>?
                do {
                    let json = try JSONSerialization.jsonObject(with: errorResponse.data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String: Any]
                    if let jsonDictionary = json {
                        errorDict = jsonDictionary
                    }
                    else {
                        errorDict = ["error": ["message": "Incorrect response format"]]
                        print("JSON Not a Dictionary")
                    }
                }
                catch let jsonError as NSError {
                    errorDict = ["error": ["message": "Unknown Error, try again"]]
                    print(jsonError.localizedDescription)
                }
                if let error = errorDict?["error"] as? Dictionary<String, Any> {
                    if let description = error["message"] as? String {
                        errorDescription =  description
                    }
                }
                print(errorDict ?? "")
                responseError = GhostError(localizedTitle: nil, localizedDescription: errorDescription, code: errorResponse.response!.statusCode)
            }
        }
        else {
            responseError = GhostError(localizedTitle: "No network connection", localizedDescription: "Check network", code: 0)
        }
        return responseError!
    }
    
    internal class func log(_ response: DataResponse<String>) {
        if response.response?.statusCode == 200 {}
        
        if response.request != nil {
            print("Response = \(response)")
            print("Request Endpoint = \((response.request?.url!)!)")
        }
    }
}
