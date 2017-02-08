//
//  CommentsTableViewController.swift
//  Peek
//
//  Created by Garret Koontz on 1/23/17.
//  Copyright © 2017 GK. All rights reserved.
//

import UIKit
import MessageUI

class CommentsTableViewController: UITableViewController, MFMailComposeViewControllerDelegate, UITextFieldDelegate {
    
    var peek: Peek?
    
    @IBOutlet weak var commentTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        commentTextField.delegate = self
        
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(postCommentsChanged(notification:)), name: PeekController.PeekCommentsChangedNotification, object: nil)
        
        navigationController?.isNavigationBarHidden = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        navigationController?.hidesBarsOnSwipe = false
    }
    
    func postCommentsChanged(notification: Notification) {
        guard let notificationPost = notification.object as? Peek,
            let peek = peek, notificationPost === peek else { return }
        tableView.reloadData()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        commentTextField = textField
        textField.resignFirstResponder()
        return true
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return peek?.comments.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath)
        
        guard let comment = peek?.comments[indexPath.row] else { return cell }
        
        cell.textLabel?.text = comment.text
        
        cell.detailTextLabel?.text = DateHelper.timeAgoSinceComments(comment.timestamp)
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let report = UITableViewRowAction(style: .destructive, title: "Report") { (action, indexPath) in
            if MFMailComposeViewController.canSendMail() {
                let messageBody = "Specify the abuse you saw from a user."
                let toRecipients = ["peekapp.contact@gmail.com"]
                let mc = MFMailComposeViewController()
                mc.mailComposeDelegate = self
                mc.setMessageBody(messageBody, isHTML: false)
                mc.setToRecipients(toRecipients)
                
                self.present(mc, animated: true, completion: nil)
                
            } else {
                self.presentMailErrorAlert()
            }
        }
        return [report]
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        dismiss(animated: true, completion: nil)
    }
    
    func presentMailErrorAlert() {
        let errorAlert = UIAlertController(title: "Error Sending Email", message: "Check email configuration then try again.", preferredStyle: .alert)
        
        let dismissAction = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
        errorAlert.addAction(dismissAction)
        
        present(errorAlert, animated: true, completion: nil)
    }
    
    
    @IBAction func postCommentButtonTapped(_ sender: Any) {
        guard let commentText = commentTextField.text, !commentText.isEmpty,
            let peek = self.peek else {
                presentErrorAlert()
                return
        }
        let _ = PeekController.sharedController.addComment(peek: peek, commentText: commentText)
        commentTextField.text = ""
        self.tableView.reloadData()
    }
    
    func presentErrorAlert() {
        let alertController = UIAlertController(title: "Missing information", message: "You need to add some text.", preferredStyle: .alert)
        
        let tryAgainAction = UIAlertAction(title: "Try Again", style: .cancel, handler: nil)
        alertController.addAction(tryAgainAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
}
