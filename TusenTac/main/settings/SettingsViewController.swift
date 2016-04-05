//
//  SettingsViewController.swift
//  TusenTac
//
//  Created by ingeborg ødegård oftedal on 17/12/15.
//  Copyright © 2015 Paul Philip Mitchell. All rights reserved.
//
import UIKit

class SettingsViewController: UITableViewController, UITextFieldDelegate {
    
    // MARK: Outlets
    @IBOutlet weak var notificationSwitch: UISwitch!
    
    @IBOutlet weak var morningTimeLabel: UILabel!
    @IBOutlet weak var morningTimePicker: UIDatePicker!
    @IBOutlet weak var morningSwitch: UISwitch!
    @IBOutlet weak var morningDosageTextField: UITextField!
    
    @IBOutlet weak var nightTimeLabel: UILabel!
    @IBOutlet weak var nightTimePicker: UIDatePicker!
    @IBOutlet weak var nightSwitch: UISwitch!
    @IBOutlet weak var nightDosageTextField: UITextField!
    
    // MARK: Variables and constants
    var morningTimePickerHidden = true
    var nightTimePickerHidden = true
    @IBAction func notificationsChanged(sender: AnyObject) {
        if notificationSwitch.on {
            Notification.sharedInstance.setupNotificationSettings()
            scheduleNotifications()
        } else {
            Notification.sharedInstance.cancelAllNotifications()
            UserDefaults.setObject(notificationSwitch.on, forKey: UserDefaultKey.NotificationsEnabled)
        }
        
        UserDefaults.setBool(notificationSwitch.on, forKey: UserDefaultKey.NotificationsEnabled)
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    @IBAction func morningSwitchChanged(sender: AnyObject) {
        UserDefaults.setObject(morningSwitch.on, forKey: UserDefaultKey.morningSwitchOn)
        let morningDate: NSDate? = morningSwitch.on ? morningTimePicker.date : nil
        let nightDate: NSDate? = nightSwitch.on ? nightTimePicker.date : nil
        Notification.sharedInstance.scheduleNotifications(morningDate, evening: nightDate)
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    @IBAction func morningTimeChanged(sender: AnyObject) {
        morningTimeChanged()
        UserDefaults.setObject(morningTimePicker.date, forKey: UserDefaultKey.morningTime)
        let nightDate: NSDate? = nightSwitch.on ? nightTimePicker.date : nil
        Notification.sharedInstance.scheduleNotifications(morningTimePicker.date, evening: nightDate)
    }
    
    @IBAction func nightSwitchChanged(sender: AnyObject) {
        UserDefaults.setObject(nightSwitch.on, forKey: UserDefaultKey.nightSwitchOn)
        let morningDate: NSDate? = morningSwitch.on ? morningTimePicker.date : nil
        let nightDate: NSDate? = nightSwitch.on ? nightTimePicker.date : nil
        Notification.sharedInstance.scheduleNotifications(morningDate, evening: nightDate)
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    @IBAction func nightTimeChanged(sender: AnyObject) {
        nightTimeChanged()
        UserDefaults.setObject(nightTimePicker.date, forKey: UserDefaultKey.nightTime)
        let morningDate: NSDate? = morningSwitch.on ? morningTimePicker.date : nil
        Notification.sharedInstance.scheduleNotifications(morningDate, evening: nightTimePicker.date)
    }

    @IBAction func morningDosageChanged(sender: AnyObject) {
        UserDefaults.setObject(morningDosageTextField.text, forKey: UserDefaultKey.morningDosage)
    }
    
    @IBAction func nightDosageChanged(sender: AnyObject) {
        UserDefaults.setObject(nightDosageTextField.text, forKey: UserDefaultKey.nightDosage)
    }
    

    
    // MARK: TableView delegates
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if      indexPath.section == 1 && indexPath.row == 1 { toggleDatepicker(1) } // morningTimePicker
        else if indexPath.section == 1 && indexPath.row == 3 { morningDosageTextField.becomeFirstResponder() }
        else if indexPath.section == 2 && indexPath.row == 1 { toggleDatepicker(2) } // nightTimePicker
        else if indexPath.section == 2 && indexPath.row == 3 { nightDosageTextField.becomeFirstResponder() }
    
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    
        // Hide / Show datepickers
        if  (morningTimePickerHidden && indexPath.section == 1 && indexPath.row == 2) ||
            (nightTimePickerHidden && indexPath.section == 2 && indexPath.row == 2)
        {
            return 0
        }
            
        else if
            (!morningSwitch.on && indexPath.section == 1 && (indexPath.row == 1 || indexPath.row == 2 || indexPath.row == 3)) ||
            (!nightSwitch.on && indexPath.section == 2 && (indexPath.row == 1 || indexPath.row == 2 || indexPath.row == 3))
        {
            return 0
        }
            
    
        else {
            return super.tableView(tableView, heightForRowAtIndexPath: indexPath)
        }
        
    }
    
    func toggleDatepicker(cell: Int) {
        if      cell == 1 { morningTimePickerHidden = !morningTimePickerHidden }
        else if cell == 2 { nightTimePickerHidden =  !nightTimePickerHidden }
        
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    func morningTimeChanged() {
        morningTimeLabel.text = NSDateFormatter.localizedStringFromDate(
            morningTimePicker.date,
            dateStyle: NSDateFormatterStyle.NoStyle,
            timeStyle: NSDateFormatterStyle.ShortStyle
        )
    }
    
    func nightTimeChanged() {
        nightTimeLabel.text = NSDateFormatter.localizedStringFromDate(
            nightTimePicker.date,
            dateStyle: NSDateFormatterStyle.NoStyle,
            timeStyle: NSDateFormatterStyle.ShortStyle
        )
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        morningDosageTextField.delegate = self
        nightDosageTextField.delegate = self
        
        notificationSwitch.on = UserDefaults.boolForKey(UserDefaultKey.NotificationsEnabled)        
        morningSwitch.on = UserDefaults.boolForKey(UserDefaultKey.morningSwitchOn)
        nightSwitch.on = UserDefaults.boolForKey(UserDefaultKey.nightSwitchOn)
        
        addDoneButtonOnKeyboard()
    
        if let morningTime = UserDefaults.objectForKey(UserDefaultKey.morningTime) {
            morningTimePicker.setDate(morningTime as! NSDate, animated: true)
        }
    
        if let nightTime = UserDefaults.objectForKey(UserDefaultKey.nightTime) {
            nightTimePicker.setDate(nightTime as! NSDate, animated: true)
        }
        
        if let morningDosage = UserDefaults.objectForKey(UserDefaultKey.morningDosage) {
            morningDosageTextField.text = morningDosage as? String
        }
        else {
            morningDosageTextField.placeholder = "0";
        }
        
        if let nightDosage = UserDefaults.objectForKey(UserDefaultKey.nightDosage) {
            nightDosageTextField.text = nightDosage as? String
        }
        else {
            nightDosageTextField.placeholder = "0";
        }
    
        morningTimeChanged()
        nightTimeChanged()

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        let whitespaceSet = NSCharacterSet.whitespaceCharacterSet()
        if textField.text!.stringByTrimmingCharactersInSet(whitespaceSet).isEmpty {
            textField.placeholder = "0"
            print("textfield.text = \(textField.text)")
        }
    }
    
    func addDoneButtonOnKeyboard() {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRectMake(0, 0, 320, 50))
        doneToolbar.barStyle = UIBarStyle.Default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Done, target: self, action: #selector(SettingsViewController.doneButtonAction))
        
        var items = [UIBarButtonItem]()
        items.append(flexSpace)
        items.append(done)
        
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        morningDosageTextField.inputAccessoryView = doneToolbar
        nightDosageTextField.inputAccessoryView = doneToolbar
    }
    
    func doneButtonAction()
    {
        morningDosageTextField.resignFirstResponder()
        nightDosageTextField.resignFirstResponder()
    }

    
    func scheduleNotifications() {
        Notification.sharedInstance.scheduleNotifications(
            morningTimePicker.date,
            evening: nightTimePicker.date
        )
    }
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if(textField == nightDosageTextField || textField == morningDosageTextField){
            let tempRange = textField.text!.rangeOfString(",", options: NSStringCompareOptions.LiteralSearch, range: nil, locale: nil)
            if tempRange?.isEmpty == false && string == "," {
                return false
            }
        }
        return true
    }
}
