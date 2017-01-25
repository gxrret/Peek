//
//  PeekDetailTableViewController.swift
//  Peek
//
//  Created by Garret Koontz on 1/23/17.
//  Copyright © 2017 GK. All rights reserved.
//

import UIKit

class PeekDetailViewController: UIViewController {
    
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