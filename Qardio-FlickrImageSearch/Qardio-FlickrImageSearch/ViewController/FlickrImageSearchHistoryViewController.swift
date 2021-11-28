//
//  FlickrImageSearchHistoryViewController.swift
//  Qardio-FlickrImageSearch
//
//  Created by Neelam Sharma on 28/11/21.
//

import UIKit
import CoreData

class FlickrImageSearchHistoryViewController: UIViewController {
    
    // MARK: - IBOutlet declaration
    @IBOutlet weak var historyTableView: UITableView!
    
    // MARK: - Variable declaration
    var history = [String]()
    
    // MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        history.removeAll()
        retrieveData()

    }
    
    // MARK: - Utility methods
    func retrieveData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "SearchHistory")
        do {
            let result = try managedContext.fetch(fetchRequest)
            guard let result = result as? [NSManagedObject] else {
                return
            }
            for data in result {
                if let keyword = data.value(forKey: "keyword") as? String {
                    if !history.contains(keyword) {
                        history.append(keyword)
                    }
                }
            }
        } catch {
            debugPrint("Failed")
        }
        historyTableView.reloadData()
    }
}

// MARK: - UITableViewDataSource
extension FlickrImageSearchHistoryViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return history.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "historyCell") else {
            fatalError("Failed to load CityListCell")
        }
        cell.textLabel?.text = history[indexPath.item]

        return cell
    }

}
