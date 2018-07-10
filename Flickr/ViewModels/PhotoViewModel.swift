//
//  PhotoViewModel.swift
//  Flickr
//
//  Created by Evgeniia Mikhailova on 09.07.18.
//  Copyright © 2018 evgeniya.mikhailova. All rights reserved.
//

import UIKit
import Foundation
import SDWebImage

class PhotoViewModel {

    var urlS: URL?
    var urlM: URL?
    var urlL: URL?
    
    var id: String?
    var ownerId: String?
    var ownerName: String?
    var date: Date?
    var dateFormatted: String?
    var title: String?
    var photoDescription: String?
    var postUrl: URL?
    
    var fullPhotoText: NSAttributedString? {
        get {
            var fullText = ""
            if let ownerName = self.ownerName { fullText.append(ownerName + "<p/>") }
            if let dateString = self.dateFormatted { fullText.append(String(format: "on %@ <p/>", dateString)) }
            if let title = self.title { fullText.append(title + "<p/>") }
            if let description = self.photoDescription { fullText.append(description) }
            return fullText.attributedHTMLString()
        }
    }

    var dateFormatter = DateFormatter()
    
    init(photo: Photo) {
        
        self.id = photo.id
        
        if let urlString = photo.fullInfo?.urls?.contentUrls?.first?.text, let url = URL(string: urlString) {
            self.postUrl = url
        }
        
        self.urlS = photo.urlSmall
        self.urlM = photo.urlMedium
        self.urlL = photo.urlLarge
        
        self.ownerId = photo.ownerId
        self.ownerName = photo.fullInfo?.owner?.username
        self.date = photo.dateUploaded
        self.title = photo.fullInfo?.title?.text
        self.photoDescription = photo.fullInfo?.description?.text
        
        self.dateFormatter.dateFormat = "dd.MM.yyyy, HH:mm:ss"
        
        if let date = self.date {
            self.dateFormatted = self.dateFormatter.string(from: date)
        }
    }
    
    func update(from photo: Photo) {
        
        if let urlString = photo.fullInfo?.urls?.contentUrls?.first?.text, let url = URL(string: urlString) {
            self.postUrl = url
        }
        
        if let date = self.date {
            self.dateFormatted = self.dateFormatter.string(from: date)
        }
        
        if let ownerName = photo.fullInfo?.owner?.username {
            self.ownerName = ownerName
        }
        
        if let description = photo.fullInfo?.description?.text {
            self.photoDescription = description
        }
        
        if let title = photo.fullInfo?.title?.text {
            self.title = title
        }
    }
}
