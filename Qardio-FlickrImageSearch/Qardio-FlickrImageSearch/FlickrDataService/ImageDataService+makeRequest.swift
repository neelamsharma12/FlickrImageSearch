//
//  ImageDataService+makeRequest.swift
//  Qardio-FlickrImageSearch
//
//  Created by Neelam Sharma on 28/11/21.
//

import Foundation

extension ImageDataService {
    
    func makeRequest<T: Decodable>(_ model: T.Type, url: URL, completion: @escaping (Result<T, Error>) -> Void) {
        session.dataTask(with: url, completionHandler: { (data, response, error) in
            if let error = error {
                completion(.failure(error))
            } else if isSuccessResponse(response, error) {
                if let data = data {
                    print(data)
                    let result = Result { try JSONDecoder().decode(T.self, from: data) }
                    completion(result)
                }
            }
        }).resume()
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
}
