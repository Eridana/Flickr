//
//  PhotosTableViewCell.swift
//  Flickr
//
//  Created by Evgeniia Mikhailova on 20.06.18.
//  Copyright © 2018 evgeniya.mikhailova. All rights reserved.
//

import UIKit

protocol PhotosTableViewCellDelegate {
    func didSelectPhoto(_ photo: Photo)
}

class PhotosTableViewCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    public var cellDelegate: PhotosTableViewCellDelegate?
    
    private var data: [Photo]?
    private var categoryName: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupWithData(_ data: [Photo], categoryName: String?) {
        self.data = data
        self.categoryName = categoryName
        self.collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let photo = data![indexPath.row]
        if let delegate = cellDelegate {
            delegate.didSelectPhoto(photo)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: PhotoCollectionViewCell.self), for: indexPath) as? PhotoCollectionViewCell else {
            return PhotoCollectionViewCell()
        }
        if let photo = data?[indexPath.row] {
            cell.setup(with: photo)
        }
        return  cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data?.count ?? 0
    }

}
