//
//  NettskjemaHandler.swift
//  Mathys
//
//  Created by Paul Philip Mitchell on 16/12/15.
//  Copyright © 2015 Universitetet i Oslo. All rights reserved.
//

import Foundation
import UIKit
import ResearchKit
import Alamofire

class Nettskjema {
    private static let pingUrl = "https://nettskjema.uio.no/ping.html"
    private static let formUrl = "https://nettskjema.uio.no/answer/deliver.json?formId=69861"
    private static let csrfField = "NETTSKJEMA_CSRF_PREVENTION"
    private static let uploadField = "answersAsMap[492013].attachment.upload"
    
    private static var csrfToken: String?
    
    
    private class func getCsrfToken(completion: (String?, NSError?) -> Void) -> () {
        Alamofire.request(.GET, pingUrl)
            .validate()
            .responseString { response in
                switch response.result {
                case .Success(let data):
                    self.csrfToken = data
                    completion(data, nil)
                    NSLog("Request succeeded with data: \(data)")
                case .Failure(let error):
                    completion(nil, error)
                }
            }
    }
    
    private class func post(file: NSData, csrf: String) {
        Alamofire.upload(
            .POST,
            formUrl,
            multipartFormData: { multipartFormData in
                let tokenData = csrf.dataUsingEncoding(NSUTF8StringEncoding)
                multipartFormData.appendBodyPart(data: tokenData!, name: self.csrfField)
                multipartFormData.appendBodyPart(data: file, name: self.uploadField, fileName: "answer.csv", mimeType: "text/csv")
            },
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .Success(let upload, _, _):
                    upload.responseString { response in
                        NSLog("Upload success. Status code: \(response.response)")
                    }
                case .Failure(let encodingError):
                    NSLog("Upload failed. Error: \(encodingError)")
                }
        })
    }
    
    class func upload(file: NSData) {
        getCsrfToken { (data, error) in
            if let token = data {
                self.post(file, csrf: token)
            } else {
                NSLog("Failed to get CSRF token with error: \(error!)")
            }
        }
    }
}