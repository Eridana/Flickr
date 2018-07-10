//
//  PhotoInfoViewController.swift
//  Flickr
//
//  Created by Evgeniia Mikhailova on 20.06.18.
//  Copyright © 2018 evgeniya.mikhailova. All rights reserved.
//

import UIKit
import SafariServices
import RxSwift

class PhotoInfoViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    private lazy var variablePhoto: Variable<PhotoViewModel> = Variable<PhotoViewModel>(PhotoViewModel())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.scrollView.minimumZoomScale = 1.0
        self.scrollView.maximumZoomScale = 5.0
        
        self.activityIndicator.startAnimating()
        
        self.setupObservers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        PhotoMetadataRequest.metadata(for: variablePhoto.value.id) { (updatedPhoto) in
            if let result = updatedPhoto {
                self.variablePhoto.value.update(from: result)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setup(_ photo: PhotoViewModel) {
        self.variablePhoto = Variable<PhotoViewModel>(photo)
    }
    
    func setupObservers() {
        let _ = self.variablePhoto.value.urlL?.asObservable().subscribe(onNext: { (url) in
            self.imageView.sd_setImage(with: url, placeholderImage: nil, options: .progressiveDownload) { (image, error, cacheType, url) in
                self.imageView.image = image
                self.activityIndicator.stopAnimating()
            }
        })
        
        let _ = self.variablePhoto.value.title?.asObservable().subscribe(onNext: { (value) in
            self.title = value
        })
        
        let _ = self.variablePhoto.value.photoDescription?.asObservable().subscribe(onNext: { (value) in
            self.textView.attributedText = self.variablePhoto.value.fullPhotoText
        })
    }

    // MARK: - Safari
    
    @IBAction func openInBrowser(_ sender: UIButton) {
        if let url = self.variablePhoto.value.postUrl {
            let safariController = SFSafariViewController(url: url)
            self.present(safariController, animated: true, completion: nil)
        }
    }
    
    // MARK: - Share
    
    @IBAction func shareImage(_ sender: UIBarButtonItem) {
        guard let image = self.imageView.image else {
            return
        }
        let activityViewController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    // MARK: - UIScrollViewDelegate
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
}
