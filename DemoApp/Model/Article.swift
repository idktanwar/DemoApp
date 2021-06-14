//
//  Article.swift
//  DemoApp
//
//  Created by Dinesh Tanwar on 13/06/21.
//

import Foundation

//Used NEWSAPI Services to gee the news data

// MARK: - Welcome
struct ArticleData: Codable {
    let status: String
    let totalResults: Int
    let articles: [Article]
}

// MARK: - Article
struct Article: Codable {
    let author: String?
    let title: String
    let articleDescription: String?
    let url: String
    let urlToImage: String?
    let publishedAt: String?
    let content: String?

    enum CodingKeys: String, CodingKey {
        case author, title
        case articleDescription = "description"
        case url, urlToImage, publishedAt, content
    }
}
