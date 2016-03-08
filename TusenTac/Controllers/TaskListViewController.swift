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


private let reuseIdentifier = "Cell"

class TaskListViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, ORKTaskViewControllerDelegate {
    
    @IBOutlet var collection: UICollectionView!
    
    @IBOutlet var medication: UIImageView!
    @IBOutlet var eating: UIImageView!
    @IBOutlet var weight: UIImageView!
    @IBOutlet var sideEffects: UIImageView!
    @IBOutlet weak var settingsIcon: UIBarButtonItem!
    
    var logos = [UIImage]()
    
   // logos = ["medication", "eating", "side-effects", "weight"];
    
    enum CollectionViewCellIdentifier: String {
        case Default = "Cell"
    }
    
    // MARK: Properties
    
    /**
    When a task is completed, the `TaskListViewController` calls this closure
    with the created task.
    */
    var taskResultFinishedCompletionHandler: (ORKResult -> Void)?
    
    let taskListRows = TaskListRow.allCases
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Register cell classes
        // self.collectionView!.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        
        collection.dataSource = self
        collection.delegate = self
  
        collection.registerNib(UINib(nibName: "TaskCollectionCell", bundle: nil), forCellWithReuseIdentifier: "Cell")
        self.navigationController?.title = "TusenTac"
        /*self.navigationController?.navigationBar.translucent = false
        self.navigationController?.navigationBar.barStyle = .Black
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 246/255, green: 246/255, blue: 246/255, alpha: 1) */
        
        
        collection.backgroundColor = UIColor(red: 237/255, green: 237/255, blue: 237/255, alpha: 1)
 
        
        animateSettingsIconWithDuration(1.7)
        
        // Do any additional setup after loading the view.
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
            //1
            switch kind {
                //2
            case UICollectionElementKindSectionFooter:
                //3
                let footerView =
                collectionView.dequeueReusableSupplementaryViewOfKind(kind,
                    withReuseIdentifier: "UIOFooterView",
                    forIndexPath: indexPath)
                    as! FooterView
                
                return footerView
            default:
                //4
                fatalError("Unexpected element kind")
            }
    }
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: UICollectionViewDataSource

    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return taskListRows.count
       
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! TaskCollectionCell
        
        let med = "medication"
        let img = UIImage(named: med)
        let eat = "eating"
        let img2 = UIImage(named: eat)
        let weight = "weight"
        let img3 = UIImage(named: weight)
        let side = "side-effects"
        let img4 = UIImage(named: side)
        
       // let imageView = UIImageView(image: img)
        
        
     //   medication.image = UIImageView(named:"medication")
        logos.append(img!)
        logos.append(img2!)
        logos.append(img3!)
        logos.append(img4!)
        
        
        let taskListRow = taskListRows[indexPath.row]
        
        if(indexPath.row == 0){
            cell.lastDosageLabel.text = "Forrige dose tatt 3.1.15 kl 09:15"
        }
        else {
            cell.lastDosageLabel.hidden = true;
        }
        
        //let logoFont = UIFont(name: "SSGizmo", size: 60)
        
        cell.iconImage.image = logos[indexPath.row]
    //    cell.iconLabel.text = logos[indexPath.row]
        cell.taskLabel.text = "\(taskListRow)"
        
        cell.taskLabel.sizeToFit()
        
        
        return cell
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: (self.view.frame.width/2)-5, height: (self.view.frame.height/2.5)-20)
    }
    
    // MARK: UICollectionViewDelegate
    
    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
    return true
    }
    */
    
    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
    return true
    }
    */
    
    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
    return false
    }
    
    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
    return false
    }

    func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
        
    } */
    
    // MARK: ORKTaskViewControllerDelegate
    
    func taskViewController(taskViewController: ORKTaskViewController, didFinishWithReason reason: ORKTaskViewControllerFinishReason, error: NSError?) {
        /*
        The `reason` passed to this method indicates why the task view
        controller finished: Did the user cancel, save, or actually complete
        the task; or was there an error?
        
        The actual result of the task is on the `result` property of the task
        view controller.
        */
        taskResultFinishedCompletionHandler?(taskViewController.result)
        
        
        let taskResult = taskViewController.result
        
        if let stepResults = taskResult.results as? [ORKStepResult] {
            for stepResult in stepResults {
                for result in stepResult.results! {
                    if let questionStepResult = result as? ORKNumericQuestionResult {
                        if let answer = questionStepResult.answer  {
                            UserDefaults.setObject(answer, forKey: "Weight")
                        }
                    }
                    /*    if let lastDosageTime = result as? ORKTimeOfDayQuestionResult {
                    if let timeAnswer = lastDosageTime.answer {
                    UserDefaults.setObject(timeAnswer, forKey: "LastDosageTime")
                    }
                    }*/
                }
            }
        }
        
        //print(UserDefaults.valueForKey("Weight"))
        
       /* self.nettskjema.setExtraField("\(taskViewController.result.identifier)", result: taskViewController.result) */
        //self.nettskjema.submit()
        
        
        taskViewController.dismissViewControllerAnimated(true, completion: nil)
    }
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
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
        taskViewController.outputDirectory = NSFileManager.defaultManager().URLsForDirectory(NSSearchPathDirectory.DocumentDirectory, inDomains: NSSearchPathDomainMask.UserDomainMask)[0] as NSURL
        
        
        /*
        We present the task directly, but it is also possible to use segues.
        The task property of the task view controller can be set any time before
        the task view controller is presented.
        */
        presentViewController(taskViewController, animated: true, completion: nil)
        
    }
    
    func getNumberOfStepsCompleted(results: [ORKResult]) -> Int {
        return results.count
    }
    
    func animateSettingsIconWithDuration(duration: Double) {
        let settingsView: UIView = settingsIcon.valueForKey("view") as! UIView
        UIView.animateWithDuration(duration, animations: {
            settingsView.transform = CGAffineTransformMakeRotation((90.0 * CGFloat(M_PI)) / 90.0)
        })
    }
    
}