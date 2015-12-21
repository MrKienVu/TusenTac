//
//  NettskjemaView.swift
//  MedForsk
//
//  Created by Paul Philip Mitchell on 05/08/15.
//  Copyright (c) 2015 Universitetet i Oslo. All rights reserved.
//

import Foundation
import ResearchKit
import WebKit

class NettskjemaView : UIView, WKNavigationDelegate, UIGestureRecognizerDelegate {
    
    var webView: WKWebView?
    let url = NSURL(string: "https://nettskjema.uio.no/answer/tusentac.html")
    
    init() {
        super.init(frame: CGRectMake(0, 0, 350, 400))
        
        let pathToScript = NSBundle.mainBundle().pathForResource("hideSections", ofType: "js")
        if let contentOfScript = try? String(contentsOfFile: pathToScript!, encoding: NSUTF8StringEncoding) {
            let script = WKUserScript(source: contentOfScript, injectionTime: .AtDocumentStart, forMainFrameOnly: true)
            let controller = WKUserContentController()
            let configuration = WKWebViewConfiguration()
            
            controller.addUserScript(script)
            configuration.userContentController = controller
            
            webView = WKWebView(frame: self.bounds, configuration: configuration)
            self.addSubview(webView!)
        }
        webView?.loadRequest(NSURLRequest(URL: url!))
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
