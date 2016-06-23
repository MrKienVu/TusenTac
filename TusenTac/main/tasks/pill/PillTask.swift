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
    
    var lastDosageText = ""
    
    var isMorningDosage = true
    
    if let lastDosage = UserDefaults.valueForKey(UserDefaultKey.LastDosageTime) as? NSDate {
        
        let dateString = lastDosage.toStringShortStyle()
        if let dosage = UserDefaults.objectForKey(UserDefaultKey.morningDosage) {
            lastDosageText = "Din forrige dosering var \(dosage) mg og ble registrert \(dateString)."
        }
        
    }
    
    let textChoiceOneText = "✓\tTok medisinen nå".localized
    let textChoiceTwoText = "🕐\tTok medisinen tidligere".localized
    
    var steps = [ORKStep]()
    
  
    // The text to display can be separate from the value coded for each choice:
    let textChoices = [
        ORKTextChoice(text: textChoiceOneText, value: "now"),
        ORKTextChoice(text: textChoiceTwoText, value: "earlier")
    ]
    
    let pillOptionAnswer = ORKAnswerFormat.choiceAnswerFormatWithStyle(.SingleChoice, textChoices: textChoices)
    
    let pillOptionStep = ORKQuestionStep(
        identifier: Identifier.PillOptionStep.rawValue,
        title: "Medisinregistrering",
        answer: pillOptionAnswer
    )
    pillOptionStep.text = "\(lastDosageText) \n\nRegistrer ny dosering ved å trykke på et av valgene nedenfor"

    pillOptionStep.optional = false
    
    steps+=[pillOptionStep]
    
    
    // EARLIER STEP
    let tookPillEarlierAnswer = ORKAnswerFormat.timeOfDayAnswerFormat()
    let tookPillEarlierStep = ORKQuestionStep(identifier: Identifier.TookPillEarlierStep.rawValue, title: "Når tok du den?", answer: tookPillEarlierAnswer)
    tookPillEarlierStep.text = ""
    tookPillEarlierStep.optional = false
    
    steps += [tookPillEarlierStep]
    
    let waitStepIndeterminate = ORKWaitStep(identifier: Identifier.WaitCompletionStep.rawValue)
    waitStepIndeterminate.title = "Ferdig"
    waitStepIndeterminate.text = "Laster opp..."
    waitStepIndeterminate.indicatorType = ORKProgressIndicatorType.Indeterminate
    steps.append(waitStepIndeterminate)
    
    let pillTask = ORKNavigableOrderedTask(identifier: Identifier.PillTask.rawValue, steps: steps)
    
    // NAVIGABILITY RULES
    let resultSelector = ORKResultSelector.init(resultIdentifier: pillOptionStep.identifier)
    
    let pillTakenNow: NSPredicate = ORKResultPredicate.predicateForChoiceQuestionResultWithResultSelector(resultSelector, expectedAnswerValue: "now")
    
    let predicateRule = ORKPredicateStepNavigationRule(resultPredicates: [pillTakenNow], destinationStepIdentifiers: [waitStepIndeterminate.identifier], defaultStepIdentifier: nil, validateArrays: false)
    
    
    pillTask.setNavigationRule(predicateRule, forTriggerStepIdentifier: pillOptionStep.identifier)
    
    return pillTask

}
