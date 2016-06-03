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

class TaskListViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet var collection: UICollectionView!
    @IBOutlet weak var settingsIcon: UIBarButtonItem!
    
    var imageView: UIImageView!
    var img: UIImage!
    
    let icons = ["medication", "eating", "weight", "side-effects"]
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
        
        animateSettingsIconWithDuration(1.7)
    }
    
    override func viewWillAppear(animated: Bool) {
        collection.reloadData()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(TaskListViewController.presentMedicineRegistration), name: "presentMedicineRegistration", object: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    //This function will disable the task and add overlay image
    //boolean taskShouldBeDisable must be implemented
    
   /* func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        
        let navigationBarHeight = self.navigationController?.navigationBar.frame.height
        
        let statusBarHeight = UIApplication.sharedApplication().statusBarFrame.height
        
        let yPos = cell.bounds.minY + navigationBarHeight! + statusBarHeight
        
        let point = CGPoint(x:cell.bounds.minX , y: yPos)
        
        let size = CGSize(width: cell.bounds.width, height: cell.bounds.height)
        
        let rect = CGRect(origin: point, size: size)
        
        let disableImage = UIImageView(frame: rect)
        disableImage.backgroundColor = UIColor.grayColor()
        disableImage.alpha = 0.5
        
        if(indexPath.row == 0) {
            if(taskShouldBeDisabled) {
                
                //for disable the task
                cell.userInteractionEnabled = false
                
                //adding overlay
                self.navigationController?.view.addSubview(disableImage)
            }
            else if(!taskShouldBeDisabled) {
                cell.userInteractionEnabled = true
                self.navigationController?.view.willRemoveSubview(disableImage)
            }
        }
        
     
     cell.userInteractionEnabled = true
     self.navigationController?.view.willRemoveSubview(disableImage)
    }*/
    
    
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
        
        if indexPath.row == 0 {
            if let lastDosageTime = UserDefaults.objectForKey(UserDefaultKey.LastDosageTime) {
                let dateString = (lastDosageTime as! NSDate).toStringShortStyle()
                cell.lastDosageLabel.text = "Sist registrert \(dateString)"
                cell.lastDosageLabel.hidden = false
            }
            
        } else if indexPath.row == 2 {
            if let lastWeightTime = UserDefaults.objectForKey(UserDefaultKey.LastWeightTime) {
                let dateString = (lastWeightTime as! NSDate).toStringShortStyle()
                cell.lastDosageLabel.text = "Sist registrert \(dateString)"
                cell.lastDosageLabel.hidden = false
            }
        } else {
            cell.lastDosageLabel.hidden = true;
        }
        
        cell.iconImage.image = UIImage(named: icons[indexPath.row])
        cell.taskLabel.text = "\(taskListRows[indexPath.row])"
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: (view.frame.width/2)-5, height: (view.frame.height/2.5)-14)
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        if !Reachability.isConnected() { showAlert() }
        
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
        let taskListRow = taskListRows[0]
        let task = taskListRow.representedTask
        let taskViewController = ORKTaskViewController(task: task, taskRunUUID: nil)
        navigationController!.presentViewController(taskViewController, animated: false, completion: nil)
    }
    
    func showAlert(){
        let alertController = UIAlertController(title: "INTERNET_UNAVAILABLE_TITLE".localized, message: "INTERNET_UNAVAILABLE_TEXT".localized, preferredStyle: .Alert)
        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(defaultAction)
        
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
                    stepViewController.goForward()
                }
            })
        }
    }
    
    // MARK: ORKTaskViewControllerDelegate
    func taskViewController(taskViewController: ORKTaskViewController, didFinishWithReason reason: ORKTaskViewControllerFinishReason, error: NSError?) {
        
        let taskResult = taskViewController.result
        var dateNow = NSDate()
        
        switch reason {
        case .Completed:
            if let stepResults = taskResult.results as? [ORKStepResult] {
                for stepResult in stepResults {
                    for result in stepResult.results! {
                        if let questionStepResult = result as? ORKNumericQuestionResult {
                            if let answer = questionStepResult.answer  {
                                UserDefaults.setObject(answer, forKey: UserDefaultKey.Weight)
                                UserDefaults.setObject(taskResult.endDate, forKey: UserDefaultKey.LastWeightTime)
                            }
                        }
                        if taskResult.identifier == PillTask.identifier {
                            if (UIApplication.sharedApplication().applicationIconBadgeNumber > 0) {
                                UIApplication.sharedApplication().applicationIconBadgeNumber = UIApplication.sharedApplication().applicationIconBadgeNumber - 1
                            }
                            
                            if let lastDosageTime = result as? ORKTimeOfDayQuestionResult {
                                if let timeAnswer = lastDosageTime.dateComponentsAnswer {
                                    dateNow = NSCalendar.currentCalendar().dateBySettingHour(
                                        timeAnswer.hour, minute: timeAnswer.minute, second: 0, ofDate: dateNow, options: NSCalendarOptions()
                                        )!
                                    UserDefaults.setObject(dateNow, forKey: UserDefaultKey.LastDosageTime)
                                }
                            }
                            if let choiceResult = result as? ORKChoiceQuestionResult {
                                if let _ = choiceResult.answer {
                                    if choiceResult.choiceAnswers![0] as! String == "now" {
                                        UserDefaults.setObject(dateNow, forKey: UserDefaultKey.LastDosageTime)
                                    }
                                }
                            }
                        }
                        
                    }
                }
            }
            
            if let csv = ResultHandler.createCSVFromResult(taskResult) {
                Nettskjema.upload(csv)
            } else {
                NSLog("Failed to encode task result as NSData")
            }
            
        case .Failed, .Discarded, .Saved:
            break
        }
        
        taskViewController.dismissViewControllerAnimated(true, completion: nil)
    }
    
    private func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }

}