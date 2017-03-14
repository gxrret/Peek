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
    
    let title: String
    let photoData: Data?
    let timestamp: Date
    var location: CLLocation
    var comments: [Comment]
    var photo: UIImage? {
        
        guard let photoData = self.photoData else { return nil }
        return UIImage(data: photoData)
    }
    
    init(title: String, timestamp: Date = Date(), photoData: Data?, comments: [Comment] = [], location: CLLocation) {
        self.title = title
        self.timestamp = timestamp
        self.photoData = photoData
        self.comments = comments
        self.location = location
    }
    
    var recordType: String {
        return PeekKeys.recordType.rawValue
    }
    
    var cloudKitRecordID: CKRecordID?
    
    convenience required init?(record: CKRecord) {
        
        guard let timestamp = record.creationDate,
            let photoAsset = record[PeekKeys.photoData.rawValue] as? CKAsset,
            let title = record[PeekKeys.title.rawValue] as? String,
        let location = record[PeekKeys.location.rawValue] as? CLLocation else { return nil }
        let photoData = try? Data(contentsOf: photoAsset.fileURL)
        self.init(title: title, timestamp: timestamp, photoData: photoData, location: location)
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
        
        self[PeekKeys.title.rawValue] = peek.title as String? as CKRecordValue?
        self[PeekKeys.timestamp.rawValue] = peek.timestamp as CKRecordValue?
        self[PeekKeys.location.rawValue] = peek.location as CKRecordValue?
        self[PeekKeys.photoData.rawValue] = CKAsset(fileURL: peek.temporaryPhotoURL)
    }
}
