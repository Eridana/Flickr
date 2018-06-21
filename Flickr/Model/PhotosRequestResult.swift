//
//  PhotosRequestResult.swift
//  Flickr
//
//  Created by Evgeniia Mikhailova on 20.06.18.
//  Copyright © 2018 evgeniya.mikhailova. All rights reserved.
//

import UIKit

class PhotosRequestResult : Codable {
    var photosInfo: PhotosData?
    
    private enum CodingKeys: String, CodingKey {
        case photosInfo = "photos"
    }
}
