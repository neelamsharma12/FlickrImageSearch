//
//  FlickrPhotoData.swift
//  Qardio-FlickrImageSearch
//
//  Created by Neelam Sharma on 28/11/21.
//

import Foundation

public struct FlickrPhotoData {
    
    let photoID : String
    let server : String
    let secret : String
    let farm : Int
    
    var highResPhotoURL: URL? {
        get {
            // this is the url for a high resolution image
            if let url =  URL(string: "https://farm\(farm).staticflickr.com/\(server)/\(photoID)_\(secret)_b.jpg") {
                return url
            }
            return nil
        }
    }

}

extension FlickrPhotoData: Decodable {

    enum CodingKeys: String, CodingKey {
        case photoID = "id"
        case server, secret, farm
    }

}
