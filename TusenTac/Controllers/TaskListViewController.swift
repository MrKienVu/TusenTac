//
//  TaskListViewController.swift
//  TusenTac
//
//  Created by ingeborg ødegård oftedal on 17/12/15.
//  Copyright © 2015 Paul Philip Mitchell. All rights reserved.
//

import Foundation
import ResearchKit

class TaskListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, ORKTaskViewControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var settingsIcon: UIBarButtonItem!
    
    let nettskjema = NettskjemaHandler(scheme: .SideEffects)
    
    enum TableViewCellIdentifier: String {
        case Default = "Default"
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
        
        tableView.delegate = self
        tableView.dataSource = self
        
        animateSettingsIconWithDuration(1.7)
        
        // Do any additional setup after loading the view.
    }
    
    // MARK: UITableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskListRows.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(TableViewCellIdentifier.Default.rawValue, forIndexPath: indexPath)
        
        let taskListRow = taskListRows[indexPath.row]
        
        cell.textLabel!.text = "\(taskListRow)"
        
        return cell
    }
    
    // MARK: UITableViewDelegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
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
        
        self.nettskjema.setExtraField("\(taskViewController.result.identifier)", result: taskViewController.result)
        //self.nettskjema.submit()
        
        
        taskViewController.dismissViewControllerAnimated(true, completion: nil)
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}