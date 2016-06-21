//
//  CSVProcesser.swift
//  TusenTac
//
//  Created by Paul Philip Mitchell on 27/01/16.
//  Copyright © 2016 Universitetet i Oslo. All rights reserved.
//

import Foundation
import ResearchKit
import Locksmith

private class CSV {
    // Private helper object imitating a CSV file
    private var headers = [String]()
    private var fields = [String]()
    
    private func addHeader(header: String) {
        self.headers.append(header)
    }
    
    private func addHeaders(headers: [String]) {
        self.headers += headers
    }
    
    private func addField(field: String) {
        self.fields.append(field)
    }
    
    private func addFields(fields: [String]) {
        self.fields += fields
    }
}

public class ResultHandler {
    
    private static let respondentID = UserDefaults.objectForKey(UserDefaultKey.UUID)! as! String
    private static let studyID = Locksmith.loadDataForUserAccount(Encrypted.account)![Encrypted.studyID]! as! String
    private static let personNr = Locksmith.loadDataForUserAccount(Encrypted.account)![Encrypted.personNumber]! as! String
    
    class func createCSVFromResult(result: ORKTaskResult) -> NSData? {
        let metaCSV = getMetadata(result)
        let resultCSV = getResultData(result)
        
        let headers = (metaCSV.headers + resultCSV.headers).joinWithSeparator(",")
        let fields = (metaCSV.fields + resultCSV.fields).joinWithSeparator(",")
        
        NSLog("Result processed \n--------------\n Headers: \(headers) \n Fields: \(fields)")
        return "\(headers)\n\(fields)".dataUsingEncoding(NSUTF8StringEncoding)
    }
    
    private class func getMetadata(taskResult: ORKTaskResult) -> CSV {
        let csv = CSV()
        csv.addHeaders(["Task", "RespondentID", "StudyID", "PersonNumber", "StartDate", "EndDate", "TotalTime"])
        csv.addFields([taskResult.identifier, respondentID, studyID, personNr, taskResult.startDate!.toStringDetailed(), taskResult.endDate!.toStringDetailed(), "\(NSInteger(taskResult.endDate!.timeIntervalSinceDate(taskResult.startDate!)))"])
        
        return csv
    }
    
    private class func getResultData(taskResult: ORKTaskResult) -> CSV {
        var counter = 1
        let csv = CSV()
        
        if let stepResults = taskResult.results as? [ORKStepResult] {
            for stepResult in stepResults {
                for result in stepResult.results! {
                    
                    if let choiceResult = result as? ORKChoiceQuestionResult {
                        if let _ = choiceResult.answer {
                            if taskResult.identifier == "PillTask" {
                                var dateNow = ""
                                if "\(choiceResult.choiceAnswers![0])" == "now" {
                                    csv.addHeader("TimePillTaken")
                                    counter += 1
                                    dateNow = taskResult.endDate!.toStringHourMinute()
                                    csv.addField("\(dateNow)")
                                }
                            } else {
                                csv.addHeader("Question\(counter)")
                                counter += 1
                                csv.addField("\(choiceResult.choiceAnswers!)")
                            }
                        } else {
                            // Step was skipped by user, appends "nil" to csv
                            csv.addField("\(choiceResult.answer)")
                        }
                    }
                    
                    if let timeOfDayResult = result as? ORKTimeOfDayQuestionResult {
                        taskResult.identifier == "EatTask" ? csv.addHeader("Question\(counter)") : csv.addHeader("TimePillTaken")
                        counter += 1
                        
                        
                        if let answer = timeOfDayResult.dateComponentsAnswer {
                            let date = NSCalendar.currentCalendar().dateFromComponents(answer)!
                            csv.addField((date.toStringHourMinute()))
                        } else {
                            csv.addField("\(timeOfDayResult.answer)")
                        }
                    }
                    
                    if let numericResult = result as? ORKNumericQuestionResult {
                        csv.addHeader("Question\(counter)")
                        counter += 1
                        
                        if let answer = numericResult.numericAnswer {
                            csv.addField("\(answer)")
                        } else {
                            csv.addField("\(numericResult.answer)")
                        }
                    }
                    
                    if let textResult = result as? ORKTextQuestionResult {
                        csv.addHeader("Question\(counter)")
                        counter += 1
                        
                        if let answer = textResult.answer {
                            csv.addField("\(answer)")
                        } else {
                            csv.addField("\(textResult.answer)")
                        }
                    }
                }
            }
        }
        
        return csv
        
    }
    
}