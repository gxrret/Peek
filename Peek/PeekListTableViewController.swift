//
//  MainPeekViewController.swift
//  Peek
//
//  Created by Garret Koontz on 1/23/17.
//  Copyright © 2017 GK. All rights reserved.
//

import UIKit
import MessageUI
import MapKit
import CoreLocation

class PeekListTableViewController: UITableViewController, MFMailComposeViewControllerDelegate{
    
    var peek: Peek?
    
    let dimView = UIView()
    let dismissButton: UIButton = UIButton()
    
    @IBOutlet var menuView: UIView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        PeekController.sharedController.iCloudUserIDAsync { (recordID, error) in
            if let userID = recordID?.recordName {
                print(userID)
            }
        }
        
        refreshControl?.tintColor = UIColor(red: 30/255, green: 215/255, blue: 96/255, alpha: 1.0)
        refreshControl?.backgroundColor = tableView.backgroundColor
        
        requestFullSync()
        
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(postsChanged(_:)), name: PeekController.PeeksChangedNotification, object: nil)
        
        LocationManager.sharedInstance.locationManager.requestWhenInUseAuthorization()
        LocationManager.sharedInstance.requestCurrentLocation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        navigationController?.hidesBarsOnSwipe = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.menuView.removeFromSuperview()
        self.dimView.removeFromSuperview()
        self.dismissButton.removeFromSuperview()
        self.tableView.isScrollEnabled = true
    }
    
    @IBAction func indexChanged(_ sender: Any) {
        if segmentedControl.selectedSegmentIndex == 2 {
            segmentedControl.tintColor = .red
        } else {
            segmentedControl.tintColor = UIColor(red: 30/255, green: 215/255, blue: 96/255, alpha: 1.0)
        }
        tableView.reloadData()
    }
    
    @IBAction func refreshControlPulled(_ sender: UIRefreshControl) {
        
        requestFullSync {
            self.refreshControl?.endRefreshing()
        }
    }
    
    @IBAction func moreButtonTapped(_ sender: Any) {
        showActionSheet()
    }
    
    func showActionSheet() {
        let alert = UIAlertController(title: "Choose an Option", message: nil, preferredStyle: .actionSheet)
        let report = UIAlertAction(title: "Report", style: .destructive) { (_) in
            if MFMailComposeViewController.canSendMail() {
                
                let messageBody = "Specify the abuse or spam you saw from a user. Review the Terms & Conditions."
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
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(report)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
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
    
    @IBAction func composeButtonTapped(_ sender: Any) {
        composeButtonMenuAnimation()
    }
    
    @IBAction func exitButtonTapped(_ sender: Any) {
        exitComposeMenu()
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
        var returnString = ""
        switch (segmentedControl.selectedSegmentIndex) {
        case 0:
            returnString = "Newest😄"
        case 1:
            returnString = "Most Popular😎"
        case 2:
            returnString = "NSFW😶"
        default:
            break
        }
        return returnString
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = .clear
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = .black
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var returnValue = 0
        
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            returnValue = PeekController.sharedController.sortedPeeksByTime.count
        case 1:
            returnValue = PeekController.sharedController.sortedPeeksByNumberOfComments.count
        case 2:
            returnValue = PeekController.sharedController.sortedPeeksByNSFWContent.count
        default:
            break
        }
        return returnValue
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "peekCell", for: indexPath) as? PeekTableViewCell else { return UITableViewCell() }
        
        let bgColorView = UIView()
        bgColorView.backgroundColor = .white
        bgColorView.layer.cornerRadius = 4.0
        
        cell.selectedBackgroundView = bgColorView
        cell.backgroundColor = .clear
        cell.contentView.backgroundColor = .clear
        
        let whiteRoundedView: UIView = UIView(frame: CGRect(x: 10, y: 8, width: self.view.frame.size.width - 20, height: cell.frame.size.height - 10))
        whiteRoundedView.layer.backgroundColor = UIColor(red: 247/255, green: 247/255, blue: 247/255, alpha: 1.0).cgColor
        whiteRoundedView.layer.masksToBounds = false
        whiteRoundedView.layer.cornerRadius = 4.0
        cell.contentView.addSubview(whiteRoundedView)
        cell.contentView.sendSubview(toBack: whiteRoundedView)
        
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            let peek = PeekController.sharedController.sortedPeeksByTime[indexPath.row]
            cell.updateWithPeek(peek: peek)
        case 1:
            let peek = PeekController.sharedController.sortedPeeksByNumberOfComments[indexPath.row]
            cell.updateWithPeek(peek: peek)
        case 2:
            let peek = PeekController.sharedController.sortedPeeksByNSFWContent[indexPath.row]
            cell.updateWithPeek(peek: peek)
        default:
            break
        }
        
        return cell
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toComments" {
            if let indexPath = tableView.indexPathForSelectedRow,
                let commentsTVC = segue.destination as? CommentsTableViewController {
                switch segmentedControl.selectedSegmentIndex {
                case 0:
                    let peek = PeekController.sharedController.sortedPeeksByTime[indexPath.row]
                    commentsTVC.peek = peek
                case 1:
                    let peek = PeekController.sharedController.sortedPeeksByNumberOfComments[indexPath.row]
                    commentsTVC.peek = peek
                case 2:
                    let peek = PeekController.sharedController.sortedPeeksByNSFWContent[indexPath.row]
                    commentsTVC.peek = peek
                default:
                    break
                }
            }
        }
    }
}

extension PeekListTableViewController {
    
    func composeButtonMenuAnimation() {
        self.view.addSubview(menuView)
        menuView.layer.frame = CGRect(x: 0, y: -100, width: view.frame.size.width, height: menuView.frame.size.height)
        menuView.layer.cornerRadius = 1
        menuView.layer.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.95).cgColor
        
        dimView.frame = CGRect(x: view.frame.origin.x, y: view.frame.origin.y + 45, width: view.frame.size.width, height: view.frame.size.height)
        dimView.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.75)
        dimView.alpha = 0
        
        dismissButton.frame = CGRect(x: view.frame.origin.x, y: view.frame.origin.y, width: view.frame.size.width, height: view.frame.size.height - menuView.frame.size.height)
        dismissButton.addTarget(self, action: #selector(tapToExit(_:)), for: .touchUpInside)
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.75, initialSpringVelocity: 0.75, options: .curveEaseIn, animations: {
            self.menuView.frame.origin.y = 0
            self.view.addSubview(self.dimView)
            self.view.addSubview(self.dismissButton)
            self.dimView.alpha = 0.75
            self.view.bringSubview(toFront: self.menuView)
            self.tableView.isScrollEnabled = false
        }, completion: nil)
    }
    
    func exitComposeMenu() {
        UIView.animate(withDuration: 0.2, animations: {
            self.menuView.frame.origin.y = self.view.frame.origin.y - 100
            self.dimView.alpha = 0
        }) { (_) in
            self.menuView.removeFromSuperview()
            self.dimView.removeFromSuperview()
            self.dismissButton.removeFromSuperview()
            self.tableView.isScrollEnabled = true
        }
    }
    
    func tapToExit(_ sender: UIButton) {
        exitComposeMenu()
    }
}
