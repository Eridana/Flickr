//
//  PhotoInfoViewController.swift
//  Flickr
//
//  Created by Evgeniia Mikhailova on 20.06.18.
//  Copyright © 2018 evgeniya.mikhailova. All rights reserved.
//

import UIKit
import SafariServices

class PhotoInfoViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private var photo: PhotoViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.scrollView.minimumZoomScale = 1.0
        self.scrollView.maximumZoomScale = 5.0
        self.activityIndicator.startAnimating()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let photo = self.photo {
            self.title = photo.title
            PhotoMetadataRequest.metadata(for: photo.id) { (updatedPhoto) in
                if let result = updatedPhoto {
                    self.photo?.update(from: result)
                    DispatchQueue.main.async {
                        self.updateUI()
                    }
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setup(_ photo: PhotoViewModel) {
        self.photo = photo
    }
    
    // MARK: - UI
    
    func updateUI() {
        if let url = self.photo?.urlL ?? self.photo?.urlM {
            self.imageView.sd_setImage(with: url, placeholderImage: nil, options: .progressiveDownload) { (image, error, cacheType, url) in
                self.imageView.image = image
                self.activityIndicator.stopAnimating()
            }
        }
        self.textView.attributedText = self.photo?.fullPhotoText
    }
    

    // MARK: - Safari
    
    @IBAction func openInBrowser(_ sender: UIButton) {
        if let url = self.photo?.postUrl {
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
