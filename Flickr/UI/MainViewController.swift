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
    private var categories = [Int: [Photo]]()
    private var currentPage: Int = 1
    private var dataIsLoading = false
    private let refreshControl = UIRefreshControl()
    
    private var sortedKeys: [Int] {
        get {
            return self.categories.keys.sorted()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Recent photos"
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.addTarget(self, action: #selector(MainViewController.refreshData), for: .valueChanged)
        self.tableView.addSubview(refreshControl)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.fetchData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fetchData() {
        
        if self.dataIsLoading {
            return
        }
        
        self.dataIsLoading = true
        
        DispatchQueue.global(qos: .background).async {
            RecentPhotosRequest.getPhotos(for: self.currentPage, perPage: 10) { (result) in
                if let photos = result?.photosInfo?.photos, let page = result?.photosInfo?.page {
                    self.currentPage = self.currentPage + 1
                    self.categories[page] = photos
                    DispatchQueue.main.async {
                        self.refreshControl.endRefreshing()
                        self.tableView.reloadData()
                        self.dataIsLoading = false
                    }
                }
            }
        }
    }
    
    @objc func refreshData() {
        self.currentPage = 0
        self.categories = [Int: [Photo]]()
        self.fetchData()
    }
    
    // MARK: - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.categories.keys.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: PhotosTableViewCell.self)) as? PhotosTableViewCell else {
            return PhotosTableViewCell()
        }
        cell.cellDelegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 220.0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let keys = self.sortedKeys
        if section < keys.count {
            return "Page \(keys[section])"
        }
        return ""
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let key = self.sortedKeys[indexPath.section]
        let array = Array(self.categories[key] ?? [])
        (cell as? PhotosTableViewCell)?.setupWithData(array, categoryName: "\(key)")
        
        if indexPath.section == self.categories.keys.count - 1 {
            self.fetchData()
        }
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

