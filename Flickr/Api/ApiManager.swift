//
//  ApiManager.swift
//  Flickr
//
//  Created by Evgeniia Mikhailova on 19.06.18.
//  Copyright © 2018 evgeniya.mikhailova. All rights reserved.
//

import UIKit
import Alamofire

class ApiManager: NSObject {
    
    public static let sharedInstance = ApiManager()
    
    private let endpoint = "https://api.flickr.com/services/rest"
    private let apiKey = "36a1603235dacf0c36ffcaf2f8bd8c82"
    
    private var baseParams: [String: Any] {
        get {
            return ["api_key" : self.apiKey,
                    "format" : "json",
                    "nojsoncallback" : "1"]
        }
    }

    private override init() {
        super.init()
    }
    
    public func get(from urlString: String, params: [String: Any]?, completion: @escaping ((Any?) -> Void)) {
        
        guard let url = URL(string: String(format: "%@?method=%@", self.endpoint, urlString)) else {
            completion(nil)
            return
        }        
        
        Alamofire.request(url, method: HTTPMethod.get, parameters: self.compoundParameters(from: params), encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            print(response.request ?? "No request in response")
            print(response.result.debugDescription)
            completion(response.data)
        }
    }
    
    private func compoundParameters(from data: [String: Any]?) -> [String: Any] {
        guard let data = data else {
            return self.baseParams
        }
        return data.merging(self.baseParams, uniquingKeysWith: { (current, _) -> Any in current })
    }
}
