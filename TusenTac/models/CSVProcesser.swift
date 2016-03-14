//
//  CSVProcesser.swift
//  TusenTac
//
//  Created by Paul Philip Mitchell on 27/01/16.
//  Copyright © 2016 Universitetet i Oslo. All rights reserved.
//

import Foundation
import ResearchKit

public class CSVProcesser {
    
    let rid = UserDefaults.objectForKey(UserDefaultKey.UUID)!
    let sid = UserDefaults.objectForKey(UserDefaultKey.StudyID)!
    
    var csv: String = ""
    
    var description: String {
        return csv
    }
    
    
    init(taskResult: ORKTaskResult) {
        
        csv += "\(appendMetadata(taskResult))"
        csv += "\(appendResultData(taskResult))"
    }
    
    func appendMetadata(taskResult: ORKTaskResult) -> String {
        return "\(taskResult.identifier)," +
            "\(rid)," +
            "\(sid)," +
            "\(taskResult.startDate!)," +
            "\(taskResult.endDate!)," +
            "\(NSInteger(taskResult.endDate!.timeIntervalSinceDate(taskResult.startDate!))),"
    }
    
    func appendResultData(taskResult: ORKTaskResult) -> String {
        
        var resultString = ""
        
        if let stepResults = taskResult.results as? [ORKStepResult] {
            for stepResult in stepResults {
                for result in stepResult.results! {
                    
                    if let choiceResult = result as? ORKChoiceQuestionResult {
                        if let _ = choiceResult.answer {
                            resultString += "\(choiceResult.choiceAnswers![0]),"
                            
                            var dateNow = ""
                            if "\(choiceResult.choiceAnswers![0])" == "now" {
                                dateNow = taskResult.endDate!.toStringHourMinute()
                                resultString += "\(dateNow),"
                            }
                            
                        } else {
                            resultString += "\(choiceResult.answer),"
                        }
                    }
                    
                    if let timeOfDayResult = result as? ORKTimeOfDayQuestionResult {
                        if let answer = timeOfDayResult.dateComponentsAnswer {
                            resultString += "\(answer.hour):\(answer.minute),"
                        } else {
                            resultString += "\(timeOfDayResult.answer),"
                        }
                    }
                    
                    if let numericResult = result as? ORKNumericQuestionResult {
                        if let answer = numericResult.numericAnswer {
                            resultString += "\(answer),"
                        } else {
                            resultString += "\(numericResult.answer),"
                        }
                    }
                    
                    if let textResult = result as? ORKTextQuestionResult {
                        if let answer = textResult.answer {
                            resultString += "\(answer),"
                        } else {
                            resultString += "\(textResult.answer),"
                        }
                    }
                    
                }
            }
        }
        
        // Remove trailing comma ","
        if resultString.characters.count > 0 { resultString.removeAtIndex(resultString.endIndex.predecessor()) }
        return resultString
    }
    
}