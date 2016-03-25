//
//  PersonNumberViewController.swift
//  TusenTac
//
//  Created by Paul Philip Mitchell on 18/03/16.
//  Copyright © 2016 ingeborg ødegård oftedal. All rights reserved.
//

import UIKit

class PersonNumberViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var personNumberTextField: UITextField!
    @IBOutlet weak var checkmark: UILabel!
    @IBOutlet weak var nextButtonBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var personNumberTopConstraint: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        personNumberTextField.delegate = self
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(PersonNumberViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: self.view.window)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(PersonNumberViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: self.view.window)
    }

    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    @IBAction func personNumberChanged(sender: AnyObject) {
        isElevenDigits() ? animateCorrectPersonNumber() : animateIncorrectPersonNumber()
    }
    
    func animateCorrectPersonNumber() {
        checkmark.hidden = false
        UIView.animateWithDuration(0.8, animations: {
            self.checkmark.alpha = 1.0
            self.nextButton.backgroundColor = Color.primaryColor
            self.nextButton.alpha = 1.0
        })
        nextButton.enabled = true
    }
    
    func animateIncorrectPersonNumber() {
        UIView.animateWithDuration(0.4, animations: {
            self.checkmark.alpha = 0.0
            self.nextButton.backgroundColor = Color.secondaryColor
            self.nextButton.alpha = 0.4
        })
        nextButton.enabled = false
    }
    
    func keyboardWillShow(sender: NSNotification) {
        let userInfo: [NSObject : AnyObject] = sender.userInfo!
        let keyboardSize: CGSize = userInfo[UIKeyboardFrameBeginUserInfoKey]!.CGRectValue.size
        let offset: CGSize = userInfo[UIKeyboardFrameEndUserInfoKey]!.CGRectValue.size
        
        if keyboardSize.height == offset.height {
            if nextButtonBottomConstraint.constant == 0 {
                nextButtonBottomConstraint.constant += keyboardSize.height
                personNumberTopConstraint.constant -= 120
                UIView.animateWithDuration(0.1, animations: { () -> Void in
                    self.view.layoutIfNeeded()
                })
            }
        } else {
            nextButtonBottomConstraint.constant -= keyboardSize.height + offset.height
            personNumberTopConstraint.constant -= 120
            UIView.animateWithDuration(0.1, animations: { () -> Void in
                self.view.layoutIfNeeded()
            })
        }
    }
    
    func keyboardWillHide(sender: NSNotification) {
        nextButtonBottomConstraint.constant = 0
        personNumberTopConstraint.constant = 8
        UIView.animateWithDuration(0.1, animations: { () -> Void in
            self.view.layoutIfNeeded()
            
        })
    }
    
    func isElevenDigits() -> Bool {
        if personNumberTextField.text?.characters.count == 11 {
            return true
        }
        return false
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        view.endEditing(true)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        UserDefaults.setObject(personNumberTextField.text!, forKey: UserDefaultKey.PersonNumber)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
