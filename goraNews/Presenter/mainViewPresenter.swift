//
//  mainViewControllerDelegate.swift
//  goraNews
//
//  Created by Yegor Geronin on 12.03.2022.
//

import Foundation
import UIKit
import CoreData

protocol UINewsProtocol: UIViewController {
    func reloadTable(with articles: [categoryStruct])
}

typealias mainViewDelegate = UINewsProtocol & UIViewController

class mainViewPresenter {
    
    private let mainDelegate: mainViewDelegate!
    
    private let contextArticles = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    init( _ mainView: mainViewDelegate) {
        self.mainDelegate = mainView
    }
    
    public func fetchNews() {
        // URL: https://newsapi.org/v2/top-headlines?category=CATEGORY&apiKey=c1d1c91345d94043b1cccada4379a38f
        let groupLock = DispatchGroup()
        var news = [categoryStruct]()
        
        for category in categories.allCases {
            guard let url = URL(string: "https://newsapi.org/v2/top-headlines?category=\(category.rawValue.lowercased())&apiKey=8b55d3b8ef8c4dda947d2c16d2e66bba&country=us") else {
                print("Error with url in category: \(category.rawValue)")
                continue
            }
            
            groupLock.enter()
            URLSession.shared.dataTask(with: url) { data, _ , error in
                guard error == nil, let data = data else {
                    print("Smthing went wrong...\n \(error?.localizedDescription ?? "Error equals nil")")
                    groupLock.leave()
                    return
                }
                guard let newsInCategory = try? JSONDecoder().decode(requestNews.self, from: data),
                      newsInCategory.totalResults > 0 else {
                          print("Unable to decode or news count in \(category.rawValue) equals 0... \n \t \(url)")
                          groupLock.leave()
                          return
                      }
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                let newCategory = categoryStruct(title: category.rawValue,
                                                 news: newsInCategory.articles.map({ articleNews in
                    return article(title: articleNews.title,
                                   url: articleNews.url,
                                   urlToImage: articleNews.urlToImage,
                                   date: dateFormatter.date(from: articleNews.publishedAt) ?? .now )
                }))
                news.append(newCategory)
                groupLock.leave()
            }.resume()
        }
        
        groupLock.notify(queue: .main) { [weak self] in
            print("Unlocked!")
            DispatchQueue.main.async {
                self?.cacheData(updateWith: news)
            }
        }
        
    }
    
    private func cacheData(updateWith arrNews: [categoryStruct]) {
        guard arrNews.count > 0 else {
            // Call Cache
            print("No internet or API key is invalid :( ~> Using cache!")
            loadFromCache()
            return
        }
        
        // MARK: - Clear cache
        
        let request: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Article")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
        do {
            try contextArticles.execute(deleteRequest)
        } catch let error as NSError {
            print(error)
        }
        
        // MARK: - Save new
        for category in arrNews {
            for news in category.news {
                let article = Article(context: contextArticles)
                article.category    = category.title
                article.title       = news.title
                article.url         = news.url
                article.urlToImage  = news.urlToImage
                article.date        = news.date
            }
        }
        
        do {
            try contextArticles.save()
            loadFromCache()
        } catch {
            print("Havent saved :(")
        }
    }
    
    public func searchInCD(contains: String) {
        
        let request = Article.fetchRequest() as NSFetchRequest<Article>
        let pred = NSPredicate(format: "title CONTAINS '\(contains)' or category CONTAINS '\(contains)'")
        request.predicate = pred
        
        guard let articles = try? contextArticles.fetch(request) else {
            print("Error search load from Core Data!")
            return
        }
        mainDelegate.reloadTable(with: convertContextToCells(articles: articles))
    }
    
    private func loadFromCache() {
        guard let articles = try? contextArticles.fetch(Article.fetchRequest()) else {
            print("Fetching from cache error!")
            return
        }
        mainDelegate.reloadTable(with: convertContextToCells(articles: articles))
    }

    private func convertContextToCells(articles: [Article]) -> [categoryStruct] {
        let dict = Dictionary(grouping: articles, by: { $0.category! } )
        var news = [categoryStruct]()
        
        for key in dict.keys {
            
            var category = categoryStruct(title: key,
                                          news: dict[key]!.map { Article in
                                            return article(title: Article.title,
                                                           url: Article.url!,
                                                           urlToImage: Article.urlToImage,
                                                           date: Article.date!)
            })
            category.news.sort {
                $0.date < $1.date
            }
            
            news.append(category)
        }
        return news
    }
}
