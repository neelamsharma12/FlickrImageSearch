//
//  ApplicationHost.swift
//  Qardio-FlickrImageSearch
//
//  Created by Neelam Sharma on 28/11/21.
//

import Foundation

class ApplicationHost: ImageSessionProviding {
    var imagession: ImageSession {
        ImageDataService()
    }
}
