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
    
    
    // This answer format will display a unit in-line with the numeric entry field.
    //husk å legg inn localized strenger
    let localizedQuestionStep1AnswerFormatUnit = NSLocalizedString("WEIGHT_UNIT".localized, comment: "")
    let questionStep1AnswerFormat = ORKAnswerFormat.decimalAnswerFormatWithUnit(localizedQuestionStep1AnswerFormatUnit)
    
    let questionStep1 = ORKQuestionStep(identifier: String(Identifier.WeightStep), title: "Registrer vekt", answer: questionStep1AnswerFormat)
    
    questionStep1.text = "Registrer vekt"
    questionStep1.placeholder = NSLocalizedString("Forrige vekt", comment: "")
    
    steps += [questionStep1]
    
    // SUMMARY STEP
    let summaryStep = ORKCompletionStep(identifier: Identifier.SummaryStep.rawValue)
    summaryStep.title = "SUMMARYSTEP_TITLE".localized
    summaryStep.text = "SUMMARYSTEP_TEXT".localized
    steps += [summaryStep]
    
    return ORKOrderedTask(identifier: Identifier.WeightTask.rawValue, steps: steps)
    
}