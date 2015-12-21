//
//  NettskjemaStep.swift
//  MedForsk
//
//  Created by Paul Philip Mitchell on 05/08/15.
//  Copyright (c) 2015 Universitetet i Oslo. All rights reserved.
//

import Foundation
import ResearchKit

class NettskjemaStep : ORKActiveStep {
    
    static func stepViewControllerClass() -> NettskjemaStepViewController.Type {
        return NettskjemaStepViewController.self
    }
}
