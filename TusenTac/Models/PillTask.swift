//
//  PillTask.swift
//  TusenTac
//
//  Created by ingeborg ødegård oftedal on 21/12/15.
//  Copyright © 2015 ingeborg ødegård oftedal. All rights reserved.
//


import Foundation
import ResearchKit

public var PillTask: ORKNavigableOrderedTask {
    
    var steps = [ORKStep]()
    
    let textChoiceOneText = NSLocalizedString("✓\tTok medisinen nå", comment: "")
    let textChoiceTwoText = NSLocalizedString("🕐\tTok medisinen tidligere", comment: "")
    let textChoiceThreeText = NSLocalizedString("☓\tVil ikke ta medisinen", comment: "")
    
    // The text to display can be separate from the value coded for each choice:
    let textChoices = [
        ORKTextChoice(text: textChoiceOneText, value: "now"),
        ORKTextChoice(text: textChoiceTwoText, value: "earlier"),
        ORKTextChoice(text: textChoiceThreeText, value: "none")
    ]
    
    let pillOptionAnswer = ORKAnswerFormat.choiceAnswerFormatWithStyle(.SingleChoice, textChoices: textChoices)
    
    let pillOptionStep = ORKQuestionStep(
        identifier: Identifier.PillOptionStep.rawValue,
        title: "Medisinregistrering",
        answer: pillOptionAnswer
    )
    pillOptionStep.text = "Når tok du medisinen?"
    pillOptionStep.optional = false
    
    steps+=[pillOptionStep]
    
    /*let eatingTimeAnswer = ORKAnswerFormat.timeIntervalAnswerFormat()
    
    let eatingStep = ORKQuestionStep(identifier: Identifier.EatingStep.rawValue, title: "Når spiste du sist?", answer: eatingTimeAnswer)
    
    eatingStep.text = ""
    
    steps+=[eatingStep]*/
    
    let tookPillEarlierAnswer = ORKAnswerFormat.timeOfDayAnswerFormat()
    let tookPillEarlierStep = ORKQuestionStep(identifier: Identifier.TookPillEarlierStep.rawValue, title: "Når tok du den?", answer: tookPillEarlierAnswer)
    tookPillEarlierStep.text = ""
    tookPillEarlierStep.optional = false
    
    steps += [tookPillEarlierStep]
    
    // SUMMARY STEP
    let pillCompletionStep = ORKCompletionStep(identifier: Identifier.PillCompletionStep.rawValue)
    pillCompletionStep.title = "Ferdig!".localized
    pillCompletionStep.text = "Dine svar har blitt levert til Nettskjema.".localized
    steps += [pillCompletionStep]
    
    let pillTask = ORKNavigableOrderedTask(identifier: Identifier.PillTask.rawValue, steps: steps)
    
    let resultSelector = ORKResultSelector.init(resultIdentifier: pillOptionStep.identifier)
    
    let pillTakenNow: NSPredicate = ORKResultPredicate.predicateForChoiceQuestionResultWithResultSelector(resultSelector, expectedAnswerValue: "now")
    let pillNotTaken: NSPredicate = ORKResultPredicate.predicateForChoiceQuestionResultWithResultSelector(resultSelector, expectedAnswerValue: "none")
    
    let predicateRule = ORKPredicateStepNavigationRule(resultPredicates: [pillTakenNow, pillNotTaken], destinationStepIdentifiers: [pillCompletionStep.identifier, pillCompletionStep.identifier], defaultStepIdentifier: nil, validateArrays: false)
    
    
    pillTask.setNavigationRule(predicateRule, forTriggerStepIdentifier: pillOptionStep.identifier)
    //pillTask.setNavigationRule(predicateRule2, forTriggerStepIdentifier: pillOptionStep.identifier)
    
    
    
    return pillTask

}
