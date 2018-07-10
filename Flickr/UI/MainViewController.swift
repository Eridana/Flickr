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
    private var currentPage: Int = 1
    private var dataIsLoading = false
    private let refreshControl = UIRefreshControl()

    private lazy var viewModel: PhotosPagesListViewModel = PhotosPagesListViewModel()
    
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
                if let result = result {
                    DispatchQueue.main.async {
                        self.viewModel.update(result: result, page: self.currentPage)
                        self.currentPage = self.currentPage + 1
                        self.refreshControl.endRefreshing()
                        self.dataIsLoading = false
                        self.tableView.reloadData()
                    }
                } else {
                    // error
                }
            }
        }
    }
    
    @objc func refreshData() {
        self.currentPage = 0
        self.viewModel = PhotosPagesListViewModel()
        self.fetchData()
    }
    
    // MARK: - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.viewModel.itemsCount
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
        return viewModel.title(for: section)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let photosData = self.viewModel.value(for: indexPath.row, section: indexPath.section) {
            (cell as? PhotosTableViewCell)?.setupWith(photosData)
             let count = self.viewModel.sections.count
            if photosData.page == count - 1 || count == 1 {
                self.fetchData()
            }
        }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PhotoInfoSegue" {
            if let photo = sender as? PhotoViewModel {
                let destination = segue.destination as? PhotoInfoViewController
                destination?.setup(photo)
            }
        }
    }
    
    // MARK: - Extensions
}

extension MainViewController: PhotosTableViewCellDelegate {
    func didSelectPhoto(_ photo: PhotoViewModel) {
        self.performSegue(withIdentifier: "PhotoInfoSegue", sender: photo)
    }
}

