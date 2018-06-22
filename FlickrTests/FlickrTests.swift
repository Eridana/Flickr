//
//  FlickrTests.swift
//  FlickrTests
//
//  Created by Evgeniia Mikhailova on 19.06.18.
//  Copyright © 2018 evgeniya.mikhailova. All rights reserved.
//

import XCTest
@testable import Flickr

class FlickrTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testPhotosRequest() {
        RecentPhotosRequest.getPhotos { (result) in
            assert(result != nil)
            assert(result?.photosInfo != nil)
            assert((result?.photosInfo?.photos?.count ?? 0) > 0)
        }
    }
    
    func testPhotosRequestWithPages() {
        let page = 2
        RecentPhotosRequest.getPhotos(for: page, perPage: 10) { (result) in
            assert(result != nil)
            assert(result?.photosInfo != nil)
            assert(result?.photosInfo?.page == page)
            assert((result?.photosInfo?.photos?.count ?? 0) == 10)
        }
    }
    
    func testPhotoMetadataRequest() {
        let page = 5
        RecentPhotosRequest.getPhotos(for: page, perPage: 10) { (result) in
            assert(result != nil)
            assert(result?.photosInfo != nil)
            let photo = result?.photosInfo?.photos?.first
            assert(photo != nil)
            
            PhotoMetadataRequest.metadata(for: photo!) { (updatedPhoto) in
                assert(updatedPhoto != nil)
                assert(updatedPhoto?.dateUploadedString != nil && !(updatedPhoto?.dateUploadedString?.isEmpty ?? true))
                assert(updatedPhoto?.largeUrlString != nil && !(updatedPhoto?.largeUrlString?.isEmpty ?? true))
                assert(updatedPhoto?.fullInfo != nil)                
            }
        }
    }
    
}
