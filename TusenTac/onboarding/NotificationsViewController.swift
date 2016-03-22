//
//  NotificationsViewController.swift
//  MinDag
//
//  Created by Paul Philip Mitchell on 19/02/16.
//  Copyright © 2016 Universitetet i Oslo. All rights reserved.
//

import UIKit

class NotificationsViewController: UIViewController {
    
    @IBOutlet weak var givePermissionButton: UIButton!
    @IBOutlet weak var notNowButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var checkmarkLabel: UILabel!
    @IBOutlet weak var notificationsEnabledLabel: UILabel!
    @IBOutlet weak var notificationsText: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        if Notification.sharedInstance.isNotificationsEnabled() {
            enableNextButton()
            showEnabledLabels()
        }
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "animateEnabledLabels", name: UIApplicationDidBecomeActiveNotification, object: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIApplicationDidBecomeActiveNotification, object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func givePermissionClicked(sender: AnyObject) {
        Notification.sharedInstance.setupNotificationSettings()
        
        UIView.animateWithDuration(0.8, animations: {
            self.nextButton.alpha = 1
            self.notNowButton.alpha = 0
            self.givePermissionButton.setTitleColor(UIColor(red: 1, green: 1, blue: 1, alpha: 0), forState: .Normal)
        })
        
        enableNextButton()
    }
    
    @IBAction func notNowClicked(sender: AnyObject) {
        let alert = UIAlertController(
            title: "Påminnelser av",
            message: "Påminnelser vil hjelpe deg med å huske å gjøre oppgaver i appen. Det anbefales på det sterkeste å gi tilgang til påminnelser.",
            preferredStyle: .Alert
        )
        
        alert.addAction(UIAlertAction(title: "Fortsett uten påminnelser", style: .Default, handler: { action in
            self.performSegueWithIdentifier("segueShowPasscode", sender: self)
        }))
        
        alert.addAction(UIAlertAction(title: "Gi tilgang", style: .Cancel, handler: { action
            in
            
            Notification.sharedInstance.setupNotificationSettings()
            
            UIView.animateWithDuration(0.8, animations: {
                self.nextButton.alpha = 1
                self.notNowButton.alpha = 0
                self.givePermissionButton.setTitleColor(UIColor(red: 1, green: 1, blue: 1, alpha: 0), forState: .Normal)
            })
            self.enableNextButton()
        }))
        
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func animateEnabledLabels() {
        UIView.animateWithDuration(0.8, animations: {
            self.showEnabledLabels()
        })
    }
    
    func showEnabledLabels() {
        checkmarkLabel.alpha = 1
        notificationsEnabledLabel.alpha = 1
    }
    
    func enableNextButton() {
        // Show next button
        nextButton.enabled = true
        nextButton.alpha = 1
        nextButton.hidden = false
        
        // Hide 'Not Now'-button and 'Give Permissions'-button
        notNowButton.enabled = false
        notNowButton.hidden = true
        
        givePermissionButton.enabled = false
        givePermissionButton.hidden = true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if Notification.sharedInstance.isNotificationsEnabled() {
            UserDefaults.setBool(true, forKey: UserDefaultKey.NotificationsEnabled)
            UserDefaults.setBool(true, forKey: UserDefaultKey.morningSwitchOn)
            UserDefaults.setBool(true, forKey: UserDefaultKey.nightSwitchOn)
        }
        let defaultDates = Notification.sharedInstance.getDefaultDates()
        Notification.sharedInstance.scheduleNotifications(defaultDates[0], evening: defaultDates[1])
    }
    
}
