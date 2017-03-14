//
//  Comment.swift
//  Peek
//
//  Created by Garret Koontz on 1/24/17.
//  Copyright © 2017 GK. All rights reserved.
//

import Foundation
import CloudKit

class Comment: CloudKitSyncable {
    
    let text: String
    let peek: Peek?
    let timestamp: Date
    
    init(text: String, peek: Peek?, timestamp: Date = Date()) {
        self.text = text
        self.peek = peek
        self.timestamp = timestamp
    }
    
    var cloudKitRecordID: CKRecordID?
    var recordType: String {
        return CommentKeys.recordType.rawValue
    }
    // Creates a record from a Comment Object
    convenience required init?(record: CKRecord) {
        guard let timestamp = record.creationDate,
            let text = record[CommentKeys.text.rawValue] as? String else { return nil }
        self.init(text: text, peek: nil, timestamp: timestamp)
        cloudKitRecordID = record.recordID
    }
}

extension CKRecord {
    
    convenience init(_ comment: Comment) {
        guard let peek = comment.peek else {
            fatalError("Comment has no Peek relationship")
        }
        
        let peekRecordID = peek.cloudKitRecordID ?? CKRecord(peek).recordID
        let recordID = CKRecordID(recordName: UUID().uuidString)
        
        self.init(recordType: comment.recordType, recordID: recordID)
        
        self[CommentKeys.timestamp.rawValue] = comment.timestamp as CKRecordValue?
        self[CommentKeys.text.rawValue] = comment.text as CKRecordValue?
        self[CommentKeys.peekReference.rawValue] = CKReference(recordID: peekRecordID, action: .deleteSelf)
        
    }
}
