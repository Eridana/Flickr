//
//  PhotosTableViewCell.swift
//  Flickr
//
//  Created by Evgeniia Mikhailova on 20.06.18.
//  Copyright © 2018 evgeniya.mikhailova. All rights reserved.
//

import UIKit

protocol PhotosTableViewCellDelegate {
    func didSelectPhoto(_ photo: PhotoViewModel)
}

class PhotosTableViewCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    public var cellDelegate: PhotosTableViewCellDelegate?
    
    private var viewModel: PhotosPageViewModel?
    private var categoryName: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setupWith(_ viewModel: PhotosPageViewModel) {
        self.viewModel = viewModel
        self.categoryName = viewModel.title
        self.collectionView.reloadData()
        self.collectionView.scrollRectToVisible(CGRect(x: 0, y: 0, width: 1, height: 1), animated: false)
    }
    
    // MARK: - UICollectionViewDataSource, UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let photo = self.viewModel?.photoAt(index: indexPath.row) {
            if let delegate = cellDelegate {
                delegate.didSelectPhoto(photo)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: PhotoCollectionViewCell.self), for: indexPath) as? PhotoCollectionViewCell else {
            return PhotoCollectionViewCell()
        }
        return  cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let photo = self.viewModel?.photoAt(index: indexPath.row) {
            (cell as? PhotoCollectionViewCell)?.setup(with: photo)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel?.itemsCount ?? 0
    }

}
