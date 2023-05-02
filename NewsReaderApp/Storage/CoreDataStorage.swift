//
//  CoreDataStorage.swift
//  NewsReaderApp
//
//  Created by Muhammad Fikri Bill Gufran on 2/5/23.
//

import Foundation
import CoreData
import UIKit

class CoreDataStorage {
    static let shared: CoreDataStorage = CoreDataStorage()
    private init() {
        printCoreDataDBPath()
    }
    
    lazy var context: NSManagedObjectContext = {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.viewContext
    }()
    
    func printCoreDataDBPath() {
        let path = FileManager
            .default
            .urls(for: .applicationSupportDirectory, in: .userDomainMask)
            .last?
            .absoluteString
            .replacingOccurrences(of: "file://", with: "")
            .removingPercentEncoding

         print("Core Data DB Path :: \(path ?? "Not found")")
    }
    
    func addReadingList(news: News) {
        let newsData: NewsData
        
        let fetchRequest = NewsData.fetchRequest()
        
        // predicate is synonymous with WHERE
        fetchRequest.predicate = NSPredicate(format: "newsId = \(news.id)")
        
        if let data = try? context.fetch(fetchRequest).first {
            newsData = data
        } else {
            newsData = NewsData(context: context)
        }
        
        newsData.newsId = Int64(news.id)
        newsData.title = news.title
        newsData.url = news.url
        newsData.section = news.section
        newsData.publishDate = news.publishDate
        newsData.mediaUrl = news.media.first?.metadata.last?.url
        
        try? context.save()
    }
    
    func getReadingList() -> [News] {
        let fetchRequest = NewsData.fetchRequest()
        let data = (try? context.fetch(fetchRequest)) ?? []
        let newsList = data.compactMap { $0.dto } // return `newsData in newsData.dto`
        return newsList
    }
}

extension NewsData {
    var dto: News {
        let news = News(url: self.url ?? "", id: Int(self.newsId), publishDate: self.publishDate ?? "", section: self.section ?? "", title: self.title ?? "", mediaUrl: self.mediaUrl ?? "")
        return news
    }
}
