//
//  Photos.swift
//  Qardio-FlickrImageSearch
//
//  Created by Neelam Sharma on 28/11/21.
//

import Foundation

/// This is a model to store the photo dictionary which contains array of photos
public struct Photos {

    let photo: PhotoInternal

}

extension Photos: Decodable {

    enum CodingKeys: String, CodingKey {
        case photo = "photos"
    }

}
