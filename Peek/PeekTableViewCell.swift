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
    @IBOutlet weak var timeLabel: UILabel!
    
    func updateWithPeek(peek: Peek) {
        peekTitleLabel.text = peek.title
    }
    
    var peek: Peek? {
        didSet {
            guard let peek = peek else { return }
            updateWithPeek(peek: peek)
        }
    }

}
