//
//  ViewController.swift
//  Flickr
//
//  Created by Evgeniia Mikhailova on 19.06.18.
//  Copyright © 2018 evgeniya.mikhailova. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        RecentPhotosRequest.getPhotos { (result) in
            if let photos = result?.photosInfo?.photos {
                print(photos.count)

            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

