//
//  ImageSearchViewModelDelegateSpy.swift
//  Qardio-FlickrImageSearchTests
//
//  Created by Neelam Sharma on 28/11/21.
//

import Foundation
@testable import Qardio_FlickrImageSearch

class MockFlickrImageSearchViewModelDelegate: FlickrImageSearchViewModelDelegate {
    
    var isDidLoadImageListCalled = false
    var isFailLoadingImageCalled = false
    
    func didLoadImageList(_ photos: [FlickrPhotoData]?) {
        isDidLoadImageListCalled = true
    }
    
    func didFailLoadingImageList(_ error: Error?) {
        isFailLoadingImageCalled = true
    }

}
