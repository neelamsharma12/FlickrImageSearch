//
//  ImageCollectionViewCell.swift
//  Qardio-FlickrImageSearch
//
//  Created by Neelam Sharma on 28/11/21.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: CachedImageView!

    var photo: FlickrPhotoData? = nil
    
    func setData(_ data: FlickrPhotoData?) {
        photo = data
        guard let photo = photo, let thumbnailURL = photo.thumbnailURL else {
            return
        }
        self.imageView.loadImage(atURL: thumbnailURL)
        
    }
    
    override func prepareForReuse() {
        self.imageView.image = nil
    }
    
    func reducePriorityOfDownloadtaskForCell(){
        guard let photo = photo, let thumbnailURL = photo.thumbnailURL else {
            return
        }
        NetworkManager.shared.reducePriorityOfTask(withURL: thumbnailURL)
    }
}
