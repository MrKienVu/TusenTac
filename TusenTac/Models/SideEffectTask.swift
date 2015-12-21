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
    let instructionStep = ORKInstructionStep(identifier: Identifier.IntroStep.rawValue)
    instructionStep.title = "SURVEY_INTR_TITLE".localized
    instructionStep.text = "SURVEY_INTR_TEXT".localized
    steps += [instructionStep]
    
    // NETTSKJEMA
    let nettskjemaStep = NettskjemaStep(identifier: Identifier.SideEffectStep.rawValue)
    nettskjemaStep.title = "NETTSKJEMASTEP_TITLE".localized
    //nettskjemaStep.text = "NETTSKJEMASTEP_TEXT".localized
    steps += [nettskjemaStep]
    
    // SUMMARY STEP
    let summaryStep = ORKCompletionStep(identifier: Identifier.SummaryStep.rawValue)
    summaryStep.title = "SUMMARYSTEP_TITLE".localized
    summaryStep.text = "SUMMARYSTEP_TEXT".localized
    steps += [summaryStep]
    
    return ORKOrderedTask(identifier: Identifier.SideEffectTask.rawValue, steps: steps)
    
}
