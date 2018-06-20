//
//  MainViewController.swift
//  Flickr
//
//  Created by Evgeniia Mikhailova on 19.06.18.
//  Copyright © 2018 evgeniya.mikhailova. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    private var categories = [String: [Photo]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        RecentPhotosRequest.getPhotos { (result) in
            if let result = result?.photosInfo?.photos {
                DispatchQueue.main.async {
                    self.categories["No category"] = result
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.categories.keys.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: PhotosTableViewCell.self)) as? PhotosTableViewCell else {
            return PhotosTableViewCell()
        }
        let keys = Array(self.categories.keys)
        let key = keys[indexPath.section]
        let array = Array(self.categories[key] ?? [])
        cell.setupWithData(array, categoryName: key)
        cell.cellDelegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150.0
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PhotoInfoSegue" {
            if let photo = sender as? Photo {
                let destination = segue.destination as? PhotoInfoViewController
                destination?.setup(photo)
            }
        }
    }
    
    // MARK: - Extensions
}

extension MainViewController: PhotosTableViewCellDelegate {
    func didSelectPhoto(_ photo: Photo) {
        self.performSegue(withIdentifier: "PhotoInfoSegue", sender: photo)
    }
}

