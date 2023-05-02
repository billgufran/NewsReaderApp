//
//  ReadingListViewController.swift
//  NewsReaderApp
//
//  Created by Muhammad Fikri Bill Gufran on 2/5/23.
//

import UIKit
import SDWebImage
import SafariServices

class ReadingListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var readingList: [News] = []
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        tableView.register(UINib(nibName: "NewsViewCell", bundle: nil), forCellReuseIdentifier: "custom_news_cell")
        tableView.dataSource = self
        tableView.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.readingListAdded(_:)), name: .addReadingList, object: nil)
        
        loadReadingList()
    }
    
    @objc func readingListAdded(_ sender: Any) {
        loadReadingList()
        tableView.reloadData()
    }
    
    func loadReadingList() {
        readingList = CoreDataStorage.shared.getReadingList()
    }

}

// MARK: - UITableViewDataSource
extension ReadingListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return readingList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "custom_news_cell", for: indexPath) as! NewsViewCell
        
        let news = readingList[indexPath.row]
        
        cell.titleLabel.text = news.title
        cell.dateLabel.text = "\(news.publishDate) • \(news.section)"
        
        cell.bookmarkButton.isHidden = true
        
        if let url = news.media.first?.metadata.last?.url{
            cell.thumbImageView.sd_setImage(with: URL(string: url))
        }
        else {
            cell.thumbImageView.image = nil
        }
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension ReadingListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let news = readingList[indexPath.row]
        
        if let url = URL(string: news.url) {
            let controller = SFSafariViewController(url: url)
            present(controller, animated: true)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { _, _, completion in
            let news = self.readingList.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            
            CoreDataStorage.shared.deleteReadingList(newsId: news.id)
            
            completion(true)
        }
        
        if #available(iOS 13.0, *) {
            deleteAction.image = UIImage(systemName: "trash")
        } else {
            // Fallback on earlier versions
        }
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}
