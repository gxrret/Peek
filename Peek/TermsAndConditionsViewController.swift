//
//  TermsAndConditionsViewController.swift
//  Peek
//
//  Created by Garret Koontz on 1/22/17.
//  Copyright © 2017 GK. All rights reserved.
//

import UIKit

class TermsAndConditionsViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var termsTextView: UITextView! {
        didSet {
            termsTextView.delegate = self
        }
    }
    
    @IBOutlet weak var acceptButton: UIButton! {
        didSet {
            acceptButton.isHidden = true
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        acceptButton.isHidden = scrollView.contentOffset.y + scrollView.bounds.height < scrollView.contentSize.height
    }
    
    @IBAction func acceptButtonTapped(_ sender: Any) {
        UserDefaults.standard.set(true, forKey: "termsAccepted")
        
        performSegue(withIdentifier: "toPeekView", sender: sender)
    }
}
