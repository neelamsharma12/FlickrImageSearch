//
//  ImageDataService.swift
//  Qardio-FlickrImageSearch
//
//  Created by Neelam Sharma on 28/11/21.
//

import Foundation

class ImageDataService {
    var session: URLSession { URLSession.shared }
    var downloadTasks = [URL: DownloadTask]()
}

extension ImageDataService: ImageSession {

    /// API fo fetch the Images from the json file
    /// Parameters:
    ///  - completion: Handles the response
    func loadImagesData(forSearchString searchString: String?, pageNumber: Int, andItemsPerPage itemsPerPage: Int, completion: @escaping Handler<Photos>) {
        guard let flickrSearchURL = searchURL(forSearchString: searchString ?? "", pageNumber: pageNumber, andItemsPerPage: itemsPerPage) else{
            debugPrint("failed to create search url")
            return
        }
        NetworkManager.shared.makeRequest(Photos.self, url: flickrSearchURL) { result in
            completion(result)
        }
    }
    
    /// API fo return the search url from the search string
    /// Parameters: searchString, pageNumber and itemsPerPage
    ///  - completion: Handles the response
    private func searchURL(forSearchString searchString: String, pageNumber: Int, andItemsPerPage itemsPerPage: Int) -> URL?{
        
        guard let escapedSearchString = searchString.addingPercentEncoding(withAllowedCharacters: CharacterSet.alphanumerics) else { return nil }
        
        let URLString = "\(FlickrConstants.flickrAPIBaseURL)?method=flickr.photos.search&api_key=\(FlickrConstants.apiKey)&text=\(escapedSearchString)&per_page=\(itemsPerPage)&page=\(pageNumber)&format=json&nojsoncallback=1"
        
        guard let url = URL(string: URLString) else { return nil }
        
        return url
    }

}
