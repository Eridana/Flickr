//
//  PhotosData.swift
//  Flickr
//
//  Created by Evgeniia Mikhailova on 20.06.18.
//  Copyright © 2018 evgeniya.mikhailova. All rights reserved.
//

import UIKit

class PhotosData: Codable {
    var page: Int?
    var pages: Int?
    var perPage: Int?
    var photos: [Photo]?
    
    private enum CodingKeys: String, CodingKey {
        case page
        case pages = "pages"
        case perPage = "perpage"
        case photos = "photo"
    }
}
