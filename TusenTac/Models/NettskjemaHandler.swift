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
    
    func upload() {
        getCsrfToken { (data, error) in
            if let token = data {
                NSLog("Got to upload with token: \(token)")
            } else {
                NSLog("Got to upload with error: \(error!)")
            }
        }
    }
    
    func post(file: String) {
        Alamofire.upload(
            .POST,
            formUrl,
            multipartFormData: { multipartFormData in
                let tokenData = self.csrfToken?.dataUsingEncoding(NSUTF8StringEncoding)
                multipartFormData.appendBodyPart(data: tokenData!, name: "CsrfFieldId")
                /*multipartFormData.appendBodyPart(
                    data: NSData(),
                    name: "file.name",
                    fileName: "file.name",
                    mimeType: "text/csv"
                )*/
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
    
}