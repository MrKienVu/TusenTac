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

class NettskjemaHandler {
    private let pingUrl = "https://nettskjema.uio.no/ping.html"
    private let formUrl = "https://nettskjema.uio.no/answer/tusentac.html"
    private let csrfField = "NETTSKJEMA_CSRF_PREVENTION"
    private let uploadField = "answersAsMap[492013].attachment.upload"
    
    private var csrfToken: String?
    
    init() {
        
    }
    
    private func getCsrfToken(completion: (String?, NSError?) -> Void) -> () {
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
                    NSLog("Request failed with error: \(error)")
                }
            }
    }
    
    func post(file: NSData, csrf: String) {
        Alamofire.upload(
            .POST,
            formUrl,
            multipartFormData: { multipartFormData in
                let tokenData = csrf.dataUsingEncoding(NSUTF8StringEncoding)
                multipartFormData.appendBodyPart(data: tokenData!, name: self.csrfField)
                multipartFormData.appendBodyPart(
                    data: file,
                    name: self.uploadField,
                    fileName: "test1231123",
                    mimeType: "text/plain"
                )
            },
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .Success(let upload, _, _):
                    upload.responseString { response in
                        NSLog("Upload success.")
                        debugPrint(response)
                    }
                case .Failure(let encodingError):
                    NSLog("Upload failed.")
                    print(encodingError)
                }
        })
    }
    
    func upload(file: NSData) {
        getCsrfToken { (data, error) in
            if let token = data {
                NSLog("Got to upload with token: \(token)")
                self.post(file, csrf: token)
            } else {
                NSLog("Got to upload with error: \(error!)")
            }
        }
    }
    
}