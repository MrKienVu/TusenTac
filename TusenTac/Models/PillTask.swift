//
//  PillTask.swift
//  TusenTac
//
//  Created by ingeborg ødegård oftedal on 21/12/15.
//  Copyright © 2015 ingeborg ødegård oftedal. All rights reserved.
//


import Foundation
import ResearchKit

public var PillTask: ORKOrderedTask {
    
    var steps = [ORKStep]()
    
    let textChoiceOneText = NSLocalizedString("Tok pillen nå", comment: "")
    let textChoiceTwoText = NSLocalizedString("Tok pillen tidligere", comment: "")
    let textChoiceThreeText = NSLocalizedString("Ta pillen senere", comment: "")
    let textChoiceThreeFour = NSLocalizedString("Vil ikke ta pillen", comment: "")
    
    // The text to display can be separate from the value coded for each choice:
    let textChoices = [
        ORKTextChoice(text: textChoiceOneText, value: "choice_1"),
        ORKTextChoice(text: textChoiceTwoText, value: "choice_2"),
        ORKTextChoice(text: textChoiceThreeText, value: "choice_3"),
        ORKTextChoice(text: textChoiceThreeFour, value: "choice_4")
    ]
    
    let pillOptionAnswer = ORKAnswerFormat.choiceAnswerFormatWithStyle(.SingleChoice, textChoices: textChoices)
    
    let pillOptionStep = ORKQuestionStep(identifier: Identifier.PillOptionStep.rawValue, title: "", answer: pillOptionAnswer)
    pillOptionStep.text = ""
    
    steps+=[pillOptionStep]
    
    let eatingTimeAnswer = ORKAnswerFormat.timeIntervalAnswerFormat()
    
    let eatingStep = ORKQuestionStep(identifier: Identifier.EatingStep.rawValue, title: "Når spiste du sist?", answer: eatingTimeAnswer)
    
    eatingStep.text = ""
    
    steps+=[eatingStep]
    
    let tookPillAnswer = ORKAnswerFormat.timeIntervalAnswerFormat()
    let tookPillStep = ORKQuestionStep(identifier: Identifier.TookPillEarlierStep.rawValue, title: "Når tok du den?", answer: tookPillAnswer)
    tookPillStep.text = ""
    
    steps += [tookPillStep]
    
    return ORKOrderedTask(identifier: Identifier.IntroStep.rawValue, steps: steps)

}
