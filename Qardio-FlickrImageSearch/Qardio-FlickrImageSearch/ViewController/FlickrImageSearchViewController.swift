//
//  ViewController.swift
//  Qardio-FlickrImageSearch
//
//  Created by Neelam Sharma on 28/11/21.
//

import UIKit
import CoreData

private struct FlickrImageSearchViewControllerConstants {
    static let cellPadding: CGFloat = 10.0
    static let defaultNumberOfColumns = 4
    static let cellIdentifier = "ImageCollectionViewCell"
    static let footerIdentifier = "CustomFooterView"
    static let itemsPerPage = 25
    
    struct Messages{
        static let searchDefaultPlaceholder = "Search"
    }
}

class FlickrImageSearchViewController: UICollectionViewController {

    // MARK: - variable declaration
    var viewModel: FlickrImageSearchViewModel?
    fileprivate var itemsPerRow = 2
    let searchController = UISearchController(searchResultsController: nil)
    var searchString: String? = nil
    fileprivate var isLoading: Bool = false
    var isFulfillingSearchConditions: Bool{
        get {
            if let searchText = searchController.searchBar.text {
                searchString = searchText
                return true
            }else{
                return false
            }
        }
    }
    
    // MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = FlickrImageSearchViewModel(sessionProvider: ApplicationHost.init().imagession, delegate: self)
        configureCitySearchView()
    }

    // MARK: - Private methods
    private func configureCitySearchView() {
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = searchController
        searchController.searchBar.delegate = self
        self.definesPresentationContext = true
        self.navigationItem.titleView = searchController.searchBar
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "Search Images"
    }
    
    @objc fileprivate func searchNextPage(){
        let currentPage = (viewModel?.imageList?.count ?? 0)/FlickrImageSearchViewControllerConstants.itemsPerPage
        viewModel?.getImageList(forSearchString: searchString, pageNumber: currentPage+1)
        createData()
    }
    
    func createData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        guard let searchEntity = NSEntityDescription.entity(forEntityName: "SearchHistory", in: managedContext) else {
            return
        }
        let searcHistory = NSManagedObject(entity: searchEntity, insertInto: managedContext)
        searcHistory.setValue(searchString, forKeyPath: "keyword")
        do {
            try managedContext.save()
        } catch let error as NSError {
            debugPrint("Could not save. \(error), \(error.userInfo)")
        }
    }

}

// MARK: - FlickrImageSearchViewModelDelegate
extension FlickrImageSearchViewController: FlickrImageSearchViewModelDelegate {
    func didLoadImageList() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
            self.isLoading = false
        }
    }
    
    func didFailLoadingImageList(_ error: Error?) {
       isLoading = false
    }
    
}

// MARK: - UICollectionViewDataSource implementation
extension FlickrImageSearchViewController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return viewModel?.imageList?.count ?? 0
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FlickrImageSearchViewControllerConstants.cellIdentifier, for: indexPath)
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let photo = viewModel?.imageList else {
            return
        }
        if let cell = cell as? ImageCollectionViewCell {
            cell.setData(photo[indexPath.row])
            if photo.count - indexPath.row == (2 * itemsPerRow){
                searchNextPage()
            }
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let cell = cell as? ImageCollectionViewCell {
            cell.reducePriorityOfDownloadtaskForCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.size.width, height: 55)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize.zero
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: FlickrImageSearchViewControllerConstants.footerIdentifier, for: indexPath) as? CustomFooterView {
            isLoading ? footerView.loader.startAnimating(): footerView.loader.stopAnimating()
            return footerView
        }
        return UICollectionReusableView()
    }

}

// MARK: - UICollectionViewDelegateFlowLayout
extension FlickrImageSearchViewController: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        let paddingPerRow = FlickrImageSearchViewControllerConstants.cellPadding * CGFloat(itemsPerRow - 1)
        let availableSpace = self.view.frame.width - paddingPerRow
        let dimensionOfEachItem = availableSpace/CGFloat(itemsPerRow)
        
        return CGSize(width: dimensionOfEachItem, height: dimensionOfEachItem)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return FlickrImageSearchViewControllerConstants.cellPadding
    }
}

// MARK: - UISearchBarDelegate
extension FlickrImageSearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if isFulfillingSearchConditions{
            viewModel?.getImageList(forSearchString: searchString, pageNumber: 0, andItemsPerPage: FlickrImageSearchViewControllerConstants.itemsPerPage)
            createData()
            viewModel?.imageList?.removeAll()
            isLoading = true
            searchController.isActive = false
            searchBar.placeholder = searchString
        }
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar){
        searchBar.placeholder = FlickrImageSearchViewControllerConstants.Messages.searchDefaultPlaceholder
    }
}
