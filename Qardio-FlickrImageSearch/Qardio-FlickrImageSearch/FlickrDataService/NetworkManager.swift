//
//  NetworkManager.swift
//  Qardio-FlickrImageSearch
//
//  Created by Neelam Sharma on 28/11/21.
//

import Foundation

typealias RequestCompletionHandler = (Data?, Error?) -> Void

class DownloadTask:  URLSessionTask {
    
    // MARK: - variable declaration
    var completionHandler: RequestCompletionHandler
    
    init(completionHandler: @escaping RequestCompletionHandler) {
        self.completionHandler = completionHandler
    }
    
}

class NetworkManager {
    
    // MARK: - variable declaration
    static let shared: NetworkManager = NetworkManager()
    private var session: URLSession? = nil
    private var downloadTasks = [URL: DownloadTask]()
    
    // MARK: - Init Methods
    private init(){
        session = URLSession(configuration: .default)
    }
    
    // MARK: - Utility Methods
    func makeRequest<T: Decodable>(_ model: T.Type, url: URL, completion: @escaping (Result<T, Error>) -> Void) {
        session?.dataTask(with: url, completionHandler: {(data, response, error) in
            if let error = error {
                completion(.failure(error))
            } else if self.isSuccessResponse(response, error) {
                if let data = data {
                    let result = Result { try JSONDecoder().decode(T.self, from: data) }
                    completion(result)
                }
            }
        }).resume()
    }
    
    func download(fromURL url: URL, completion: @escaping RequestCompletionHandler) {
        if downloadTasks.keys.contains(url){
            let downloadTask = downloadTasks[url]
            downloadTask?.completionHandler = completion
            downloadTask?.priority = URLSessionTask.highPriority
        } else {
            let downloadTask = session?.downloadTask(with: url, completionHandler: {[weak self] (tempLocalUrl, response, error) in
                let completionHandler = self?.downloadTasks[url]?.completionHandler
                if self?.isSuccessResponse(response, error) ?? false, let data = self?.dataFrom(tempLocalUrl){
                    completionHandler?(data, nil)
                }else{
                    completionHandler?(nil, error)
                }
                
                self?.downloadTasks.removeValue(forKey: url)
            })
            let task = DownloadTask(completionHandler: completion)
            downloadTasks[url] = task
            downloadTask?.resume()
        }
    }
    
    private func isSuccessResponse(_ response: URLResponse?,_ error: Error?)-> Bool{
        if let httpResponse: HTTPURLResponse = response as? HTTPURLResponse{
            switch httpResponse.statusCode{
            case 200...202:
                return true
            default:
                return false
            }
        }else{
            return false
        }
    }
    
    private func dataFrom(_ tempLocalUrl: URL?) -> Data!{
        guard let tempLocalUrl = tempLocalUrl else{
            return nil
        }
        
        do {
            let data = try Data(contentsOf: tempLocalUrl)
            return data
        } catch {
            return nil
        }
    }

    func reducePriorityOfTask(withURL url: URL){
        if downloadTasks.keys.contains(url){
            let downloadTask = downloadTasks[url]
            downloadTask?.priority = URLSessionTask.lowPriority
        }
    }

}
