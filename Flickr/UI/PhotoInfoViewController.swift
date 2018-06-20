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
    private var photo: Photo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.scrollView.minimumZoomScale = 1.0
        self.scrollView.maximumZoomScale = 5.0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let photo = self.photo {
            PhotoMetadataRequest.metadata(for: photo) { (updatedPhoto) in
                self.photo = updatedPhoto
                DispatchQueue.main.async {
                    self.updateUI()
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setup(_ photo: Photo) {
        self.photo = photo
    }
    
    // MARK: - UI
    
    func updateUI() {
        if let url = self.photo?.urlLarge ?? self.photo?.urlMedium {
            self.imageView.sd_setShowActivityIndicatorView(true)
            self.imageView.sd_setIndicatorStyle(.whiteLarge)
            self.imageView.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder"), options: .progressiveDownload) { (image, error, cacheType, url) in
                self.imageView.image = image
            }
        }
        
        var fullText = ""
        
        if let ownerName = self.photo?.fullInfo?.owner?.username {
            fullText.append(ownerName + "<p/>")
        }
        
        if let date = self.photo?.dateUploaded {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd.MM.yyyy, HH:mm:ss"
            fullText.append(String(format: "on %@ <p/>", formatter.string(from: date)))
        }
        
        if let title = self.photo?.fullInfo?.title?.text {
            fullText.append(title + "<p/>")
        }
        if let descr = self.photo?.fullInfo?.description?.text {
            fullText.append(descr)
        }
        if let attributedString = self.attrStringFromHtmlString(fullText) {
            self.textView.attributedText = attributedString
        }
        
    }
    
    func attrStringFromHtmlString(_ text: String?) -> NSAttributedString? {
        if let nsstring = text as NSString?, let data = nsstring.data(using: String.Encoding.unicode.rawValue) {
            let options = [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html]
            return try? NSAttributedString(data: data, options: options, documentAttributes: nil)
        }
        return nil
    }

    // MARK: - Safari
    
    @IBAction func openInBrowser(_ sender: UIButton) {
        if let urlString = self.photo?.fullInfo?.urls?.contentUrls?.first?.text, let url = URL(string: urlString) {
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
