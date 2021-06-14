//
//  Webservice.swift
//  DemoApp
//
//  Created by Dinesh Tanwar on 13/06/21.
//

import Foundation

class WebService {
    
    private var dataTask: URLSessionDataTask?

    //Get GetArticle Data
    func getArticle(completion: @escaping (Result<ArticleData, Error>) -> Void) {
        
        let newsurl = "https://newsapi.org/v2/top-headlines?country=us&apiKey=cb9ff8ee7a6548ab95003348d2146318"
        
        guard let url = URL(string: newsurl) else {return}
        
        dataTask = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if let error = error {
                completion(.failure(error))
                print("DataTask error: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode(ArticleData.self, from: data)
                
                DispatchQueue.main.async {
                    completion(.success(jsonData))
                }
            } catch let error {
                completion(.failure(error))
            }
        }
        dataTask?.resume()
    }
    
    //Get image from URL
    func getImageDataFrom(url: URL, completion: @escaping (Result<Data, Error>) -> Void) {
        
        dataTask = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if let error = error {
                completion(.failure(error))
                print("DataTask error: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                return
            }
            
            DispatchQueue.main.async {
                completion(.success(data))
            }
            
        }
        dataTask?.resume()
    }
}


