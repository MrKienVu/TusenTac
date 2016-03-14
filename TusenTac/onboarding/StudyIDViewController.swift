//
//  StudyIDViewController.swift
//  MinDag
//
//  Created by Paul Philip Mitchell on 19/02/16.
//  Copyright © 2016 Universitetet i Oslo. All rights reserved.
//

import UIKit

class StudyIDViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var repeatIdTextField: UITextField!
    @IBOutlet weak var checkmark: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var nextButtonBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var studyIdTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var studyIDText: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        idTextField.delegate = self
        repeatIdTextField.delegate = self
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: self.view.window)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: self.view.window)
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func repeatIdChanged(sender: AnyObject) {
        if equalTextFields() {
            animateEqualTextfields()
        } else {
            animateInequalTextFields()
        }
    }
    
    @IBAction func IdChanged(sender: AnyObject) {
        if equalTextFields() {
            animateEqualTextfields()
        } else {
            animateInequalTextFields()
        }
    }
    
    func equalTextFields() -> Bool {
        if idTextField.text == repeatIdTextField.text && repeatIdTextField.text?.characters.count >= 3 {
            return true
        }
        
        return false
    }
    
    func animateEqualTextfields() {
        checkmark.hidden = false
        UIView.animateWithDuration(0.8, animations: {
            self.checkmark.alpha = 1.0
            self.nextButton.backgroundColor = Color.primaryColor
            self.nextButton.alpha = 1.0
        })
        nextButton.enabled = true
    }
    
    func animateInequalTextFields() {
        UIView.animateWithDuration(0.4, animations: {
            self.checkmark.alpha = 0.0
            self.nextButton.backgroundColor = Color.secondaryColor
            self.nextButton.alpha = 0.4
        })
        checkmark.hidden = true
        nextButton.enabled = false
    }
    
    func keyboardWillShow(sender: NSNotification) {
        let userInfo: [NSObject : AnyObject] = sender.userInfo!
        let keyboardSize: CGSize = userInfo[UIKeyboardFrameBeginUserInfoKey]!.CGRectValue.size
        let offset: CGSize = userInfo[UIKeyboardFrameEndUserInfoKey]!.CGRectValue.size
        
        if keyboardSize.height == offset.height {
            if nextButtonBottomConstraint.constant == 0 {
                nextButtonBottomConstraint.constant += keyboardSize.height
                studyIdTopConstraint.constant -= 120
                UIView.animateWithDuration(0.1, animations: { () -> Void in
                    self.view.layoutIfNeeded()
                })
            }
        } else {
            nextButtonBottomConstraint.constant -= keyboardSize.height + offset.height
            studyIdTopConstraint.constant -= 120
            UIView.animateWithDuration(0.1, animations: { () -> Void in
                self.view.layoutIfNeeded()
            })
        }
    }
    
    func keyboardWillHide(sender: NSNotification) {
        nextButtonBottomConstraint.constant = 0
        studyIdTopConstraint.constant = 8
        UIView.animateWithDuration(0.1, animations: { () -> Void in
            self.view.layoutIfNeeded()
            
        })
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField == idTextField { repeatIdTextField.becomeFirstResponder() }
        return true
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        UserDefaults.setObject(repeatIdTextField.text!, forKey: UserDefaultKey.StudyID)
    }
    
}