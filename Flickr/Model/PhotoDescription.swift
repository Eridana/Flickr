//
//  PhotoDescription.swift
//  Flickr
//
//  Created by Evgeniia Mikhailova on 20.06.18.
//  Copyright © 2018 evgeniya.mikhailova. All rights reserved.
//

import UIKit

class PhotoDescription: Codable {
    var id: String?
    var dateUploadedInterval: String?
    var title: PhotoContentText?
    var description: PhotoContentText?
    var dates: PhotoDateInfo?
    var owner: PhotoOwner?
    
    var dateUploaded: Date {
        get {
            return Date(timeIntervalSince1970: NSDecimalNumber(string: self.dateUploadedInterval ?? "0").doubleValue)
        }
    }
    
    private enum CodingKeys: String, CodingKey {
        case id        
        case title
        case dateUploadedInterval = "dateuploaded"
        case description
        case dates
        case owner
    }
}

class PhotoDateInfo: Codable {
    var posted: String?
    var taken: String?
    var lastUpdate: String?
    
    private enum CodingKeys: String, CodingKey {
        case posted
        case taken
        case lastUpdate = "lastupdate"
    }
}

class PhotoOwner: Codable {
    var id: String?
    var username: String?
    var realname: String?
    
    private enum CodingKeys: String, CodingKey {
        case id = "nsid"
        case username
        case realname
    }
}

class PhotoContentText: Codable {
    var info: String?
    private enum CodingKeys: String, CodingKey {
        case info = "_content"
    }
}
