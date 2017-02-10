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
    @IBOutlet weak var characterCounter: UILabel!
    var image: UIImage?
    
    let currentLocation = LocationManager.sharedInstance.currentLocation
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.characterCounter.text = "50"
        self.titleTextField.delegate = self
    }
    
    @IBAction func addButtonTapped(_ sender: Any) {
        
        if let title = titleTextField.text,
            let image = image,
            let currentLocation = currentLocation {
            
            PeekController.sharedController.createPeekWithImage(title: title, image: image, location: currentLocation, completion: nil)
            dismiss(animated: true, completion: nil)
            
        } else {
            presentErrorAlert()
        }
        
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
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newLength = (titleTextField.text?.characters.count)! + string.characters.count - range.length
        if newLength <= 50 {
            self.characterCounter.text = "\(50 - newLength)"
            return true
        } else {
            return false
        }
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
