//
//  PeekTableViewCell.swift
//  Peek
//
//  Created by Garret Koontz on 1/24/17.
//  Copyright © 2017 GK. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class PeekTableViewCell: UITableViewCell {
    
    @IBOutlet weak var peekTitleLabel: UILabel!
    @IBOutlet weak var peekTimeLabel: UILabel!
    @IBOutlet weak var peekImageView: UIImageView!
    @IBOutlet weak var peekTextView: UITextView!
    @IBOutlet weak var commentsLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    func updateWithPeek(peek: Peek) {
        peekTitleLabel.text = peek.title
        peekTextView.text = peek.text
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.doesRelativeDateFormatting = true
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "h:mm a"
        
        let time = "\(dateFormatter.string(from: peek.timestamp)), \(timeFormatter.string(from: peek.timestamp))"
        peekTimeLabel.text = "\(time)"
        
        peekImageView.image = peek.photo
        
        if peek.comments.count == 0 {
            commentsLabel.text = "0 comments 😢"
        } else if peek.comments.count == 1 {
            commentsLabel.text = "1 comment"
        } else {
            commentsLabel.text = "\(peek.comments.count) Comments"
        }
        let geoCoder = CLGeocoder()
        
        geoCoder.reverseGeocodeLocation(peek.location) { (placemarks, error) in
            guard let placemarks = placemarks else { return }
            if placemarks.count > 0 {
                guard let placemark = placemarks.first  else { return }
                self.locationLabel.text = "\(placemark.locality!), \(placemark.administrativeArea!)"
                
            }
        }
    }
    
    var peek: Peek? {
        didSet {
            guard let peek = peek else { return }
            updateWithPeek(peek: peek)
        }
    }
}
