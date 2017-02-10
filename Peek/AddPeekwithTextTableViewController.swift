//
//  AddPeekwithTextTableViewController.swift
//  Peek
//
//  Created by Garret Koontz on 1/31/17.
//  Copyright © 2017 GK. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class AddPeekwithTextTableViewController: UITableViewController {
    
    var peek: Peek?
    
    @IBOutlet weak var titleTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func postButtonTapped(_ sender: Any) {
        if let title = titleTextField.text,
            let peek = peek {
            
            PeekController.sharedController.createPeekWithText(title: title, location: peek.location, completion: nil)
        }
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
}

