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
    let localizedQuestionStep1AnswerFormatUnit = "kg"
    let questionStep1AnswerFormat = ORKAnswerFormat.decimalAnswerFormatWithUnit(localizedQuestionStep1AnswerFormatUnit)
    
    let questionStep1 = ORKQuestionStep(identifier: String(Identifier.WeightStep), title: "Registrer vekt", answer: questionStep1AnswerFormat)
    
    var lastWeightString = ""
    if let weight = UserDefaults.objectForKey(UserDefaultKey.Weight) {
        if let weightTime = UserDefaults.objectForKey(UserDefaultKey.LastWeightTime) {
            lastWeightString += "Din forrige vekt var \(weight) kg og ble registrert \((weightTime as! NSDate).toStringShortStyle())."
        }
    }
    
    questionStep1.text = "\(lastWeightString) \n\nVennligst skriv inn din nåværende vekt nedenfor."
    questionStep1.optional = false
    
    
    if let lastWeight = UserDefaults.valueForKey(UserDefaultKey.Weight){
        questionStep1.placeholder = "\(lastWeight)"
       
    }
    else {
        questionStep1.placeholder = "Skriv inn vekt".localized
    }
    
    steps += [questionStep1]
    
    // SUMMARY STEP
    let summaryStep = ORKCompletionStep(identifier: Identifier.SummaryStep.rawValue)
    summaryStep.title = "Levert!".localized
    summaryStep.text = "Dine svar har blitt levert til Nettskjema.".localized
    steps += [summaryStep]
    
    return ORKOrderedTask(identifier: Identifier.WeightTask.rawValue, steps: steps)
    
}