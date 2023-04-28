//
//  ApiService.swift
//  NewsReaderApp
//
//  Created by Muhammad Fikri Bill Gufran on 28/4/23.
//

import Foundation
import Alamofire

class ApiService {
    static let shared: ApiService = ApiService()
    private init() { }
    
    private let API_KEY = "qSIlD6NX9jGXEoGgXGbWLCFHJh7wqVXU"
    private let BASE_URL = "https://api.nytimes.com/svc/mostpopular/v2"
    
    // using Alamofire
    func loadLatestNews(completion: @escaping (Result<[News], Error>) -> Void) {
        let urlString = "\(BASE_URL)/viewed/7.json"
        
        AF.request(urlString, method: HTTPMethod.get, parameters: ["api-key": API_KEY])
            .validate()
            .responseDecodable(of: NewsResponse.self) { response in
                switch response.result {
                case .success(let newsResponse):
                    completion(.success(newsResponse.results))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    // using iOS SDK
    func loadNews(completion: @escaping (Result<[News], Error>) -> Void) {
        let urlString = "\(BASE_URL)/viewed/7.json?api-key=\(API_KEY)"
        
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                DispatchQueue.main.async {
                    if let _error = error {
                        completion(.failure(_error))
                    } else {
                        if let _data = data {
                            do {
                                let newsResponse = try JSONDecoder().decode(NewsResponse.self, from: _data)
                                completion(.success(newsResponse.results))
                            } catch  {
                                completion(.failure(error)) // `error` refer to catch's error
                            }
                        } else {
                            completion(.success([]))
                        }
                    }
                }
            }
            task.resume()
            
        } else {
            completion(.success([]))
        }
    }
}
