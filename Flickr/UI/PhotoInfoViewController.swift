//
//  PhotoInfoViewController.swift
//  Flickr
//
//  Created by Evgeniia Mikhailova on 20.06.18.
//  Copyright © 2018 evgeniya.mikhailova. All rights reserved.
//

import UIKit

class PhotoInfoViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textView: UITextView!
    
    var photo: Photo?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
        // Dispose of any resources that can be recreated.
    }
    
    func setup(_ photo: Photo) {
        self.photo = photo
    }
    
    func updateUI() {
        if let url = self.photo?.urlLarge ?? self.photo?.urlMedium {
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
