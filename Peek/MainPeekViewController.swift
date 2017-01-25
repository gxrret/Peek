//
//  MainPeekViewController.swift
//  Peek
//
//  Created by Garret Koontz on 1/23/17.
//  Copyright © 2017 GK. All rights reserved.
//

import UIKit

class MainPeekViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh(refreshControl:)), for: UIControlEvents.valueChanged)
        
        return refreshControl
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        requestFullSync()
        
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(postsChanged(_:)), name: PeekController.PeeksChangedNotification, object: nil)
        
        self.tableView.addSubview(self.refreshControl)
        
    }
    
    func postsChanged(_ notification: Notification) {
        tableView.reloadData()
    }
    
    func handleRefresh(refreshControl: UIRefreshControl) {
        requestFullSync {
            self.refreshControl.endRefreshing()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return PeekController.sharedController.peeks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "peekCell", for: indexPath) as? PeekTableViewCell
        
        let peek = PeekController.sharedController.peeks[indexPath.row]
        cell?.updateWithPeek(peek: peek)
        return cell ?? UITableViewCell()
        
    }
    
    func requestFullSync(_ completion: (() -> Void)? = nil) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        PeekController.sharedController.performFullSync {
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            completion?()
        }
    }

    // MARK: - Navigation

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toPeekDetail" {
            
            if let indexPath = tableView.indexPathForSelectedRow {
                let peek = PeekController.sharedController.peeks[indexPath.row]
                if let detailVC = segue.destination as? PeekDetailViewController {
                    detailVC.peek = peek
                }
            }
        }
    }
}
