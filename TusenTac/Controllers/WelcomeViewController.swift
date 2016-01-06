//
//  WelcomeViewController.swift
//  TusenTac
//
//  Created by ingeborg ødegård oftedal on 17/12/15.
//  Copyright © 2015 Paul Philip Mitchell. All rights reserved.
//
import UIKit

class WelcomeViewController: UIViewController, UITextFieldDelegate {
    
    let defaults = NSUserDefaults.standardUserDefaults()
    
    @IBOutlet weak var dosageTextField: UITextField!
    @IBOutlet weak var nightTimePicker: UIDatePicker!
    @IBOutlet weak var dosageLabel: UITextField!
    @IBOutlet weak var morningDayPicker: UIDatePicker!
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "segueShowTaskList" {
            let morningTime = morningDayPicker.date
            let bedTime = nightTimePicker.date
            let dosage = dosageLabel.text
            defaults.setObject(morningTime, forKey: UserDefaultKey.morningTime)
            defaults.setObject(bedTime, forKey: UserDefaultKey.nightTime)
            defaults.setObject(dosage, forKey: UserDefaultKey.nightDosage)
            defaults.setObject(dosage, forKey: UserDefaultKey.morningDosage)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dosageTextField.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
