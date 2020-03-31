//
//  NetworkError.swift
//  fakeAppleMusic
//
//  Created by admin on 3/29/20.
//  Copyright © 2020 admin. All rights reserved.
//

import Foundation

enum NetworkError: Error{
    case defaultError
}

class NetworkManager {
    
    var nameSong: String = ""
    static var shared = NetworkManager()
    
    func performRequest(_ request: URLRequest, completion: @escaping (Result<Data?, Error>) -> Void) {
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                 guard let httpsResponse = response as? HTTPURLResponse,
                        httpsResponse.statusCode == 200,
                        error == nil else {
                        completion(Result.failure(NetworkError.defaultError))
                        return
                   }
                   completion(Result.success(data))
               }
          }
        task.resume()
    }
        
    func loadRates(completion: @escaping (Result<Model, Error>) -> Void){

        let urlString = "https://itunes.apple.com/search?term=\(nameSong)"
        let urlNew:String = urlString.replacingOccurrences(of: " ", with: "%20")
        print(urlString)
        let url = URL(string: urlNew)!
        let request = URLRequest(url: url)
        
        
        
        
        performRequest(request) { result in
            switch result {
            case .success(let data):
                if  let data = data,
                    let model = try? JSONDecoder().decode(Model.self, from: data){
                    completion(Result.success(model))
                } else {
                    completion(Result.failure(NetworkError.defaultError))
                }

            case .failure(let error):
                completion(Result.failure(error))
            }
        }
    }
}
