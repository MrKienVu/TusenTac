//
//  Identifier.swift
//  TusenTac
//
//  Created by ingeborg ødegård oftedal on 15/12/15.
//  Copyright © 2015 Paul Philip Mitchell. All rights reserved.
//

import Foundation
/**
 Every step and task in the ResearchKit framework has to have an identifier. Within a
 task, the step identifiers should be unique.
 
 Here we use an enum to ensure that the identifiers are kept unique. Since
 the enum has a raw underlying type of a `String`, the compiler can determine
 the uniqueness of the case values at compile time.
 
 */

enum Identifier: String {
    
    // Consent task specific identifiers.
    case ConsentTask =                                          "ConsentTask"
    case VisualConsentStep =                                    "VisualConsentStep"
    case ConsentReviewStep =                                    "ConsentReviewStep"
    case ConsentDocumentParticipantSignature =                  "ConsentDocumentParticipantSignature"
    case ConsentDocumentInvestigatorSignature =                 "ConsentDocumentInvestigatorSignature"
    case CreateUserStep =                                       "CreateUserStep"
    case PIDItem =                                              "PIDItem"
    case PasswordItem =                                         "PasswordItem"
    
    // Survey task specific identifiers.
    case SurveyTask =                                           "SurveyTask"
    case IntroStep =                                            "IntroStep"
    case StudyIDQuestionStep =                                  "StudyIDQuestionStep"
    case FoodSizeQuestionStep =                                 "FoodSizeQuestionStep"
    case AmountSleptQuestionStep =                              "AmountSleptQuestionStep"
    case SummaryStep =                                          "SummaryStep"
    
    // Task with examples of questions with sliding scales.
    case ScaleQuestionTask
    case DiscreteScaleQuestionStep
    case ContinuousScaleQuestionStep
    case DiscreteVerticalScaleQuestionStep
    case ContinuousVerticalScaleQuestionStep
    case TextScaleQuestionStep
    case TextVerticalScaleQuestionStep
    case SlidersExampleTask
    case MoodQuestionStep
    case TestStep1
    case TestStep2
    
    //form
    case FormTask
    case FormStep
    case FormItem01
    case FormItem02
    case FormItem03
    
    //weight
    case WeightStep
    case WeightTask
    
    //side effect
    case SideEffectStep
    case SideEffectTask
    
    //SleepSurveyTask identifiers
    case SleepSurveyTask =                                      "SleepSurveyTask"
    case SleepSurveyStep =                                      "SLeepSurveyStep"
    
}