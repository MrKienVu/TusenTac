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
    let pingUrl = "https://nettskjema.uio.no/ping.html"
    
    private var csrfToken: String?
    
    init() {
        
    }
    
    func ping() {
        Alamofire.request(.GET, pingUrl)
            .responseString { response in
                print(response.result.value)
                if let csrf = response.result.value {
                    self.csrfToken = csrf
                }
            }
        print("CSRF: \(csrfToken)")
    }
    
}




    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    /*let request: NSURLRequest
    let backgroundWebView: UIWebView
    
    enum SCHEME_TYPE: String {
        case SideEffects    = "https://nettskjema.uio.no/answer/bivirkninger-tusentac.html"
        case Answer         = "https://nettskjema.uio.no/answer/tusentac.html"
    }
    
    init(scheme: SCHEME_TYPE) {
        request = NSURLRequest(URL: NSURL(string: scheme.rawValue)!)
        backgroundWebView = UIWebView()
        backgroundWebView.loadRequest(request)
    }
    
    func submit() {
        backgroundWebView.stringByEvaluatingJavaScriptFromString("document.getElementById('submit-answer').click();")
        print("did run submit")
    }
    
    func reload() {
        backgroundWebView.stopLoading()
    }
    
    func setExtraField(key: String, csv: String) {
        print("Got result")
        backgroundWebView.stringByEvaluatingJavaScriptFromString("Nettskjema.setExtraField('\(key)', \(csv));")
    }*/