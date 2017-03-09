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
    @IBOutlet weak var commentsLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var nsfwLabel: UILabel!
    
    func updateWithPeek(peek: Peek) {
        peekTitleLabel.text = peek.title
        peekTimeLabel.adjustsFontSizeToFitWidth = true
        peekTimeLabel.minimumScaleFactor = 0.2
        
        peekTimeLabel.text = DateHelper.timeAgoSincePeek(peek.timestamp)
        
        peekImageView.image = peek.photo
        peekImageView.layer.cornerRadius = 3.0
        
        if peek.title.contains("#NSFW") {
            nsfwLabel.isHidden = false
        } else {
            nsfwLabel.isHidden = true
        }
        
        if peek.comments.count == 0 {
            commentsLabel.text = "0"
        } else if peek.comments.count == 1 {
            commentsLabel.text = "1"
        } else {
            commentsLabel.text = "\(peek.comments.count)"
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
