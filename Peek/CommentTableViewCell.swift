//
//  CommentTableViewCell.swift
//  Peek
//
//  Created by Garret Koontz on 3/16/17.
//  Copyright © 2017 GK. All rights reserved.
//

import UIKit

class CommentTableViewCell: UITableViewCell {

    @IBOutlet weak var commentTextLabel: UILabel!
    @IBOutlet weak var commentTimestampLabel: UILabel!
    
    func updateComments(comment: Comment) {
        commentTextLabel.text = comment.text
        commentTimestampLabel.text = DateHelper.timeAgoSinceShortened(comment.timestamp)
    }
    var comment: Comment? {
        didSet {
            guard let comment = comment else { return }
            updateComments(comment: comment)
        }
    }
}
