//
//  RecentPhotosRequest.swift
//  Flickr
//
//  Created by Evgeniia Mikhailova on 19.06.18.
//  Copyright © 2018 evgeniya.mikhailova. All rights reserved.
//

import UIKit

class RecentPhotosRequest: NSObject {
    
    private static let url = "flickr.photos.getRecent"
    
    static func getPhotos(completion: @escaping ((PhotosRequestResult?) -> Void)) {
        
        let params:[String: Any]? = ["per_page" : "10", "extras" : "url_m,url_l,date_upload"]
        
        ApiManager.sharedInstance.get(from: self.url, params: params) { (data) in
            if let data = data as? Data {
                do {
                    let decoded = try JSONDecoder().decode(PhotosRequestResult.self, from: data)
                    completion(decoded)
                } catch {
                    print(error)
                    completion(nil)
                }
            }
        }        
    }
}
