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
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setupWithData(_ data: [Photo], categoryName: String?) {
        self.data = data
        self.categoryName = categoryName
        self.collectionView.reloadData()
    }
    
    // MARK: - UICollectionViewDataSource, UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let photo = self.data?[indexPath.row] {
            if let delegate = cellDelegate {
                delegate.didSelectPhoto(photo)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: PhotoCollectionViewCell.self), for: indexPath) as? PhotoCollectionViewCell else {
            return PhotoCollectionViewCell()
        }
        if let photo = self.data?[indexPath.row] {
            cell.setup(with: photo)
        }
        return  cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.data?.count ?? 0
    }

}
