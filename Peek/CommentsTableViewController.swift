//
//  CommentsTableViewController.swift
//  Peek
//
//  Created by Garret Koontz on 1/23/17.
//  Copyright © 2017 GK. All rights reserved.
//

import UIKit

class CommentsTableViewController: UITableViewController {
    
    var peek: Peek?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(postCommentsChanged(notification:)), name: PeekController.PeekCommentsChangedNotification, object: nil)
        
        navigationController?.isNavigationBarHidden = false
    }

    func postCommentsChanged(notification: Notification) {
        guard let notificationPost = notification.object as? Peek,
            let peek = peek, notificationPost === peek else { return }
        tableView.reloadData()
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
    
    @IBAction func addCommentButtonTapped(_ sender: Any) {
        presentAlert()
    }
    
    func presentAlert() {
        
        var commentTextField: UITextField?
        
        let alertController = UIAlertController(title: "Add Comment", message: "Wanna add a comment?", preferredStyle: .alert)
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Enter comment here"
            
            commentTextField = textField
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        
        let postAction = UIAlertAction(title: "Post", style: .default) { (_) in
            guard let comment = commentTextField?.text,
                let peek = self.peek else {
                    return }
            
            let _ = PeekController.sharedController.addComment(peek: peek, commentText: comment)
            self.tableView.reloadData()
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(postAction)
        alertController.view.tintColor = UIColor(red: 30/255, green: 216/255, blue: 96/255, alpha: 1.0)
        
        present(alertController, animated: true, completion: nil)
    }
}
