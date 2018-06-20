//
//  PhotoCollectionViewCell.swift
//  Flickr
//
//  Created by Evgeniia Mikhailova on 20.06.18.
//  Copyright © 2018 evgeniya.mikhailova. All rights reserved.
//

import UIKit
import SDWebImage

class PhotoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    func setup(with photo: Photo) {
        if let url = photo.urlMedium ?? photo.urlLarge {
            self.imageView.sd_setShowActivityIndicatorView(true)
            self.imageView.sd_setIndicatorStyle(.whiteLarge)
            self.imageView.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder"), options: .progressiveDownload) { (image, error, cacheType, url) in
                self.imageView.image = image
            }
        }
        self.titleLabel.text = photo.title
    }
}
