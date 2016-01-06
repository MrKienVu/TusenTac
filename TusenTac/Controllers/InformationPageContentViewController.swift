//
//  InformationPageContentViewController.swift
//  TusenTac
//
//  Created by Paul Philip Mitchell on 06/01/16.
//  Copyright © 2016 ingeborg ødegård oftedal. All rights reserved.
//

import UIKit

class InformationPageContentViewController: UIViewController {
    
    var pageIndex: Int!
    var titleIndex: String!
    var imageFile: String!
    var textViewText: String!

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var permissionButton: UIButton!
    
    @IBAction func permissionsClicked(sender: AnyObject) {
        Notification.sharedInstance.setupNotificationSettings()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.image = UIImage(named: self.imageFile)
        titleLabel.text = titleIndex
        textView.text = textViewText

    }
    
    override func viewDidLayoutSubviews() {
        configureButton()
    }
    
    func configureButton()
    {
        permissionButton.layer.cornerRadius = 5
        permissionButton.layer.borderColor = Color.primaryColor.CGColor
        permissionButton.layer.borderWidth = 1
        permissionButton.clipsToBounds = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
