//
//  PhotoMetadataRequest.swift
//  Flickr
//
//  Created by Evgeniia Mikhailova on 20.06.18.
//  Copyright © 2018 evgeniya.mikhailova. All rights reserved.
//

import UIKit

class PhotoMetadataRequest: NSObject {
    
    private static let url = "flickr.photos.getInfo"
    
    static func metadata(for photo: Photo, completion: @escaping ((Photo?) -> Void)) {
        
        guard let id = photo.id else {
            completion(nil)
            return
        }
        
        let params:[String: Any]? = ["photo_id" : id]
        
        ApiManager.sharedInstance.get(from: self.url, params: params) { (data) in
            if let data = data as? Data {
                do {
                    let decoded = try JSONDecoder().decode(Photo.self, from: data)
                    // it's probably possible to update class instead of these lines. https://stablekernel.com/understanding-extending-swift-4-codable/
                    decoded.id = id
                    decoded.ownerId = photo.ownerId
                    decoded.title = photo.title
                    decoded.dateUploadedString = photo.dateUploadedString
                    decoded.smallUrlString = photo.smallUrlString
                    decoded.mediumUrlString = photo.mediumUrlString
                    decoded.largeUrlString = photo.largeUrlString
                    completion(decoded)
                } catch {
                    print(error)
                    completion(nil)
                }
            }
        }
    }
}
