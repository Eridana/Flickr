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
    var fullInfo: PhotoDescription?
    
    private enum CodingKeys: String, CodingKey {
        case id
        case ownerId = "owner"
        case title = "title"
        case fullInfo = "photo"
    }
}
