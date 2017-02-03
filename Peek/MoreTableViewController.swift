//
//  MoreTableViewController.swift
//  Peek
//
//  Created by Garret Koontz on 1/23/17.
//  Copyright © 2017 GK. All rights reserved.
//

import UIKit
import MessageUI

class MoreTableViewController: UITableViewController, MFMailComposeViewControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func reportButtonTapped(_ sender: Any) {
        
        if MFMailComposeViewController.canSendMail() {
            
        let messageBody = "Specify the problem or abuse you saw from a user."
        let toRecipients = ["peekapp.contact@gmail.com"]
        let mc = MFMailComposeViewController()
        mc.mailComposeDelegate = self
        mc.setMessageBody(messageBody, isHTML: false)
        mc.setToRecipients(toRecipients)
        
        self.present(mc, animated: true, completion: nil)
        
        } else {
            self.presentErrorAlert()
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        dismiss(animated: true, completion: nil)
    }
    
    func presentErrorAlert() {
        let errorAlert = UIAlertController(title: "Error Sending Email", message: "Check email configuration then try again.", preferredStyle: .alert)
        
        let dismissAction = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
        errorAlert.addAction(dismissAction)
        
        present(errorAlert, animated: true, completion: nil)
    }
    
    @IBAction func doneButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
}



