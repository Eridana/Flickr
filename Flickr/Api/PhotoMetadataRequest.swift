//
//  PhotoMetadataRequest.swift
//  Flickr
//
//  Created by Evgeniia Mikhailova on 20.06.18.
//  Copyright © 2018 evgeniya.mikhailova. All rights reserved.
//

import UIKit

class PhotoMetadataRequest {
    
    private static let url = "flickr.photos.getInfo"
    
    static func metadata(for photoId: String?, completion: @escaping ((Photo?) -> Void)) {
        
        guard let id = photoId else {
            completion(nil)
            return
        }
        
        let params:[String: Any]? = ["photo_id" : id]
        
        ApiManager.sharedInstance.get(from: self.url, params: params) { (data) in
            if let data = data as? Data {
                do {
                    let decoded = try JSONDecoder().decode(Photo.self, from: data)
                    completion(decoded)
                } catch {
                    print(error)
                    completion(nil)
                }
            }
        }
    }
}
