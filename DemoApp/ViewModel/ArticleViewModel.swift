//
//  ArticleViewModel.swift
//  DemoApp
//
//  Created by Dinesh Tanwar on 13/06/21.
//

import Foundation

struct ArticleListViewModel {
    let articles: [Article]
}

extension ArticleListViewModel {
    
    var numberOfSections: Int {
        return 1
    }
    
    func numberOfRowsInSection(_ section: Int) -> Int {
        return self.articles.count
    }
    
    func articleAtIndex(_ index: Int) -> ArticleViewModel {
        let article = self.articles[index]
        return ArticleViewModel(article)
    }
    
}

//Single Article
struct ArticleViewModel {
    private let article: Article
}

extension ArticleViewModel {
    init(_ article: Article) {
        self.article = article
    }
}

extension ArticleViewModel {
    
    var title: String {
        return self.article.title
    }
    
    var description: String {
        return self.article.articleDescription ?? "Content unavailable"
    }
}

//TEST
class ArticlesViewModel {
    private var apiService = WebService()
    private var newArticles = [Article]()

    func fetchArticleData(completion: @escaping () -> ()) {
        apiService.getArticle { [weak self] (result) in
            switch result {
                case .success(let listOf):
                    self?.newArticles = listOf.articles
                    completion()
                case .failure(let error):
                    // Something is wrong with the JSON
                    print("Error processing json data: \(error)")
            }
        }
    }
    
    func numberOfRowsInSection(section: Int) -> Int {
        if newArticles.count != 0 {
            return newArticles.count
        }
        return 0
    }
    
    func cellForRowAt (indexPath: IndexPath) -> Article {
        return newArticles[indexPath.row]
    }
}

