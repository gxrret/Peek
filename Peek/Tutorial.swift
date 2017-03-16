//
//  Tutorial.swift
//  Peek
//
//  Created by Garret Koontz on 3/6/17.
//  Copyright © 2017 GK. All rights reserved.
//

import UIKit

class Tutorial: UIViewController {
    
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var swipeLeftLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    var pageIndex: Int = 0
    
}

extension Tutorial {
    func setupView() {
        switch pageIndex {
        case 0:
            topLabel.text = "Welcome to"
            detailLabel.text = "Share your photos anonymously with the world."
            logoImageView.image = #imageLiteral(resourceName: "peek icon with text")
            swipeLeftLabel.isHidden = true
        case 1:
            topLabel.text = "Anonymity"
            logoImageView.isHidden = true
            detailLabel.text = "No account setup at all. Get right to peeking!"
            swipeLeftLabel.text = "👀"
        case 2:
            topLabel.text = "Post"
            logoImageView.image = #imageLiteral(resourceName: "photo icon")
            detailLabel.text = "To post a peek, tap the create button on the main page."
            swipeLeftLabel.isHidden = true
        case 3:
            topLabel.text = "Comment"
            logoImageView.image = #imageLiteral(resourceName: "Comment Icon")
            detailLabel.text = "Tap on a peek to see comments or to add one."
            swipeLeftLabel.isHidden = true
        case 4:
            topLabel.text = "NSFW Content"
            logoImageView.isHidden = true
            detailLabel.text = "Peek users may post content that is NSFW(not safe for work). We filter peeks by a section dedicated to NSFW content. To report content you find inappropriate, swipe left to send an email to us."
            swipeLeftLabel.text = "😶"
        case 5:
            topLabel.text = "Before You Start..."
            logoImageView.isHidden = true
            detailLabel.text = "In order to use Peek, please accept the Terms & Conditions."
            swipeLeftLabel.isHidden = false
        default: break
        }
    }
}

extension Tutorial: StoryboardInitializable {
    static var storyboardName: String { return String(describing: Onboarding.self) }
}
