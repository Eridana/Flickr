//
//  PhotosPagesListViewModel.swift
//  Flickr
//
//  Created by Evgeniia Mikhailova on 09.07.18.
//  Copyright © 2018 evgeniya.mikhailova. All rights reserved.
//

import UIKit

class PhotosPagesListViewModel {
    var title: String?
    var photosByPages:[Int: PhotosPageViewModel] = [Int: PhotosPageViewModel]()
    var itemsCount: Int {
        return self.photosByPages.keys.count
    }
    var sections: [Int] {
        get {
            return self.photosByPages.keys.sorted()
        }
    }
    
    init() {
        
    }
    
    func update(result: PhotosRequestResult, page: Int) {
        if let data = result.photosInfo, let photos = data.photos, let page = data.page {
            let photoModels = photos.compactMap { (photo) in
                return PhotoViewModel(photo: photo)
            }
            self.photosByPages[page] = PhotosPageViewModel(photos: photoModels, page: page)
        }
    }
    
    func title(for section: Int) -> String {
        return "Page \(sections[section])"
    }
    
    func value(for row: Int, section: Int) -> PhotosPageViewModel? {
        let key = self.sections[section]
        return self.photosByPages[key]
    }
}
