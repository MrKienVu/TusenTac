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
    instructionStep.title = "Registrering av bivirkninger".localized
    instructionStep.text = "På den neste siden kan du registrere eventuelle bivirkninger du har opplevd.".localized
    steps += [instructionStep]
    
    // NETTSKJEMA
    let nettskjemaStep = NettskjemaStep(identifier: Identifier.SideEffectStep.rawValue)
    nettskjemaStep.title = "Bivirkninger".localized
    //nettskjemaStep.text = "NETTSKJEMASTEP_TEXT".localized
    steps += [nettskjemaStep]
    
    // SUMMARY STEP
    let summaryStep = ORKCompletionStep(identifier: Identifier.SummaryStep.rawValue)
    summaryStep.title = "Levert!".localized
    summaryStep.text = "Dine bivirkninger har blitt registrert.".localized
    steps += [summaryStep]
    
    return ORKOrderedTask(identifier: Identifier.SideEffectTask.rawValue, steps: steps)
    
}
