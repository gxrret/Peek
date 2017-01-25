//
//  PeekDetailTableViewController.swift
//  Peek
//
//  Created by Garret Koontz on 1/23/17.
//  Copyright © 2017 GK. All rights reserved.
//

import UIKit
import MessageUI

class PeekDetailViewController: UIViewController, MFMailComposeViewControllerDelegate {
    
    var peek: Peek? {
        didSet {
            updateViews()
        }
    }
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var peekTextView: UITextView!
    
    @IBOutlet weak var peekImageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateViews()
    }
    
    func updateViews() {
        guard let peek = peek, isViewLoaded else { return }
        
        titleLabel.text = peek.title
        peekTextView.text = peek.text
        peekImageView.image = peek.photo
        
    }
    
    
    
    @IBAction func commentButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: "toComments", sender: sender)
    }
    
    
    @IBAction func reportButtonTapped(_ sender: Any) {
        
        if MFMailComposeViewController.canSendMail() {
            
            let messageBody = "Specify the abuse you saw from a user."
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
    
    
    
    func presentActivityViewController() {
        
        guard let title = peek?.title,
            let text = peek?.text,
            let photo = peek?.photo else { return }
        
        let activityViewController = UIActivityViewController(activityItems: [title, text, photo], applicationActivities: nil)
        present(activityViewController, animated: true, completion: nil)
        
    }
    
    @IBAction func shareButtonTapped(_ sender: Any) {
        
        presentActivityViewController()
    }
}
