//
//  CollectionViewController.swift
//  ColletionViewTest2
//
//  Created by ingeborg ødegård oftedal on 18/02/16.
//  Copyright © 2016 ingeborg ødegård oftedal. All rights reserved.
//

import UIKit
import Foundation
import ResearchKit

private let medicineIndex = 0
private let mealIndex = 1
private let weightIndex = 2
private let sideEffectIndex = 3

class TaskListViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet var collection: UICollectionView!
    @IBOutlet weak var settingsIcon: UIBarButtonItem!
    
    var imageView: UIImageView!
    var img: UIImage!
    
    let icons = ["medication", "eating", "weight", "side-effects"]
    let greyIcons = ["medication-grey", "eating-grey", "weight-grey", "side-effects-grey"]
    let taskListRows = TaskListRow.allCases
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !UserDefaults.boolForKey(UserDefaultKey.overlayShown) {
            showOverlay()
            UserDefaults.setBool(true, forKey: UserDefaultKey.overlayShown)
        }
        
        collection.dataSource = self
        collection.delegate = self
        
        collection.registerNib(UINib(nibName: "TaskCollectionCell", bundle: nil), forCellWithReuseIdentifier: "Cell")
        
        collection.backgroundColor = UIColor(red: 237/255, green: 237/255, blue: 237/255, alpha: 1)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(TaskListViewController.presentMedicineRegistration), name: UserDefaultKey.medicineRegistration, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(TaskListViewController.presentWeightRegistration), name: UserDefaultKey.weightRegistration, object: nil)
        /* Add more notification observers here. */
        
        animateSettingsIconWithDuration(1.7)
    }
    
    override func viewWillAppear(animated: Bool) {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.viewWillEnterForeground), name: UIApplicationWillEnterForegroundNotification, object: UIApplication.sharedApplication())
        collection.reloadData()
    }
    
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UserDefaultKey.weightRegistration, object: nil)
    }
    
    func viewWillEnterForeground() {
        collection.reloadData()
    }
    
    func taskDisabled(taskIndex: Int) -> Bool {
        return taskIndex == medicineIndex ? !medicineTaskAvailable() : false
    }
    
    func medicineTaskAvailable() -> Bool {
        if let lastDosage = UserDefaults.valueForKey(UserDefaultKey.LastDosageTime) as? NSDate {
            let currentTime = NSDate()
            
            let midnight = NSCalendar.currentCalendar().dateBySettingHour(
                0, minute: 0, second: 0, ofDate: currentTime, options: NSCalendarOptions())!
            let threeAtNight = midnight.dateByAddingTimeInterval(Double(60 * 60 * 3))

            let time = currentTime.isGreaterThanDate(midnight) && currentTime.isLessThanDate(threeAtNight) ?
                currentTime.dateByAddingTimeInterval(Double(60 * 60 * -24)) : currentTime
            
            let interval = getMedicineInterval(time)
            let isMorning = currentTime.isBetween(interval.morningStart, and: interval.nightStart)
            if isMorning && lastDosage.isGreaterThanDate(interval.morningStart) ||
              !isMorning && lastDosage.isGreaterThanDate(interval.nightStart) {
                return false
            }
        }
        
        return true
    }
    
    func overlayTapped(sender: AnyObject){
        imageView.removeFromSuperview()
        collection.userInteractionEnabled = true
    }
    
    func showOverlay(){
        
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        
        switch screenHeight {
        case 568: img = UIImage(named: "overlay-5")
        case 667: img = UIImage(named: "overlay-6")
        case 736: img = UIImage(named: "overlay-6plus")
        default: return
        }
        
        NSLog("screenHeight \(screenHeight) screenWidth \(screenWidth)")
        
        imageView = UIImageView(image: img)
        
        let tapGest = UITapGestureRecognizer(target: self, action: #selector(TaskListViewController.overlayTapped(_:)))
        imageView.userInteractionEnabled = true
        imageView.addGestureRecognizer(tapGest)
        
        self.navigationController?.view.addSubview(imageView)
        
    }
    
    // MARK: UICollectionViewDataSource
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return taskListRows.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! TaskCollectionCell
        
        switch indexPath.row {
        case medicineIndex:
            if let lastDosageTime = UserDefaults.objectForKey(UserDefaultKey.LastDosageTime) {
                let dateString = (lastDosageTime as! NSDate).toStringShortStyle()
                cell.lastDosageLabel.text = "Sist registrert \(dateString)"
                cell.lastDosageLabel.hidden = false
            }
        case weightIndex:
            if let lastWeightTime = UserDefaults.objectForKey(UserDefaultKey.LastWeightTime) {
                let dateString = (lastWeightTime as! NSDate).toStringShortStyle()
                cell.lastDosageLabel.text = "Sist registrert \(dateString)"
                cell.lastDosageLabel.hidden = false
            }
        default:
            cell.lastDosageLabel.hidden = true;
        }
    
        if taskDisabled(indexPath.row) {
            cell.iconImage.image = UIImage(named: greyIcons[indexPath.row])
            cell.userInteractionEnabled = false
        } else {
            cell.iconImage.image = UIImage(named: icons[indexPath.row])
            cell.userInteractionEnabled = true
        }
        
        cell.taskLabel.text = "\(taskListRows[indexPath.row])"
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: (view.frame.width/2)-5, height: (view.frame.height/2.5)-14)
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        if !Reachability.isConnected() { showAlert("INTERNET_UNAVAILABLE_TITLE".localized, message: "INTERNET_UNAVAILABLE_TEXT".localized) }
        
        // Present the task view controller that the user asked for.
        let taskListRow = taskListRows[indexPath.row]
        
        // Create a task from the `TaskListRow` to present in the `ORKTaskViewController`.
        let task = taskListRow.representedTask
        
        /*
         Passing `nil` for the `taskRunUUID` lets the task view controller
         generate an identifier for this run of the task.
         */
        let taskViewController = ORKTaskViewController(task: task, taskRunUUID: nil)
        
        // Make sure we receive events from `taskViewController`.
        taskViewController.delegate = self
        
        
        /*
         We present the task directly, but it is also possible to use segues.
         The task property of the task view controller can be set any time before
         the task view controller is presented.
         */
        presentViewController(taskViewController, animated: true, completion: nil)
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        // This method ensures a UiO footer view on the collection view.
        
        switch kind {
        case UICollectionElementKindSectionFooter:
            let footerView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "UIOFooterView", forIndexPath: indexPath) as! FooterView
            return footerView
            
        default:
            fatalError("Unexpected element kind")
        }
    }
    
    func animateSettingsIconWithDuration(duration: Double) {
        let settingsView: UIView = settingsIcon.valueForKey("view") as! UIView
        UIView.animateWithDuration(duration, animations: {
            settingsView.transform = CGAffineTransformMakeRotation((90.0 * CGFloat(M_PI)) / 90.0)
        })
    }
    
    func presentMedicineRegistration() {
        presentChoice(medicineIndex)
    }
    
    func presentWeightRegistration() {
        presentChoice(weightIndex)
    }
    
    func presentChoice(cell: Int) {
        let taskListRow = taskListRows[cell]
        let task = taskListRow.representedTask
        let taskViewController = ORKTaskViewController(task: task, taskRunUUID: nil)
        taskViewController.delegate = self
        
        self.navigationController?.topViewController?.presentViewController(taskViewController, animated: false, completion: nil)
    }
    
    func createAlertController(title: String, message: String) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(defaultAction)
        
        return alertController
    }
    
    func showAlert(title: String, message: String) {
        presentViewController(createAlertController(title, message: message), animated: true, completion: nil)
    }
    
    func showAlert(title: String, message: String, taskViewController: ORKTaskViewController) {
        taskViewController.presentViewController(createAlertController(title, message: message), animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

func parseTaskResult(taskResult: ORKTaskResult, showAlert: () -> Void) {
    
    if taskResult.identifier == PillTask.identifier && (UIApplication.sharedApplication().applicationIconBadgeNumber > 0) {
        UIApplication.sharedApplication().applicationIconBadgeNumber = UIApplication.sharedApplication().applicationIconBadgeNumber - 1
    }
    if let stepResults = taskResult.results as? [ORKStepResult] {
        for stepResult in stepResults {
            for result in stepResult.results! {
                if result.identifier == Identifier.WeightStep.rawValue {
                    let weight = (result as! ORKNumericQuestionResult).numericAnswer!
                    let weightTime = taskResult.endDate!;
                    UserDefaults.setObject(weight, forKey: UserDefaultKey.Weight)
                    UserDefaults.setObject(weightTime, forKey: UserDefaultKey.LastWeightTime)
                    Nettskjema.submit(weight: weight, weightTime: weightTime, onFailure: showAlert)
                    Notification.sharedInstance.scheduleWeightNotification()
                }
                if result.identifier == Identifier.PillOptionStep.rawValue,
                    let choiceResult = result as? ORKChoiceQuestionResult where (choiceResult.choiceAnswers![medicineIndex] as! String) == "now" {
                    let medicationTime = taskResult.endDate!
                    let dosage = getDosageForTime(medicationTime)
                    UserDefaults.setObject(medicationTime, forKey: UserDefaultKey.LastDosageTime)
                    UserDefaults.setObject(dosage, forKey: UserDefaultKey.earlierDosage)
                    Nettskjema.submit(dosage: dosage, medicationTime: medicationTime, onFailure: showAlert)
                    
                }
                if result.identifier == Identifier.TookPillEarlierStep.rawValue,
                    let lastDosageTime = (result as? ORKDateQuestionResult)?.dateAnswer {
                    let dosage = getDosageForTime(lastDosageTime)
                    UserDefaults.setObject(lastDosageTime, forKey: UserDefaultKey.LastDosageTime)
                    UserDefaults.setObject(dosage, forKey: UserDefaultKey.earlierDosage)
                    Nettskjema.submit(dosage: dosage, medicationTime: lastDosageTime, onFailure: showAlert)
                }
                if result.identifier == Identifier.NewSideEffectStep.rawValue,
                    let newSideEffectsAnswer = result as? ORKChoiceQuestionResult,
                    newSideEffects = newSideEffectsAnswer.answer as? [String],
                    answerTime = newSideEffectsAnswer.endDate {
                    Nettskjema.submit(newSideEffects: newSideEffects, answerTime: answerTime, onFailure: showAlert)
                }
                if result.identifier == Identifier.OldSideEffectStep.rawValue,
                    let goneSideEffectsAnswer = result as? ORKChoiceQuestionResult,
                    goneSideEffects = goneSideEffectsAnswer.answer as? [String],
                    answerTime = goneSideEffectsAnswer.endDate {
                    Nettskjema.submit(goneSideEffects: goneSideEffects, answerTime: answerTime, onFailure: showAlert )
                }
                if result.identifier == Identifier.EatingStep.rawValue,
                    let mealAnswer = result as? ORKTimeOfDayQuestionResult,
                    submitDate = result.endDate,
                    selectedMealTime = mealAnswer.dateComponentsAnswer {
                    let mealTime = NSCalendar.currentCalendar().dateBySettingHour(selectedMealTime.hour, minute: selectedMealTime.minute, second: 0, ofDate: submitDate, options: NSCalendarOptions())!
                    Nettskjema.submit(mealTime: mealTime, onFailure: showAlert)
                }
                
            }
        }
    }
}

extension TaskListViewController: ORKTaskViewControllerDelegate {
    // All ORKTaskViewControllerDelegate methods are handled here.
    
    func taskViewController(taskViewController: ORKTaskViewController, stepViewControllerWillAppear stepViewController: ORKStepViewController) {
        stepViewController.continueButtonTitle = "Registrer"
        
        let identifier = stepViewController.step?.identifier
        if identifier == Identifier.WaitCompletionStep.rawValue {
            stepViewController.cancelButtonItem = nil
            delay(2.0, closure: { () -> () in
                if let stepViewController = stepViewController as? ORKWaitStepViewController {
                    if Reachability.isConnected() {
                        stepViewController.goForward()
                    } else {
                        stepViewController.goBackward()
                        self.showAlert("INTERNET_UNAVAILABLE_TITLE".localized, message: "INTERNET_UNAVAILABLE_TEXT".localized, taskViewController: taskViewController)
                    }
                }
            })
        }
    }
    
    
    
    // MARK: ORKTaskViewControllerDelegate
    func taskViewController(taskViewController: ORKTaskViewController, didFinishWithReason reason: ORKTaskViewControllerFinishReason, error: NSError?) {
        
        let taskResult = taskViewController.result
        if reason == .Completed {
            parseTaskResult(taskResult, showAlert: { self.showAlert("UPLOAD_REQUEST_FAILED_TITLE".localized, message: "UPLOAD_REQUEST_FAILED_TEXT".localized) })
        }
        taskViewController.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
    
}