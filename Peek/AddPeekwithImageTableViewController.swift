//
//  AddPeekTableViewController.swift
//  Peek
//
//  Created by Garret Koontz on 1/23/17.
//  Copyright © 2017 GK. All rights reserved.
//

import UIKit

class AddPeekwithImageTableViewController: UITableViewController, UITextFieldDelegate {
    
    @IBOutlet weak var titleTextField: UITextField!
    
    @IBOutlet weak var peekTextView: UITextView!
    
    var image: UIImage?
    
    let currentLocation = LocationManager.sharedInstance.currentLocation
    
    @IBAction func addButtonTapped(_ sender: Any) {
        
//        if let title = titleTextField.text,
//            let text = peekTextView.text,
//            let image = image,
//            let currentLocation = currentLocation {
//            
//            PeekController.sharedController.createPeekWithImage(title: title, caption: text, image: image, location: currentLocation, completion: nil)
//            dismiss(animated: true, completion: nil)
//            
//        } else {
//            presentErrorAlert()
//        }
        
    }
    
    func presentErrorAlert() {
        let alertController = UIAlertController(title: "Missing information", message: "You need a title.", preferredStyle: .alert)
        
        let tryAgainAction = UIAlertAction(title: "Try Again", style: .cancel, handler: nil)
        alertController.addAction(tryAgainAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.titleTextField {
            self.titleTextField.resignFirstResponder()
        }
        return true
    }
    
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "embedPhotoSelect" {
            let embedVC = segue.destination as? PhotoSelectViewController
            embedVC?.delegate = self
        }
    }
    
}

extension AddPeekwithImageTableViewController: PhotoSelectViewControllerDelegate {
    func photoSelectViewControllerSelected(image: UIImage) {
        self.image = image
    }
}
