//
//  PeekTableViewCell.swift
//  Peek
//
//  Created by Garret Koontz on 1/24/17.
//  Copyright © 2017 GK. All rights reserved.
//

import UIKit

class PeekTableViewCell: UITableViewCell {

    @IBOutlet weak var peekTitleLabel: UILabel!
    @IBOutlet weak var peekTimeLabel: UILabel!
    @IBOutlet weak var peekImageView: UIImageView!
    @IBOutlet weak var commentsButton: UIButton!
    
    func updateWithPeek(peek: Peek) {
        peekTitleLabel.text = peek.title
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.doesRelativeDateFormatting = true
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "h:mm a"
        
        let time = "\(dateFormatter.string(from: peek.timestamp)), \(timeFormatter.string(from: peek.timestamp))"
        peekTimeLabel.text = "\(time)"
        
        peekImageView.image = peek.photo
        peekImageView.layer.cornerRadius = 1.0
        
        commentsButton.setTitle("\(peek.comments.count) Comments", for: .normal)
    }
    
    var peek: Peek? {
        didSet {
            guard let peek = peek else { return }
            updateWithPeek(peek: peek)
        }
    }

}
