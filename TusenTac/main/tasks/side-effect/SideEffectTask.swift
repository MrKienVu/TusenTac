//
//  SideEffectTask.swift
//  TusenTac
//
//  Created by ingeborg ødegård oftedal on 17/12/15.
//  Copyright © 2015 Paul Philip Mitchell. All rights reserved.
//

import Foundation
import ResearchKit

struct SideEffect {
    static let shivering = "skjelving"
    static let diarrhea = "diare"
    static let nausea = "kvalme"
    static let headache = "hodepine"
    static let other = "annet"
}

public var SideEffectTask: ORKOrderedTask {
    
    var steps = [ORKStep]()
    let textChoices = [ORKTextChoice(text: "Skjelving", value: SideEffect.shivering),
                       ORKTextChoice(text: "Diaré", value: SideEffect.diarrhea),
                       ORKTextChoice(text: "Kvalme", value: SideEffect.nausea),
                       ORKTextChoice(text: "Hodepine", value: SideEffect.headache),
                       ORKTextChoice(text: "Annet", value: SideEffect.other),
    ]
    
    let newSideEffectAnswer = ORKAnswerFormat.choiceAnswerFormatWithStyle(.MultipleChoice, textChoices: textChoices)
    
    let newSideEffectStep = ORKQuestionStep(identifier: Identifier.NewSideEffectStep.rawValue, title: "Registrering av bivirkninger".localized, answer: newSideEffectAnswer);
    
    let quesText = "Velg en eller flere nye/forverring av bivirkninger"
    newSideEffectStep.text = quesText
    
    steps+=[newSideEffectStep]
    
    let oldSideEffectAnswer = ORKAnswerFormat.choiceAnswerFormatWithStyle(.MultipleChoice, textChoices: textChoices)
    
    let oldSideEffectStep = ORKQuestionStep(identifier: Identifier.OldSideEffectStep.rawValue, title:"Registrering av bivirkninger", answer: oldSideEffectAnswer);
    
    oldSideEffectStep.text = "Velg en eller flere bivirkninger som er blitt borte"
    
    steps+=[oldSideEffectStep]
        
    
    let waitStepIndeterminate = ORKWaitStep(identifier: Identifier.WaitCompletionStep.rawValue)
    waitStepIndeterminate.title = "Ferdig"
    waitStepIndeterminate.text = "Laster opp..."
    waitStepIndeterminate.indicatorType = ORKProgressIndicatorType.Indeterminate
    steps += [waitStepIndeterminate]
    
    return ORKOrderedTask(identifier: Identifier.SideEffectTask.rawValue, steps: steps)
    
}
