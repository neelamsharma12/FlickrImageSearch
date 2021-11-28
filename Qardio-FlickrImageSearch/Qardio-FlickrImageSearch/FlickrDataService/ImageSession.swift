//
//  ImageSession.swift
//  Qardio-FlickrImageSearch
//
//  Created by Neelam Sharma on 28/11/21.
//

import Foundation

/// This protocol provides the Image session
protocol ImageSessionProviding {
    var imagession: ImageSession { get }
}

/// Requirements for 'ImageSession'
protocol ImageSession {

    typealias Handler<Response> = (Result<Response, Error>) -> Void

    // MARK: - Get Requests

    /// API fo fetch the Images from the json file
    /// Parameters:
    ///  - completion: Handles the response
    func loadImagesData(forSearchString searchString: String?, pageNumber: Int, andItemsPerPage itemsPerPage: Int, completion: @escaping Handler<Photos>)
}
