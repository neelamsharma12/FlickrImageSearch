//
//  PhotoInternal.swift
//  Qardio-FlickrImageSearch
//
//  Created by Neelam Sharma on 28/11/21.
//

import Foundation

public struct PhotoInternal {
    
    let page: Int
    let pages: Int
    let perPage: Int
    let total: Int
    let photos: [FlickrPhotoData]

}

extension PhotoInternal: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case page, pages
        case perPage = "perpage"
        case total
        case photos = "photo"
    }

}
