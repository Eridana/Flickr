//
//  String+NSAttributedString.swift
//  Flickr
//
//  Created by Evgeniia Mikhailova on 09.07.18.
//  Copyright © 2018 evgeniya.mikhailova. All rights reserved.
//

import Foundation

extension String {
    func attributedHTMLString() -> NSAttributedString? {
        if let nsstring = self as NSString?, let data = nsstring.data(using: String.Encoding.unicode.rawValue) {
            let options = [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html]
            return try? NSAttributedString(data: data, options: options, documentAttributes: nil)
        }
        return nil
    }
}
