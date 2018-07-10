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
import RxSwift

class PhotoViewModel {

    var urlS: Variable<URL?>?
    var urlM: Variable<URL?>?
    var urlL: Variable<URL?>?
    
    var id: String?
    var ownerId: String?
    var ownerName: String?
    var date: Date?
    var dateFormatted: String?
    var title: Variable<String?>?
    var photoDescription: Variable<String?>?
    var postUrl: URL?
    
    var fullPhotoText: NSAttributedString? {
        get {
            var fullText = ""
            if let ownerName = self.ownerName { fullText.append(ownerName + "<p/>") }
            if let dateString = self.dateFormatted { fullText.append(String(format: "on %@ <p/>", dateString)) }
            if let title = self.title?.value { fullText.append(title + "<p/>") }
            if let description = self.photoDescription?.value { fullText.append(description) }
            return fullText.attributedHTMLString()
        }
    }

    var dateFormatter = DateFormatter()
    
    init() {
        
    }
    
    init(photo: Photo) {
        
        self.id = photo.id
        
        if let urlString = photo.fullInfo?.urls?.contentUrls?.first?.text, let url = URL(string: urlString) {
            self.postUrl = url
        }
        
        self.urlS = Variable<URL?>(photo.urlSmall)
        self.urlM = Variable<URL?>(photo.urlMedium)
        self.urlL = Variable<URL?>(photo.urlLarge)
        
        self.ownerId = photo.ownerId
        self.ownerName = photo.fullInfo?.owner?.username
        self.date = photo.dateUploaded
        self.title = Variable<String?>(photo.fullInfo?.title?.text)
        self.photoDescription = Variable<String?>(photo.fullInfo?.description?.text)
        
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
            self.photoDescription = Variable<String?>(description)
        }
        
        if let title = photo.fullInfo?.title?.text {
            self.title = Variable<String?>(title)
        }
    }
}
