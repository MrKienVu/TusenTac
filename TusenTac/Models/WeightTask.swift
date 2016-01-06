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
    
    let weightInstruction = ORKInstructionStep(identifier: Identifier.WeightInstruction.rawValue)
    weightInstruction.title = "Vektregistrering"
    weightInstruction.text = "På den neste siden blir du spurt om å skrive inn din nåværende vekt."
    weightInstruction.image = UIImage(named: "tusentac-scale")
    steps.append(weightInstruction)
    
    // This answer format will display a unit in-line with the numeric entry field.
    //husk å legg inn localized strenger
    let localizedQuestionStep1AnswerFormatUnit = "kg"
    let questionStep1AnswerFormat = ORKAnswerFormat.decimalAnswerFormatWithUnit(localizedQuestionStep1AnswerFormatUnit)
    
    let questionStep1 = ORKQuestionStep(identifier: String(Identifier.WeightStep), title: "Registrer vekt", answer: questionStep1AnswerFormat)
    
    questionStep1.text = "Vennligst skriv inn din nåværende vekt nedenfor."
    questionStep1.placeholder = "Forrige vekt".localized
    
    steps += [questionStep1]
    
    // SUMMARY STEP
    let summaryStep = ORKCompletionStep(identifier: Identifier.SummaryStep.rawValue)
    summaryStep.title = "Levert!".localized
    summaryStep.text = "Dine svar har blitt levert til Nettskjema.".localized
    steps += [summaryStep]
    
    return ORKOrderedTask(identifier: Identifier.WeightTask.rawValue, steps: steps)
    
}