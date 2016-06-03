//
//  PasscodeViewController.swift
//  MinDag
//
//  Created by Paul Philip Mitchell on 19/02/16.
//  Copyright © 2016 Universitetet i Oslo. All rights reserved.
//

import UIKit
import ResearchKit

class PasscodeViewController: UIViewController {
    
    @IBOutlet weak var getStartedButton: UIButton!
    @IBOutlet weak var createCodeButton: UIButton!
    @IBOutlet weak var notNowButton: UIButton!
    @IBOutlet weak var checkmarkLabel: UILabel!
    @IBOutlet weak var codeCreatedLabel: UILabel!
    @IBOutlet weak var passcodeText: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        if ORKPasscodeViewController.isPasscodeStoredInKeychain() {
            enableNextButton()
            checkmarkLabel.hidden = false
            codeCreatedLabel.hidden = false
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func notNowClicked(sender: AnyObject) {
        let alert = UIAlertController(
            title: "Ingen app kode",
            message: "Det er svært anbefalt å opprette en app kode, da dette vil sikre dataene dine på en god måte.",
            preferredStyle: .Alert
        )
        alert.addAction(UIAlertAction(title: "Fortsett uten app kode", style: .Default, handler: { action in
            UserDefaults.setBool(true, forKey: UserDefaultKey.CompletedOnboarding)
            NSLog("Completed onboarding")
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateInitialViewController()
            self.presentViewController(vc!, animated: true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        
        presentViewController(alert, animated: true, completion: nil)
    }
    
    @IBAction func createAppCodeClicked(sender: AnyObject) {
        let passcodeStep = ORKPasscodeStep(identifier: "Passcode")
        passcodeStep.text = "Please create a pass code"
        let task = ORKOrderedTask(identifier: "PasscodeTask", steps: [passcodeStep])
        let taskVC = ORKTaskViewController(task: task, taskRunUUID: nil)
        taskVC.delegate = self
        presentViewController(taskVC, animated: true, completion: nil)
    }
    
    @IBAction func getStartedClicked(sender: AnyObject) {
        // Setting defaults
        let defaultDates = Notification.sharedInstance.getDefaultDates()
        Notification.sharedInstance.scheduleNotifications(defaultDates[0], evening: defaultDates[1])
        UserDefaults.setObject("200", forKey: UserDefaultKey.morningDosage)
        UserDefaults.setObject("200", forKey: UserDefaultKey.nightDosage)
        
        // Presenting main storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateInitialViewController()
        presentViewController(vc!, animated: true, completion: nil)
    }
    
    func enableNextButton() {
        // Show next button
        getStartedButton.enabled = true
        getStartedButton.alpha = 1
        getStartedButton.hidden = false
        
        // Hide 'Not Now'-button and 'Give Permissions'-button
        notNowButton.enabled = false
        notNowButton.hidden = true
        
        createCodeButton.enabled = false
        createCodeButton.hidden = true
    }
    
}

extension PasscodeViewController: ORKTaskViewControllerDelegate {
    
    func taskViewController(taskViewController: ORKTaskViewController, didFinishWithReason reason: ORKTaskViewControllerFinishReason, error: NSError?) {
        switch reason {
        case .Completed:
            UserDefaults.setBool(true, forKey: UserDefaultKey.CompletedOnboarding)
            NSLog("Completed onboarding")
            
            checkmarkLabel.hidden = false
            codeCreatedLabel.hidden = false
            enableNextButton()
            taskViewController.dismissViewControllerAnimated(true, completion: nil)
            
        case .Failed, .Discarded, .Saved:
            taskViewController.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
}
