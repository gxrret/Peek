//
//  CommentsTableViewController.swift
//  Peek
//
//  Created by Garret Koontz on 1/23/17.
//  Copyright © 2017 GK. All rights reserved.
//

import UIKit
import MessageUI
import CoreLocation
import MapKit

class CommentsTableViewController: UITableViewController, MFMailComposeViewControllerDelegate, UITextFieldDelegate {
    
    var peek: Peek?
    
    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var peekImageView: UIImageView!
    @IBOutlet weak var pinchToZoomScrollView: UIScrollView!
    @IBOutlet weak var peekTitleLabel: UILabel!
    @IBOutlet weak var peekTimestampLabel: UILabel!
    @IBOutlet weak var peekLocationLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        commentTextField.delegate = self
        updateView()
        
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(postCommentsChanged(notification:)), name: PeekController.PeekCommentsChangedNotification, object: nil)
        
        navigationController?.isNavigationBarHidden = false
        
        self.pinchToZoomScrollView.minimumZoomScale = 1.0
        self.pinchToZoomScrollView.maximumZoomScale = 5.0
        self.pinchToZoomScrollView.contentSize = self.peekImageView.frame.size
        self.pinchToZoomScrollView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        animateTable()
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
    
    func updateView() {
        guard let peek = peek , isViewLoaded else { return }
        peekImageView.image = peek.photo
        peekTitleLabel.text = peek.title
        
        let geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(peek.location) { (placemarks, error) in
            guard let placemarks = placemarks else { return }
            if placemarks.count > 0 {
                guard let placemark = placemarks.first  else { return }
                self.peekLocationLabel.text = "\(placemark.locality!), \(placemark.administrativeArea!)"
            }
        }
        peekTimestampLabel.text = DateHelper.timeAgoSinceShortened(peek.timestamp)
        tableView.reloadData()
    }
    
    override func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.peekImageView
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        commentTextField = textField
        textField.resignFirstResponder()
        return true
    }
    
    func animateTable() {
        tableView.reloadData()
        let cells = tableView.visibleCells
        
        let tableViewHeight = tableView.bounds.size.height
        
        for cell in cells {
            cell.transform = CGAffineTransform(translationX: 0, y: tableViewHeight)
        }
        
        var delayCounter = 0
        
        for cell in cells {
            UIView.animate(withDuration: 1, delay: Double(delayCounter) * 0.03, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                cell.transform = CGAffineTransform.identity
            }, completion: nil)
            delayCounter += 1
        }
        
    }
    
    //MARK: - TableViewDataSource and Delegate Functions
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return peek?.comments.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath)
        
        cell.backgroundColor = .clear
        cell.contentView.backgroundColor = .clear
        
        let whiteRoundedView: UIView = UIView(frame: CGRect(x: 10, y: 8, width: self.view.frame.size.width - 20, height: cell.frame.size.height - 10))
        whiteRoundedView.layer.backgroundColor = CGColor(colorSpace: CGColorSpaceCreateDeviceRGB(), components: [1.0, 1.0, 1.0, 0.9])
        whiteRoundedView.layer.masksToBounds = false
        whiteRoundedView.layer.cornerRadius = 4.0
        cell.contentView.addSubview(whiteRoundedView)
        cell.contentView.sendSubview(toBack: whiteRoundedView)
        
        guard let comment = peek?.comments[indexPath.row] else { return cell }
        
        cell.textLabel?.text = comment.text
        
        cell.detailTextLabel?.text = DateHelper.timeAgoSinceShortened(comment.timestamp)
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let report = UITableViewRowAction(style: .destructive, title: "Report") { (action, indexPath) in
            if MFMailComposeViewController.canSendMail() {
                let messageBody = "Specify the abuse or spam you saw from a user. Review the Terms & Conditions."
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
