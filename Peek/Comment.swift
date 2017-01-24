//
//  Comment.swift
//  Peek
//
//  Created by Garret Koontz on 1/24/17.
//  Copyright © 2017 GK. All rights reserved.
//

import Foundation

class Comment {
    
    let text: String
    let peek: Peek?
    
    init(text: String, peek: Peek?) {
        self.text = text
        self.peek = peek
    }
    
}
