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
    
    var thumbnailURL: URL?{
        get {
            // This is the full url to get the photo
            if let url = URL(string: "https://farm\(farm).static.flickr.com/\(server)/\(photoID)_\(secret).jpg") {
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
