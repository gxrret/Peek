//
//  Peek.swift
//  Peek
//
//  Created by Garret Koontz on 1/24/17.
//  Copyright © 2017 GK. All rights reserved.
//

import UIKit
import CloudKit

class Peek {
    
    let title: String
    let text: String
    let photoData: Data?
    let timestamp: Date
    var comments: [Comment]
    
    var photo: UIImage? {
        guard let photoData = self.photoData else { return nil }
        return UIImage(data: photoData)
    }
    
    init(title: String, timestamp: Date = Date(), text: String, photoData: Data?, comments: [Comment] = []) {
        self.title = title
        self.timestamp = timestamp
        self.text = text
        self.photoData = photoData
        self.comments = comments
    }
    
    fileprivate var temporaryPhotoURL: URL {
        let temporaryDirectory = NSTemporaryDirectory()
        let temporaryDirectoryURL = URL(fileURLWithPath: temporaryDirectory)
        let fileURL = temporaryDirectoryURL.appendingPathComponent(UUID().uuidString).appendingPathExtension("jpg")
        
        try? photoData?.write(to: fileURL, options: .atomic)
        
        return fileURL
    }
}
