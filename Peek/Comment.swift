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
    
    static let kType = "Comment"
    static let kText = "text"
    static let kPeek = "peek"
    static let kTimestamp = "timestamp"
    
    var text: String
    var peek: Peek?
    var timestamp: Date
    
    init(text: String, peek: Peek?, timestamp: Date = Date()) {
        self.text = text
        self.peek = peek
        self.timestamp = timestamp
    }
    
    var cloudKitRecordID: CKRecordID?
    var recordType: String {
        return Comment.kType
    }
    
    convenience required init?(record: CKRecord) {
        guard let timestamp = record.creationDate,
        let text = record[Comment.kText] as? String else { return nil }
        self.init(text: text, peek: nil, timestamp: timestamp)
        cloudKitRecordID = record.recordID
    }
}

extension CKRecord {
    
    convenience init(_ comment: Comment) {
        guard let peek = comment.peek else {
            fatalError("Comment does not have a Peek relationship")
        }
        
        let peekRecordID = peek.cloudKitRecordID ?? CKRecord(peek).recordID
        let recordID = CKRecordID(recordName: UUID().uuidString)
        
        self.init(recordType: comment.recordType, recordID: recordID)
        
        self[Comment.kTimestamp] = comment.timestamp as CKRecordValue?
        self[Comment.kText] = comment.text as CKRecordValue?
        self[Comment.kPeek] = CKReference(recordID: peekRecordID, action: .deleteSelf)
        
    }
}
