//
//  Photo.swift
//  Flickr
//
//  Created by Evgeniia Mikhailova on 19.06.18.
//  Copyright © 2018 evgeniya.mikhailova. All rights reserved.
//

import UIKit

class Photo: Codable {
    var id: String?
    var ownerId: String?
    var title: String?
    var smallUrlString: String?
    var mediumUrlString: String?
    var largeUrlString: String?
    var dateUploadedString: String?
    var fullInfo: PhotoDescription?
    
    var urlSmall: URL? {
        get {
            return URL(string: self.smallUrlString ?? "")
        }
    }
    
    var urlMedium: URL? {
        get {
            return URL(string: self.mediumUrlString ?? "")
        }
    }
    
    var urlLarge: URL? {
        get {
            return URL(string: self.largeUrlString ?? "")
        }
    }
    
    var dateUploaded: Date {
        get {
            return Date(timeIntervalSince1970: NSDecimalNumber(string: self.dateUploadedString ?? "0").doubleValue)
        }
    }
    
    private enum CodingKeys: String, CodingKey {
        case id
        case ownerId = "owner"
        case title = "title"
        case smallUrlString = "url_s"
        case mediumUrlString = "url_m"
        case largeUrlString = "url_l"
        case dateUploadedString = "dateupload"
        case fullInfo = "photo"
    }
}
