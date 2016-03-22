//
//  ContactTableViewController.swift
//  TusenTac
//
//  Created by ingeborg ødegård oftedal on 21/03/16.
//  Copyright © 2016 ingeborg ødegård oftedal. All rights reserved.
//

import UIKit

class ContactTableViewController: UITableViewController {

    @IBOutlet weak var phoneNumber1Label: UILabel!
    @IBOutlet weak var phoneNumber2Label: UILabel!
    
    @IBOutlet weak var mailLabel: UILabel!
    
    let phone1 = "40486106"
    let phone2 = "90932530"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func openPhoneApp(phoneNumber:String) {
        let url = NSURL(string: "tel://\(phoneNumber)")
        if url != nil {
            UIApplication.sharedApplication().openURL(url!);
        }
    }
    
    func openMailApp(mail:String){
        let url = NSURL(string: "mailto:\(mail)")
        UIApplication.sharedApplication().openURL(url!)
    }

    // MARK: - Table view data source
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if(indexPath.section == 0) {
            if(indexPath.row == 0){
                openPhoneApp(phone1)
            }
            else if (indexPath.row == 1){
                openPhoneApp(phone2)
            }
        }
        else if (indexPath.section == 1 && indexPath.row == 0){
            openMailApp(mailLabel.text!)
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
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
