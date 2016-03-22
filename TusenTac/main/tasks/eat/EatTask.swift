//
//  EatTask.swift
//  TusenTac
//
//  Created by Paul Philip Mitchell on 06/01/16.
//  Copyright © 2016 ingeborg ødegård oftedal. All rights reserved.
//

import Foundation
import ResearchKit

public var EatTask: ORKOrderedTask {
    
    var steps = [ORKStep]()
    
    let eatingTimeAnswer = ORKAnswerFormat.timeOfDayAnswerFormat()
    let eatingStep = ORKQuestionStep(identifier: Identifier.EatingStep.rawValue, title: "Når spiste du sist?", answer: eatingTimeAnswer)
    eatingStep.text = ""
    eatingStep.optional = false
    steps.append(eatingStep)
    
    let waitStepIndeterminate = ORKWaitStep(identifier: Identifier.WaitCompletionStep.rawValue)
    waitStepIndeterminate.title = "Ferdig"
    waitStepIndeterminate.text = "Laster opp..."
    waitStepIndeterminate.indicatorType = ORKProgressIndicatorType.Indeterminate
    steps.append(waitStepIndeterminate)
  
    return ORKOrderedTask(identifier: Identifier.EatTask.rawValue, steps: steps)
    
}