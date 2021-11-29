//
//  FlickrImageSearchViewModel.swift
//  Qardio-FlickrImageSearch
//
//  Created by Neelam Sharma on 28/11/21.
//

import Foundation

protocol FlickrImageSearchViewModelDelegate: AnyObject {
    
    func didLoadImageList(_ photos: [FlickrPhotoData]?)
    func didFailLoadingImageList(_ error: Error?)

}

/// This class contains business logic FlickrImageSearchViewController class
final class FlickrImageSearchViewModel {

    // MARK: - variable declaration
    private var session: ImageSession
    weak var delegate: FlickrImageSearchViewModelDelegate?
    var imageList: [FlickrPhotoData]?

    init(sessionProvider: ImageSession, delegate: FlickrImageSearchViewModelDelegate? = nil) {
        self.session = sessionProvider
        self.delegate = delegate
    }

    /// API fo return the get image list using search string
    /// Parameters: searchString, pageNumber and itemsPerPage
    ///  - completion: Handles the response
    func getImageList(forSearchString searchString: String?, pageNumber: Int, andItemsPerPage: Int? = 25) {
        session.loadImagesData(forSearchString: searchString, pageNumber: pageNumber, andItemsPerPage: andItemsPerPage ?? 25) { result  in
            switch result {
            case .success(let imagesListData):
                if var images = self.imageList {
                    images += imagesListData.photo.photos
                    self.imageList = images
                } else {
                    self.imageList = imagesListData.photo.photos
                }
                self.delegate?.didLoadImageList(self.imageList)
            case .failure(let error):
                self.delegate?.didFailLoadingImageList(error)
            }
        }
    }

}
