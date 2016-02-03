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
    @IBOutlet weak var morningDosageTextField: UITextField!
    
    @IBOutlet weak var nightTimeLabel: UILabel!
    @IBOutlet weak var nightTimePicker: UIDatePicker!
    @IBOutlet weak var nightDosageTextField: UITextField!
    
    // MARK: Variables and constants
    var morningTimePickerHidden = true
    var nightTimePickerHidden = true

    
    
    // MARK: On Value Changed
    @IBAction func notificationsChanged(sender: AnyObject) {
        // TODO: Cancel notifications
        if notificationSwitch.on { Notification.sharedInstance.setupNotificationSettings() }
        UserDefaults.setBool(notificationSwitch.on, forKey: UserDefaultKey.NotificationsEnabled)
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    @IBAction func morningTimeChanged(sender: AnyObject) {
        morningTimeChanged()
        UserDefaults.setObject(morningTimePicker.date, forKey: UserDefaultKey.morningTime)
    }
    
    @IBAction func nightTimeChanged(sender: AnyObject) {
        nightTimeChanged()
        UserDefaults.setObject(nightTimePicker.date, forKey: UserDefaultKey.nightTime)
    }

    @IBAction func morningDosageChanged(sender: AnyObject) {
        UserDefaults.setObject(morningDosageTextField.text, forKey: UserDefaultKey.morningDosage)
    }
    
    @IBAction func nightDosageChanged(sender: AnyObject) {
        UserDefaults.setObject(nightDosageTextField.text, forKey: UserDefaultKey.nightDosage)
    }
    

    
    // MARK: TableView delegates
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if      indexPath.section == 0 && indexPath.row == 1 { toggleDatepicker(1) } // morningTimePicker
        else if indexPath.section == 0 && indexPath.row == 4 { toggleDatepicker(2) } // nightTimePicker
    
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    
        // Hide / Show datepickers
        if  (morningTimePickerHidden && indexPath.section == 0 && indexPath.row == 2) ||
            (nightTimePickerHidden && indexPath.section == 0 && indexPath.row == 5)
        {
            return 0
        }
        
    
        // Hide / Show all rows in first section based on notification switch
        /*else if (!notificationSwitch.on && indexPath.section == 0 && indexPath.row == 1) ||
                (!notificationSwitch.on && indexPath.section == 0 && indexPath.row == 2) ||
                (!notificationSwitch.on && indexPath.section == 0 && indexPath.row == 3) ||
                (!notificationSwitch.on && indexPath.section == 0 && indexPath.row == 4)
        {
            return 0
        }*/
    
        else {
            return super.tableView(tableView, heightForRowAtIndexPath: indexPath)
        }
        
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
    
    func toggleDatepicker(cell: Int) {
        if      cell == 1 { morningTimePickerHidden = !morningTimePickerHidden }
        else if cell == 2 { nightTimePickerHidden =  !nightTimePickerHidden }
    
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //print(UserDefaults.valueForKey("Weight"))
        
        morningDosageTextField.delegate = self
        nightDosageTextField.delegate = self

        notificationSwitch.on = UserDefaults.boolForKey(UserDefaultKey.NotificationsEnabled)
    
        if let morningTime = UserDefaults.objectForKey(UserDefaultKey.morningTime) {
            morningTimePicker.setDate(morningTime as! NSDate, animated: true)
        }
    
        if let nightTime = UserDefaults.objectForKey(UserDefaultKey.nightTime) {
            nightTimePicker.setDate(nightTime as! NSDate, animated: true)
        }
        
        if let morningDosage = UserDefaults.objectForKey(UserDefaultKey.morningDosage) {
            morningDosageTextField.text = morningDosage as? String
        }
        
        if let nightDosage = UserDefaults.objectForKey(UserDefaultKey.nightDosage) {
            nightDosageTextField.text = nightDosage as? String
        }
    
        morningTimeChanged()
        nightTimeChanged()

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidDisappear(animated: Bool) {
        scheduleLocalNotification()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    func scheduleLocalNotification() {
        let localNotification = UILocalNotification()
        let fireDate = fixNotificationDate(morningTimePicker.date)
        localNotification.fireDate = fireDate
        localNotification.alertBody = "Du har en ny oppgave å gjøre."
        localNotification.alertAction = "Vise valg"
        localNotification.category = "NOTIFICATION_CATEGORY"
        UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
        print("Scheduled local notification at firedate: \(fireDate)")
    }
    
    private func fixNotificationDate(dateToFix: NSDate) -> NSDate {
    
        let calendar = NSCalendar.currentCalendar()
    
        let currentDate = NSDate()
        let currentDateComponents = calendar.components([.Year, .Month, .Day], fromDate: currentDate)
    
        let otherDateComponents = calendar.components([.Year, .Month, .Day, .Hour, .Minute], fromDate: dateToFix)
        otherDateComponents.year = currentDateComponents.year
        otherDateComponents.month = currentDateComponents.month
        otherDateComponents.day = currentDateComponents.day
    
        let fixedDate = calendar.dateFromComponents(otherDateComponents)
    
        return fixedDate!
    }
}
