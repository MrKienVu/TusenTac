//
//  WeightTask.swift
//  TusenTac
//
//  Created by ingeborg ødegård oftedal on 17/12/15.
//  Copyright © 2015 Paul Philip Mitchell. All rights reserved.
//

import Foundation
import ResearchKit

public var WeightTask: ORKOrderedTask {
    
    var steps = [ORKStep]()
    
    // INSTRUCTION STEP
    let instructionStep = ORKInstructionStep(identifier: Identifier.WeightStep.rawValue)
    instructionStep.title = "SURVEY_INTR_TITLE".localized
    instructionStep.text = "SURVEY_INTR_TEXT".localized
    steps += [instructionStep]
    
    return ORKOrderedTask(identifier: Identifier.WeightTask.rawValue, steps: steps)
    
}