//
//  MailViewController.swift
//  Peek
//
//  Created by Garret Koontz on 1/25/17.
//  Copyright © 2017 GK. All rights reserved.
//

import UIKit
import MessageUI

class MailViewController: UIViewController, MFMailComposeViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        sendEmail()
    }
    
    func sendEmail () {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["peekhelp.contact@gmail.com"])
            mail.setMessageBody("Specify the problem or abuse from a user.", isHTML: false)
            
            present(mail, animated: true, completion: nil)
        } else {
            showSendMailErrorAlert()
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertController(title: "Could Not Send Email", message: "Please check e-mail configuration and try again.", preferredStyle: .alert)
        
        let dismissAction = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
        sendMailErrorAlert.addAction(dismissAction)
        
        present(sendMailErrorAlert, animated: true, completion: nil)
        
    }



}
