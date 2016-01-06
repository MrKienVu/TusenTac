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
        defaults.setObject(morningTimePicker.date,forKey: UserDefaultKey.morningTime)
    }
    
    @IBAction func bedTimeChanged(sender: AnyObject) {
        defaults.setObject(bedTimePicker.date, forKey: UserDefaultKey.bedTime)
    }
    
    @IBAction func dosageChanged(sender: AnyObject) {
        defaults.setObject(dosageTextField.text,forKey: UserDefaultKey.dosage)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let morningTime = defaults.objectForKey(UserDefaultKey.morningTime) {
            morningTimePicker.setDate(morningTime as! NSDate, animated: true)
        }
        
        if let bedTime = defaults.objectForKey(UserDefaultKey.bedTime) {
            bedTimePicker.setDate(bedTime as! NSDate, animated: true)
        }
        
        if let dosage = defaults.objectForKey(UserDefaultKey.dosage) {
            dosageTextField.text = dosage as? String
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

