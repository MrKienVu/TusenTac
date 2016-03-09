//
//  NettskjemaStepViewController.swift
//  MedForsk
//
//  Created by Paul Philip Mitchell on 05/08/15.
//  Copyright (c) 2015 Universitetet i Oslo. All rights reserved.
//

import Foundation
import ResearchKit
import WebKit

class NettskjemaStepViewController : ORKActiveStepViewController {
    
    let nettskjemaView = NettskjemaView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nettskjemaView.translatesAutoresizingMaskIntoConstraints = false
        self.customView = nettskjemaView
        self.customView?.intrinsicContentSize()
        self.customView?.superview?.translatesAutoresizingMaskIntoConstraints = false
        
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-[nettskjemaView]-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["nettskjemaView": nettskjemaView]))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-[nettskjemaView]-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["nettskjemaView": nettskjemaView]))
    }
    
}