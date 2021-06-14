//
//  Webservice.swift
//  DemoApp
//
//  Created by Dinesh Tanwar on 13/06/21.
//

import Foundation

//class Webservice {
//    func getArticle(url: URL, completion: @escaping ([Article]?) -> ()) {
//
//        URLSession.shared.dataTask(with: url) { data, reponse, error in
//
//            if let error = error {
//                print(error.localizedDescription)
//                completion(nil)
//            }
//            else if let data = data {
//                let articleList = try? JSONDecoder().decode(ArticleList.self, from: data)
//                if let articleList = articleList {
//                    print(articleList.articles)
//                    completion(articleList.articles)
//                }
//            }
//
//        }.resume()
//    }
//}

class WebService {
    
    private var dataTask: URLSessionDataTask?

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
}
