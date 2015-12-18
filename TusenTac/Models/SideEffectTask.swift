//
//  SideEffectTask.swift
//  TusenTac
//
//  Created by ingeborg ødegård oftedal on 17/12/15.
//  Copyright © 2015 Paul Philip Mitchell. All rights reserved.
//

import Foundation
import ResearchKit

public var SideEffectTask: ORKOrderedTask {
    
    var steps = [ORKStep]()
    
    // INSTRUCTION STEP
    let instructionStep = ORKInstructionStep(identifier: Identifier.SideEffectStep.rawValue)
    instructionStep.title = "SURVEY_INTR_TITLE".localized
    instructionStep.text = "SURVEY_INTR_TEXT".localized
    steps += [instructionStep]
    
    return ORKOrderedTask(identifier: Identifier.SideEffectTask.rawValue, steps: steps)
    
}
