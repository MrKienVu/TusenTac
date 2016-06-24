//
//  NettskjemaHandler.swift
//  Mathys
//
//  Created by Paul Philip Mitchell on 16/12/15.
//  Copyright © 2015 Universitetet i Oslo. All rights reserved.
//

import Foundation
import UIKit
import ResearchKit
import Alamofire
import Locksmith

private enum Field: String {
    case csrf = "NETTSKJEMA_CSRF_PREVENTION"
    case studyId = "answersAsMap[551994].textAnswer"
    case appId = "answersAsMap[551995].textAnswer"
    case date = "answersAsMap[551996].textAnswer"
    case time = "answersAsMap[551997].textAnswer"
    case dateTime = "answersAsMap[551998].textAnswer"
    case dosage = "answersAsMap[552069].textAnswer"
    case weight = "answersAsMap[552070].textAnswer"
    case newSideEffects = "answersAsMap[552071].answerOptions"
    case goneSideEffects = "answersAsMap[552072].answerOptions"
    case meal = "answersAsMap[552073].answerOptions"
}

let newSideEffectOptions = [
    SideEffect.shivering: "1218043",
    SideEffect.diarrhea: "1218044",
    SideEffect.nausea: "1218045",
    SideEffect.headache: "1218046",
    SideEffect.other: "1218047",
]

let goneSideEffectOptions = [
    SideEffect.shivering: "1218048",
    SideEffect.diarrhea: "1218049",
    SideEffect.nausea: "1218050",
    SideEffect.headache: "1218051",
    SideEffect.other: "1218052",
]

let mealOption = "1218053"

private extension MultipartFormData {
    func addString(value: String, field: Field) {
        self.appendBodyPart(data: value.dataUsingEncoding(NSUTF8StringEncoding)!, name: field.rawValue)
    }
    func addFormattedDateTime(time: NSDate, format: String, field: Field) {
        let formatter = NSDateFormatter()
        formatter.dateFormat = format
        self.addString(formatter.stringFromDate(time), field: field)
    }
}

class Nettskjema {
    private static let pingUrl = "https://nettskjema.uio.no/ping.html"
    private static let formUrl = "https://nettskjema.uio.no/answer/deliver.json?formId=73912"
    private static var csrfToken: String?
    
    private class func getCsrfToken(completion: (String?, NSError?) -> Void) -> () {
        Alamofire.request(.GET, pingUrl)
            .validate()
            .responseString { response in
                switch response.result {
                case .Success(let data):
                    self.csrfToken = data
                    completion(data, nil)
                    NSLog("Request succeeded with data: \(data)")
                case .Failure(let error):
                    completion(nil, error)
                }
        }
    }
    
    private class func post(valueAdder: (MultipartFormData) -> Void, time: NSDate, csrf: String) {
        Alamofire.upload(
            .POST,
            formUrl,
            multipartFormData: {
                $0.addString(csrf, field: Field.csrf)
                $0.addString(Locksmith.loadDataForUserAccount(Encrypted.account)![Encrypted.studyID]! as! String, field: Field.studyId)
                $0.addString(UserDefaults.objectForKey(UserDefaultKey.UUID)! as! String, field: Field.appId)
                $0.addFormattedDateTime(time, format: "yyyy-MM-dd", field: Field.date)
                $0.addFormattedDateTime(time, format: "HH:mm:ss", field: Field.time)
                $0.addFormattedDateTime(time, format: "yyyy-MM-dd HH:mm:ss", field: Field.dateTime)
                valueAdder($0)
            },
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .Success(let upload, _, _):
                    upload.responseString { response in
                        NSLog("Upload success. Status code: \(response.response)")
                    }
                case .Failure(let encodingError):
                    NSLog("Upload failed. Error: \(encodingError)")
                }
        })
    }
    
    private class func submit(using dataAdder: (MultipartFormData) -> Void, time: NSDate) {
        getCsrfToken { (data, error) in
            if let token = data {
                self.post(dataAdder, time: time, csrf: token)
            } else {
                NSLog("Failed to get CSRF token with error: \(error!)")
            }
        }
    }
    
    private class func submit(singleValue value: String, time: NSDate, field: Field) {
        submit(using: { data in data.addString(value, field: field) },
               time: time)
    }
    
    private class func submit(multipleValues values: [String], time: NSDate, field: Field) {
        submit(using: { data in values.forEach { data.addString($0, field: field) }},
               time: time)
    }
    
    class func submit(weight number: NSNumber, weightTime: NSDate) {
        submit(singleValue: String(number), time: weightTime, field: Field.weight)
    }
    class func submit(dosage number: NSNumber, medicationTime: NSDate) {
        submit(singleValue: String(number), time: medicationTime, field: Field.dosage)
    }
    class func submit(newSideEffects sideEffects: [String], answerTime: NSDate) {
        submit(multipleValues: sideEffects.map { newSideEffectOptions[$0]! },
               time: answerTime, field: Field.newSideEffects)
    }
    class func submit(goneSideEffects sideEffects: [String], answerTime: NSDate) {
        submit(multipleValues: sideEffects.map { goneSideEffectOptions[$0]! },
               time: answerTime, field: Field.goneSideEffects)
    }
    
    class func submit(mealTime mealTime: NSDate) {
        submit(singleValue: mealOption, time: mealTime, field: Field.meal)
    }
    
}