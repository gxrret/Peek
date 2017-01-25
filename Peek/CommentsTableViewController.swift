//
//  CommentsTableViewController.swift
//  Peek
//
//  Created by Garret Koontz on 1/23/17.
//  Copyright © 2017 GK. All rights reserved.
//

import UIKit

class CommentsTableViewController: UITableViewController {
    
    var comment: Comment?
    
    var peek: Peek?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        PeekController.sharedController.performFullSync()
        
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(postCommentsChanged(notification:)), name: PeekController.PeekCommentsChangedNotification, object: nil)
        
    }
    
    func postCommentsChanged(notification: Notification) {
        guard let notificationPost = notification.object as? Peek,
            let peek = peek, notificationPost === peek else { return }
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return PeekController.sharedController.comments.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath) as? CommentTableViewCell
        
        let comment = PeekController.sharedController.comments[indexPath.row]
        cell?.updateWithComment(comment: comment)
        
        return cell ?? UITableViewCell()
    }
    
    @IBAction func addCommentButtonTapped(_ sender: Any) {
        presentAlert()
    }
    
    
    func presentAlert() {
        
        var commentTextField: UITextField?
        
        let alertController = UIAlertController(title: "Add Comment", message: "Wanna add a comment?", preferredStyle: .alert)
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Enter comment here"
            textField.keyboardAppearance = .dark
            commentTextField = textField
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        let postAction = UIAlertAction(title: "Post", style: .default) { (_) in
            guard let comment = commentTextField?.text, !comment.isEmpty,
                let peek = self.peek else { return }
            
            let _ = PeekController.sharedController.addComment(peek: peek, commentText: comment)
            self.tableView.reloadData()
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(postAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    
}
