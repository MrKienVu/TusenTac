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

private class FormSettings {
    
    private let csrf: String
    private let formId: String
    private let studyId: String
    private let appId: String
    private let date: String
    private let time: String
    private let dateTime: String
    private let dosage: String
    private let weight: String
    private let newSideEffects: String
    private let goneSideEffects: String
    private let meal: String
    
    private let newSideEffectOptions: [String: String]
    private let goneSideEffectOptions: [String: String]
    private let mealOption: String
    
    init(csrf: String, formId: String, studyId: String, appId: String, date: String, time: String,
         dateTime: String, dosage: String, weight: String, newSideEffects: String, goneSideEffects: String,
         meal: String, newShivering: String, newDiarrhea: String, newNausea: String, newHeadache: String,
         newOther: String, goneShivering: String, goneDiarrhea: String, goneNausea: String, goneHeadache: String,
         goneOther: String, mealOption: String) {
        
        self.csrf = "NETTSKJEMA_CSRF_PREVENTION"
        self.formId = formId
        self.studyId = textAnswer(studyId)
        self.appId = textAnswer(appId)
        self.date = textAnswer(date)
        self.time = textAnswer(time)
        self.dateTime = textAnswer(dateTime)
        self.dosage = textAnswer(dosage)
        self.weight = textAnswer(weight)
        self.newSideEffects = answerOptions(newSideEffects)
        self.goneSideEffects = answerOptions(goneSideEffects)
        self.meal = answerOptions(meal)
        self.mealOption = mealOption
        
        self.newSideEffectOptions = [
            SideEffect.shivering: newShivering,
            SideEffect.diarrhea: newDiarrhea,
            SideEffect.nausea: newNausea,
            SideEffect.headache: newHeadache,
            SideEffect.other: newOther
        ]
        
        self.goneSideEffectOptions = [
            SideEffect.shivering: goneShivering,
            SideEffect.diarrhea: goneDiarrhea,
            SideEffect.nausea: goneNausea,
            SideEffect.headache: goneHeadache,
            SideEffect.other: goneOther
        ]
    }
}

private func textAnswer(id: String) -> String {
    return "answersAsMap[\(id)].textAnswer"
}

private func answerOptions(id: String) -> String {
    return "answersAsMap[\(id)].answerOptions"
}

private extension MultipartFormData {
    func addString(value: String, field: String) {
        self.appendBodyPart(data: value.dataUsingEncoding(NSUTF8StringEncoding)!, name: field)
    }
    func addFormattedDateTime(time: NSDate, format: String, field: String) {
        let formatter = NSDateFormatter()
        formatter.dateFormat = format
        self.addString(formatter.stringFromDate(time), field: field)
    }
}

class Nettskjema {
    private static let pingUrl = "https://nettskjema.uio.no/ping.html"
    private static let deliverBaseUrl = "https://nettskjema.uio.no/answer/deliver.json?formId="
    private static var csrfToken: String?
    
    private static let testForm = FormSettings.init(
        csrf: "NETTSKJEMA_CSRF_PREVENTION", formId: "73912", studyId: "551994",
        appId: "551995", date: "551996", time: "551997", dateTime: "551998",
        dosage: "552069", weight: "552070", newSideEffects: "552071",
        goneSideEffects: "552072", meal: "552073", newShivering: "1218043",
        newDiarrhea: "1218044", newNausea: "1218045", newHeadache: "1218046",
        newOther: "1218047", goneShivering: "1218048", goneDiarrhea: "1218049",
        goneNausea: "1218050", goneHeadache: "1218051", goneOther: "1218052",
        mealOption: "1218053")
    
    private static let prodForm = FormSettings.init(
        csrf: "NETTSKJEMA_CSRF_PREVENTION", formId: "74170", studyId: "556582",
        appId: "556583", date: "556584", time: "556585", dateTime: "556586",
        dosage: "556587", weight: "556588", newSideEffects: "556589",
        goneSideEffects: "556590", meal: "556591", newShivering: "1226727",
        newDiarrhea: "1226728", newNausea: "1226729", newHeadache: "1226730",
        newOther: "1226731", goneShivering: "1226732", goneDiarrhea: "1226733",
        goneNausea: "1226734", goneHeadache: "1226735", goneOther: "1226736",
        mealOption: "1226737")
    
    private static let form = UserDefaults.boolForKey(
        UserDefaultKey.testModeEnabled) ? testForm : prodForm
    
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
            deliverBaseUrl + form.formId,
            multipartFormData: {
                $0.addString(csrf, field: form.csrf)
                $0.addString(Locksmith.loadDataForUserAccount(Encrypted.account)![Encrypted.studyID]! as! String, field: form.studyId)
                $0.addString(UserDefaults.objectForKey(UserDefaultKey.UUID)! as! String, field: form.appId)
                $0.addFormattedDateTime(time, format: "yyyy-MM-dd", field: form.date)
                $0.addFormattedDateTime(time, format: "HH:mm:ss", field: form.time)
                $0.addFormattedDateTime(time, format: "yyyy-MM-dd HH:mm:ss", field: form.dateTime)
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
    
    private class func submit(singleValue value: String, time: NSDate, field: String) {
        submit(using: { data in data.addString(value, field: field) },
               time: time)
    }
    
    private class func submit(multipleValues values: [String], time: NSDate, field: String) {
        submit(using: { data in values.forEach { data.addString($0, field: field) }},
               time: time)
    }
    
    class func submit(weight number: NSNumber, weightTime: NSDate) {
        submit(singleValue: String(number), time: weightTime, field: form.weight)
    }
    class func submit(dosage number: NSNumber, medicationTime: NSDate) {
        submit(singleValue: String(number), time: medicationTime, field: form.dosage)
    }
    class func submit(newSideEffects sideEffects: [String], answerTime: NSDate) {
        submit(multipleValues: sideEffects.map { form.newSideEffectOptions[$0]! },
               time: answerTime, field: form.newSideEffects)
    }
    class func submit(goneSideEffects sideEffects: [String], answerTime: NSDate) {
        submit(multipleValues: sideEffects.map { form.goneSideEffectOptions[$0]! },
               time: answerTime, field: form.goneSideEffects)
    }
    
    class func submit(mealTime mealTime: NSDate) {
        submit(singleValue: form.mealOption, time: mealTime, field: form.meal)
    }
    
}