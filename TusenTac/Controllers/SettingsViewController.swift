//
//  SettingsViewController.swift
//  TusenTac
//
//  Created by ingeborg ødegård oftedal on 17/12/15.
//  Copyright © 2015 Paul Philip Mitchell. All rights reserved.
//
import UIKit

class SettingsViewController: UIViewController {
    
    let defaults = NSUserDefaults.standardUserDefaults()
    
    @IBOutlet weak var morningTimePicker: UIDatePicker!
    @IBOutlet weak var bedTimePicker: UIDatePicker!
    @IBOutlet weak var dosageTextField: UITextField!
    
    
    @IBAction func morningTimeChanged(sender: AnyObject) {
        defaults.setObject(
            morningTimePicker.date,
            forKey: UserDefaultKey.morningTime
        )
    }
    
    @IBAction func bedTimeChanged(sender: AnyObject) {
        defaults.setObject(
            bedTimePicker.date,
            forKey: UserDefaultKey.bedTime
        )
    }
    
    @IBAction func dosageChanged(sender: AnyObject) {
        defaults.setObject(
            dosageTextField.text,
            forKey: UserDefaultKey.dosage
        )
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        morningTimePicker.setDate(
            defaults.objectForKey(UserDefaultKey.morningTime) as! NSDate,
            animated: true
        )
        
        bedTimePicker.setDate(
            defaults.objectForKey(UserDefaultKey.bedTime) as! NSDate,
            animated: true
        )
        
        dosageTextField.text = defaults.objectForKey(UserDefaultKey.dosage) as? String
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}

