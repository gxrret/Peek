//
//  Peek.swift
//  Peek
//
//  Created by Garret Koontz on 1/24/17.
//  Copyright © 2017 GK. All rights reserved.
//

import UIKit
import CloudKit
import CoreLocation
import MapKit

class Peek: CloudKitSyncable {
    
    static let kType = "Peek"
    static let kPhotoData = "photoData"
    static let kTimeStamp = "timestamp"
    static let kTitle = "title"
    static let kText = "text"
    static let kLocation = "location"
    
    let title: String
    let text: String
    let photoData: Data?
    let timestamp: Date
    var location: CLLocation
    var comments: [Comment]
    var photo: UIImage? {
        
        guard let photoData = self.photoData else { return nil }
        return UIImage(data: photoData)
    }
    
    init(title: String, timestamp: Date = Date(), text: String, photoData: Data?, comments: [Comment] = [], location: CLLocation) {
        self.title = title
        self.timestamp = timestamp
        self.text = text
        self.photoData = photoData
        self.comments = comments
        self.location = location
    }
    
    var recordType: String {
        return Peek.kType
    }
    
    var cloudKitRecordID: CKRecordID?
    
    convenience required init?(record: CKRecord) {
        
        guard let timestamp = record.creationDate,
            let photoAsset = record[Peek.kPhotoData] as? CKAsset,
            let title = record[Peek.kTitle] as? String,
            let text = record[Peek.kText] as? String,
        let location = record[Peek.kLocation] as? CLLocation else { return nil }
        let photoData = try? Data(contentsOf: photoAsset.fileURL)
        self.init(title: title, timestamp: timestamp, text: text, photoData: photoData, location: location)
        cloudKitRecordID = record.recordID
    }
    
    fileprivate var temporaryPhotoURL: URL {
        let temporaryDirectory = NSTemporaryDirectory()
        let temporaryDirectoryURL = URL(fileURLWithPath: temporaryDirectory)
        let fileURL = temporaryDirectoryURL.appendingPathComponent(UUID().uuidString).appendingPathExtension("jpg")
        
        try? photoData?.write(to: fileURL, options: .atomic)
        
        return fileURL
    }
    
}

extension CKRecord {
    
    convenience init(_ peek: Peek) {
        let recordID = CKRecordID(recordName: UUID().uuidString)
        self.init(recordType: peek.recordType, recordID: recordID)
        
        self[Peek.kTitle] = peek.title as String? as CKRecordValue?
        self[Peek.kText] = peek.text as String? as CKRecordValue?
        self[Peek.kTimeStamp] = peek.timestamp as CKRecordValue?
        self[Peek.kLocation] = peek.location as CKRecordValue?
        self[Peek.kPhotoData] = CKAsset(fileURL: peek.temporaryPhotoURL)
    }
}
