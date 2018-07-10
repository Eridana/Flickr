//
//  PhotosPageViewModel.swift
//  Flickr
//
//  Created by Evgeniia Mikhailova on 09.07.18.
//  Copyright © 2018 evgeniya.mikhailova. All rights reserved.
//

import Foundation

class PhotosPageViewModel {   
    var page: Int = 0
    var photos: [PhotoViewModel] = [PhotoViewModel]()
    var itemsCount: Int {
        return self.photos.count
    }
    var title: String? {
        get {
            return "Page \(self.page)"
        }
    }
    
    init(photos: [PhotoViewModel], page: Int) {
        self.photos = photos
        self.page = page
    }
    
    func photoAt(index: Int) -> PhotoViewModel {
        return self.photos[index]
    }
}
