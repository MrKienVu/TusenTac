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

class NettskjemaHandler {
    
    let request: NSURLRequest
    let backgroundWebView: UIWebView
    
    enum SCHEME_TYPE: String {
        case SideEffects    = "https://nettskjema.uio.no/answer/bivirkninger-tusentac.html"
        //case Answer     = "https://jboss-utv.uio.no/nettskjema/answer/answer.html"
    }
    
    init(scheme: SCHEME_TYPE) {
        self.request = NSURLRequest(URL: NSURL(string: scheme.rawValue)!)
        self.backgroundWebView = UIWebView()
        self.backgroundWebView.loadRequest(request)
    }
    
    func submit() {
        backgroundWebView.stringByEvaluatingJavaScriptFromString("document.getElementById('submit-answer').click();")
        print("did run submit")
    }
    
    func reload() {
        backgroundWebView.stopLoading()
    }
    
    func setExtraField(key: String, result: ORKResult) {
        // IMPORTANT NOTE: This is really not suitable for production use.
        //      - The code for ORKESerializer closely tracks the ResearchKit data model, which may change between versions.
        //      - There is no guarantee for backward or forward compatibility
        //      - ORKESerializer is only included in Apple's internal test app for new features for the ResearchKit API.
        
        print("Got result")
        //let serializedResult = try? ORKESerializer.JSONDataForObject(result)
        //print(serializedResult)
        //backgroundWebView.stringByEvaluatingJavaScriptFromString("Nettskjema.setExtraField('\(key)', \(serializedResultJSON));")
        backgroundWebView.stringByEvaluatingJavaScriptFromString("Nettskjema.setExtraField('\(key)', Tester innsending fra app);")
    }
    
}