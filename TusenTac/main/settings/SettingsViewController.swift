//
//  SettingsViewController.swift
//  TusenTac
//
//  Created by ingeborg ødegård oftedal on 17/12/15.
//  Copyright © 2015 Paul Philip Mitchell. All rights reserved.
//
import UIKit
import MessageUI

private let notificationSection = 0
private let morningSection = 1
private let nightSection = 2
private let weightSection = 3
private let contactSection = 4

class SettingsViewController: UITableViewController, UITextFieldDelegate, MFMailComposeViewControllerDelegate {
    
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
    
    @IBOutlet weak var weightSwitch: UISwitch!
    
    // MARK: Variables and constants
    var morningTimePickerHidden = true
    var nightTimePickerHidden = true
    @IBAction func notificationsChanged(sender: AnyObject) {
        if notificationSwitch.on {
            Notification.sharedInstance.setupNotificationSettings()
            Notification.sharedInstance.scheduleMedicineNotifications(
                morningTimePicker.date,
                evening: nightTimePicker.date
            )
        } else {
            Notification.sharedInstance.cancelAllNotifications()
            UserDefaults.setObject(notificationSwitch.on, forKey: UserDefaultKey.NotificationsEnabled)
        }
        
        UserDefaults.setBool(notificationSwitch.on, forKey: UserDefaultKey.NotificationsEnabled)
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    @IBAction func morningSwitchChanged(sender: AnyObject) {
        UserDefaults.setBool(morningSwitch.on, forKey: UserDefaultKey.morningSwitchOn)
        let morningDate: NSDate? = morningSwitch.on ? morningTimePicker.date : nil
        Notification.sharedInstance.scheduleMedicineNotifications(morningDate)
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    @IBAction func morningTimeChanged(sender: AnyObject) {
        morningTimeChanged()
        UserDefaults.setObject(morningTimePicker.date, forKey: UserDefaultKey.morningTime)
        Notification.sharedInstance.scheduleMedicineNotifications(morningTimePicker.date)
    }
    
    @IBAction func nightSwitchChanged(sender: AnyObject) {
        UserDefaults.setBool(nightSwitch.on, forKey: UserDefaultKey.nightSwitchOn)
        let nightDate: NSDate? = nightSwitch.on ? nightTimePicker.date : nil
        Notification.sharedInstance.scheduleMedicineNotifications(evening: nightDate)
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    @IBAction func nightTimeChanged(sender: AnyObject) {
        nightTimeChanged()
        UserDefaults.setObject(nightTimePicker.date, forKey: UserDefaultKey.nightTime)
        Notification.sharedInstance.scheduleMedicineNotifications(evening: nightTimePicker.date)
    }

    @IBAction func morningDosageChanged(sender: AnyObject) {
        UserDefaults.setObject(morningDosageTextField.text, forKey: UserDefaultKey.morningDosage)
        let morningDate: NSDate? = morningSwitch.on ? morningTimePicker.date : nil
        Notification.sharedInstance.scheduleMedicineNotifications(morningDate)
    }
    
    @IBAction func nightDosageChanged(sender: AnyObject) {
        UserDefaults.setObject(nightDosageTextField.text, forKey: UserDefaultKey.nightDosage)
        let nightDate: NSDate? = nightSwitch.on ? nightTimePicker.date : nil
        Notification.sharedInstance.scheduleMedicineNotifications(evening: nightDate)
    }
    
    @IBAction func weightSwitchChanged(sender: AnyObject) {
        UserDefaults.setBool(weightSwitch.on, forKey: UserDefaultKey.weightSwitchOn)
        Notification.sharedInstance.scheduleWeightNotification()
    }
    
    // MARK: TableView delegates
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if      indexPath.section == morningSection && indexPath.row == 1 { toggleDatepicker(morningSection) }
        else if indexPath.section == morningSection && indexPath.row == 3 { morningDosageTextField.becomeFirstResponder() }
        else if indexPath.section == nightSection && indexPath.row == 1 { toggleDatepicker(nightSection) }
        else if indexPath.section == nightSection && indexPath.row == 3 { nightDosageTextField.becomeFirstResponder() }
        else if indexPath.section == contactSection { sendEmail() }
    
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    
        // Hide / Show datepickers
        if  (morningTimePickerHidden && indexPath.section == morningSection && indexPath.row == 2) ||
            (nightTimePickerHidden && indexPath.section == nightSection && indexPath.row == 2)
        {
            return 0
        }
            
        else if
            (!morningSwitch.on && indexPath.section == morningSection && (indexPath.row == 1 || indexPath.row == 2 || indexPath.row == 3)) ||
                (!nightSwitch.on && indexPath.section == nightSection && (indexPath.row == 1 || indexPath.row == 2 || indexPath.row == 3))
        {
            return 0
        }
            
    
        else {
            return super.tableView(tableView, heightForRowAtIndexPath: indexPath)
        }
        
    }
    
    func toggleDatepicker(cell: Int) {
        if      cell == morningSection { morningTimePickerHidden = !morningTimePickerHidden }
        else if cell == nightSection { nightTimePickerHidden =  !nightTimePickerHidden }
        
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
    
    func sendEmail() {
        
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["\(Configuration.contactMailAddress)"])
            mail.setSubject("MinDag")
            
            presentViewController(mail, animated: true, completion: nil)
        } else {
            let alertController = UIAlertController(title: "MAIL_FAILED_TITLE".localized, message: "MAIL_FAILED_TEXT".localized, preferredStyle: .Alert)
            let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertController.addAction(defaultAction)
            
            presentViewController(alertController, animated: true, completion: nil)
        }
        
    }
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        morningDosageTextField.delegate = self
        nightDosageTextField.delegate = self
        
        notificationSwitch.on = UserDefaults.boolForKey(UserDefaultKey.NotificationsEnabled)        
        morningSwitch.on = UserDefaults.boolForKey(UserDefaultKey.morningSwitchOn)
        nightSwitch.on = UserDefaults.boolForKey(UserDefaultKey.nightSwitchOn)
        weightSwitch.on = UserDefaults.boolForKey(UserDefaultKey.weightSwitchOn)
        
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
    
    func doneButtonAction() {
        morningDosageTextField.resignFirstResponder()
        nightDosageTextField.resignFirstResponder()
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
