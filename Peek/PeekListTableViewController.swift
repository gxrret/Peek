//
//  MainPeekViewController.swift
//  Peek
//
//  Created by Garret Koontz on 1/23/17.
//  Copyright © 2017 GK. All rights reserved.
//

import UIKit
import MessageUI

class PeekListTableViewController: UITableViewController, MFMailComposeViewControllerDelegate {
    
    var peek: Peek?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        requestFullSync()
        
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(postsChanged(_:)), name: PeekController.PeeksChangedNotification, object: nil)
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        imageView.contentMode = .scaleAspectFit
        let image = #imageLiteral(resourceName: "tabBarLogo")
        imageView.image = image
        navigationItem.titleView = imageView
        
    }
    
    @IBAction func refreshControlPulled(_ sender: UIRefreshControl) {
        
        refreshControl?.tintColor = UIColor(red: 30/255, green: 215/255, blue: 96/255, alpha: 1.0)
        requestFullSync {
            self.refreshControl?.endRefreshing()
        }
    }
    
    @IBAction func reportButtonTapped(_ sender: Any) {
        
        let alertController = UIAlertController(title: "Select an Option", message: nil, preferredStyle: .actionSheet)
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        let reportButton = UIAlertAction(title: "Report", style: .destructive) { (_) in
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
        
        alertController.addAction(cancelButton)
        alertController.addAction(reportButton)
        
        self.present(alertController, animated: true, completion: nil)
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
    
    
    func postsChanged(_ notification: Notification) {
        tableView.reloadData()
    }
    
    func requestFullSync(_ completion: (() -> Void)? = nil) {
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        PeekController.sharedController.performFullSync {
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            completion?()
        }
    }
    
    //MARK: - TableViewDataSource and Delegate Functions
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Newest Peeks"
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return PeekController.sharedController.peeks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "peekCell", for: indexPath) as? PeekTableViewCell
        
        let peek = PeekController.sharedController.peeks[indexPath.row]
        cell?.updateWithPeek(peek: peek)
        return cell ?? UITableViewCell()
        
    }
    
    // MARK: - Navigation
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toComments" {
            if let commentTVC = segue.destination.childViewControllers.first as? CommentsTableViewController {
                commentTVC.peek = peek
            }
        }
    }
}
