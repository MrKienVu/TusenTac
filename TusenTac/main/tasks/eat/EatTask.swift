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
    
    
    
    let completionStep = ORKCompletionStep(identifier: Identifier.EatCompletion.rawValue)
    completionStep.title = "Takk!"
    completionStep.text = "Dine svar har blitt registrert."
    steps.append(completionStep)
    
    return ORKOrderedTask(identifier: Identifier.EatTask.rawValue, steps: steps)
    
}