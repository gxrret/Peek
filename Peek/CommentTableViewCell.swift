//
//  CommentTableViewCell.swift
//  Peek
//
//  Created by Garret Koontz on 1/24/17.
//  Copyright © 2017 GK. All rights reserved.
//

import UIKit

class CommentTableViewCell: UITableViewCell {

    @IBOutlet weak var commentTextLabel: UILabel!
    
    func updateWithComment(comment: Comment) {
        commentTextLabel.text = comment.text
    }
    
    var comment: Comment? {
        didSet {
            guard let comment = comment else { return }
            updateWithComment(comment: comment)
        }
    }

}
